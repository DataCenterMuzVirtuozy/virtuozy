


 import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:virtuozy/components/box_info.dart';
import 'package:virtuozy/components/calendar/calendar.dart';
import 'package:virtuozy/components/dialogs/dialoger.dart';
import 'package:virtuozy/components/title_page.dart';
import 'package:virtuozy/domain/entities/subscription_entity.dart';
import 'package:virtuozy/domain/entities/user_entity.dart';
import 'package:virtuozy/resourses/colors.dart';
import 'package:virtuozy/router/paths.dart';
import 'package:virtuozy/utils/auth_mixin.dart';
 import 'package:badges/badges.dart' as badges;
import 'package:virtuozy/utils/date_time_parser.dart';
import '../../../components/buttons.dart';
import '../../../components/dialogs/sealeds.dart';
import '../../../components/drawing_menu_selected.dart';
import '../../../di/locator.dart';
import '../../../domain/entities/lesson_entity.dart';
import '../../../utils/parser_price.dart';
import '../../../utils/text_style.dart';
import '../finance_screen/bloc/bloc_finance.dart';
import '../finance_screen/bloc/event_finance.dart';
import 'bloc/sub_bloc.dart';
import 'bloc/sub_event.dart';
import 'bloc/sub_state.dart';


int globalCurrentMonthCalendar = 0;

class SubscriptionPage extends StatefulWidget{

  const SubscriptionPage({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage>{
  int _selIndexDirection = 0;
  final currentDayNotifi = locator.get<ValueNotifier<int>>();
  BonusEntity bonus = BonusEntity.unknown();
  List<String> _titlesDirections = [];
  bool _hasBonus = false;
  bool _resetFocus = false;
  bool _allViewDirection = false;




  @override
  void initState() {
    super.initState();
   context.read<SubBloc>().add(GetUserEvent(
       allViewDir: true,
       currentDirIndex: _selIndexDirection,
       refreshDirection: true));
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();



  }

  bool _visibleButtonBonus({required List<BonusEntity> bonuses}){
    if(bonuses.isEmpty){
      return false;
    }else{
       for(var b in bonuses){
         if(!b.active){
           return true;
         }
       }
    }
    return false;
  }



  @override
  Widget build(BuildContext context) {

    return BlocConsumer<SubBloc,SubState>(
     listener: (c,s){

        if(s.subStatus == SubStatus.confirm){
          context.read<BlocFinance>().add(WritingOfMoneyEvent(
              lessonConfirm:s.lessonConfirm,
              currentDirection: s.userEntity.directions[_selIndexDirection]));
        }

        if(s.subStatus == SubStatus.loaded){
          if(s.directions.length>1){
            _allViewDirection =true;
          }
          _titlesDirections = s.titlesDrawingMenu;
        }


     },
     builder: (context,state) {
       if(state.subStatus == SubStatus.unknown){
         return Container();
       }

       if(state.subStatus == SubStatus.loading){
         return Center(child: CircularProgressIndicator(color: colorOrange));
       }

       if(state.userEntity.userStatus.isModeration || state.userEntity.userStatus.isNotAuth){
         return Center(
           child: BoxInfo(
               buttonVisible: state.userEntity.userStatus.isNotAuth,
               title: state.userEntity.userStatus.isModeration?'Ваш аккаунт на модерации'.tr():'Абонементы недоступны'.tr(),
               description: state.userEntity.userStatus.isModeration?'На период модерации работа с абонементами недоступна'.tr():
               'Для работы с абонементами необходимо авторизироваться'.tr(),
               iconData: CupertinoIcons.music_note_list),
         );
       }






       if(state.directions.isEmpty && state.subStatus == SubStatus.loaded){
         return Center(
           child: BoxInfo(
               buttonVisible:false,
               title: 'Список пуст'.tr(),
               description: 'У вас нет направлений обучения'.tr(),
               iconData: CupertinoIcons.music_note_list),
         );
       }



       return Padding(
         padding: const EdgeInsets.symmetric(horizontal: 20.0),
         child: SingleChildScrollView(
           child: Column(
             children: [
               Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 10.0),
                 child: DrawingMenuSelected(items: _titlesDirections,
                   onSelected: (index){
                   _resetFocus = true;
                   _selIndexDirection = index;
                   if(index == _titlesDirections.length-1){
                     _allViewDirection = true;
                   }else{
                     _allViewDirection = false;
                   }
                   context.read<SubBloc>().add(GetUserEvent(
                       allViewDir: _allViewDirection,
                       currentDirIndex: _selIndexDirection,
                       refreshDirection: false));

                   },)
               ),
               const Gap(10.0),
                Calendar(
                  colorFill: Theme.of(context).colorScheme.surfaceVariant,
                  resetFocusDay: _resetFocus,
                  lessons: state.lessons,
                  onMonth: (month){
                    _resetFocus = false;
                     globalCurrentMonthCalendar = month;
                  },
                  onLesson: (List<Lesson> lessons){
                    Dialoger.showModalBottomMenu(
                      blurred: false,
                        title: 'Урок №${lessons[0].id} из ${lessons[0].id+5}',
                        args: [lessons,state.userEntity.directions],
                        content: DetailsLesson());
                  },),
               const Gap(10.0),
               BoxSubscription(
                 key: ValueKey(state.directions),
                 namesDir: _titlesDirections,
                   directions: state.directions,
                   allViewDirection: _allViewDirection),
               const Gap(10.0),
               Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 20.0),
                 child: Column(
                   children: [
                     Visibility(
                       visible: state.listNotAcceptLesson.isNotEmpty,
                       child: badges.Badge(
                         position: badges.BadgePosition.topEnd(end: -5.0,top: -8.0),
                         showBadge: state.listNotAcceptLesson.length>1,
                         badgeContent: Text('${state.listNotAcceptLesson.length}',
                             style: TStyle.textStyleVelaSansBold(colorWhite)),
                         child: SizedBox(
                           height: 40.0,
                           child: SubmitButton(
                             onTap: (){

                               Dialoger.showModalBottomMenu(
                                 blurred: false,
                                 args:[state.firstNotAcceptLesson,
                                   state.directions, state.listNotAcceptLesson,
                                    _allViewDirection],
                                   title:'Подтверждение урока'.tr(),
                               content: ConfirmLesson());
                             },
                             //colorFill: Theme.of(context).colorScheme.tertiary,
                                colorFill: colorGreen,
                                borderRadius: 10.0,
                                textButton:
                                    'Подтвердите прохождение урока'.tr(),
                              ),
                         ),
                       ),
                     ),
                     const Gap(10.0),
                     if(_visibleButtonBonus(bonuses: state.bonuses))...{
                       Padding(
                         padding: const EdgeInsets.only(bottom: 30.0),
                         child: badges.Badge(
                           position: badges.BadgePosition.topEnd(end: -5.0,top: -8.0),
                           showBadge: state.bonuses.length>1,
                           badgeContent: Text('${state.bonuses.length}',
                               style: TStyle.textStyleVelaSansBold(colorWhite)),
                           child: SizedBox(
                             height: 40.0,
                             child: OutLineButton(
                               onTap: () {
                                 if(state.bonuses.length>1){
                                   Dialoger.showModalBottomMenu(
                                       title: 'Получить бонусы'.tr(),
                                       blurred: true,
                                       args: state.bonuses,
                                       content: ListBonuses());


                                 }else{
                                   GoRouter.of(context).push(pathDetailBonus,
                                       extra: [
                                         state.bonuses[0],
                                         state.userEntity.directions[0]
                                       ]);
                                 }

                               },
                               borderRadius: 10.0,
                               textButton: state.bonuses.length > 1
                                   ? 'Получить бонусы'.tr()
                                   : state.bonuses[0].title,
                             ),
                           ),
                         ),
                       )

                     }
                   ],
                 ),
               )
             ],
           ),
         ).animate().fadeIn(duration: const Duration(milliseconds: 700)),
       );
     }
   );
  }
}


 class BoxSubscription extends StatefulWidget{
  const BoxSubscription({super.key,
  required this.directions,
    required this.allViewDirection,
   required this.namesDir
  });

  final List<DirectionLesson> directions;
  final bool allViewDirection;
  final List<String> namesDir;

  @override
  State<BoxSubscription> createState() => _BoxSubscriptionState();
}

class _BoxSubscriptionState extends State<BoxSubscription> {



   List<SubscriptionEntity> subs = [];

  double _summaBalance({required List<DirectionLesson> directions}){
     double sum = 0.0;
     for(var dir in directions){
       for(var s in dir.lastSubscriptions){
         sum +=s.balanceSub;
       }
     }
     return sum;
  }

  List<SubscriptionEntity> _getSubs({required List<DirectionLesson> directions, required bool allViewDirection}){
    List<SubscriptionEntity> list = [];
    for(var dir in directions){
      for(var s in dir.lastSubscriptions){
        list.add(s);
      }
    }
    return list;
  }


  @override
  void initState() {
    super.initState();
    subs = _getSubs(directions: widget.directions, allViewDirection: widget.allViewDirection);
  }

  @override
  Widget build(BuildContext context) {
    return            Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      padding: const EdgeInsets.all(20.0),
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(20.0)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text('Активные абонементы'.tr(),
              style:TStyle.textStyleVelaSansExtraBolt(Theme.of(context).textTheme.displayMedium!.color!,
              size: 18.0)),
          const Gap(10.0),
          Divider(color: colorGrey),
           Column(
             children: [
               ...List.generate(subs.length, (index) {

                 // if(widget.directions[index].lastSubscriptions.isEmpty){
                 //   return Container();
                 // }

                 return ItemSub(
                   onTap: (String nameDir){
                     if(widget.allViewDirection){
                       final selIndexDir = widget.namesDir.indexWhere((element) => element == nameDir);
                       GoRouter.of(context).push(pathFinance,extra: selIndexDir);
                     }else{
                       GoRouter.of(context).push(pathPay,extra: widget.directions);
                     }
                   },
                     subscription: subs[index]);

                 // return ItemSubscription(direction: directions[index],
                 //     allViewDirection: allViewDirection, namesDir: namesDir);
               })
             ],
           ),
           // BoxSubscription(directions: directions,allViewDirection: allViewDirection,
           // namesDir: namesDir),
          const Gap(5.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Container(
              //   margin: const EdgeInsets.only(top: 2.0),
              //   decoration: BoxDecoration(
              //       color: Theme.of(context).colorScheme.secondary,
              //       shape: BoxShape.circle
              //   ),
              //   child:  Icon(CupertinoIcons.money_rubl_circle,color: colorWhite,size: 20.0,),),

              Text('Общий баланс',style: TStyle.textStyleVelaSansBold(textColorBlack(context),size: 18),),
              const Gap(5.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Gap(15),
                  Text(ParserPrice.getBalance(_summaBalance(directions: widget.directions)),
                      style:TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!,size: 20.0)),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Icon(CupertinoIcons.money_rubl,color: Theme.of(context).iconTheme.color,size: 25.0,),
                  )
                ],
              ),
            ],
          ),
          const Gap(20.0),
          SizedBox(
            height: 40.0,
            child: SubmitButton(
              textButton: 'Пополнить'.tr(),
              onTap: () {
                GoRouter.of(context).push(pathPay,extra: widget.directions);
              }
            ),
          ),
          const Gap(5.0),
        ],
      ),
    );

  }
}


 class ItemSub extends StatefulWidget{
  const ItemSub({super.key, required this.subscription, required this.onTap});

  final SubscriptionEntity subscription;
  final Function onTap;

  @override
  State<ItemSub> createState() => _ItemSubState();
}

class _ItemSubState extends State<ItemSub> {


  bool _open = false;


  int _countAllLesson(SubscriptionEntity subscription){
    final i1 = subscription.price;
    final i2 = subscription.priceOneLesson;
    return i1~/i2;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 5.0),
    child: InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: (){
        setState(() {
          if(!_open){
            _open = true;
          }else{
            _open = false;
          }
        });
      },
      child: Column(
        children: [
          AnimatedContainer(
            height: !_open?50:125,
            curve: Curves.easeIn,
            duration: const Duration(milliseconds: 500),
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.subscription.nameDir,
                          style:TStyle.textStyleVelaSansBold(colorGrey,size: 16.0)),
                      if(widget.subscription.status==StatusSub.active||widget.subscription.status == StatusSub.planned)...{
                        Row(
                          children: [
                            Text('Осталось уроков:'.tr(),style:TStyle.textStyleVelaSansMedium(colorGrey,size: 14.0)),
                            const Gap(3.0),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6.0,vertical: 2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                //color: Theme.of(context).colorScheme.secondary,
                                //shape: BoxShape.circle
                              ),
                              child: Text('${widget.subscription.balanceLesson} из ${_countAllLesson(widget.subscription)}',
                                  style:TStyle.textStyleVelaSansExtraBolt(Theme.of(context).textTheme.displayMedium!.color!,
                                      size: 14.0)),
                            ),
                          ],
                        )
                      }else...{
                        Visibility(
                          visible: widget.subscription.status == StatusSub.inactive,
                          child:                     Container(
                            padding: const EdgeInsets.only(right: 8.0,left:8.0,bottom: 2.0),
                            decoration: BoxDecoration(
                                color: colorRed,
                                borderRadius: BorderRadius.circular(10.0)),
                            alignment: Alignment.center,
                            child: Text('неактивный'.tr(),
                                style: TStyle.textStyleVelaSansBold(colorWhite,
                                    size: 10.0)),
                          ),
                        ),
                      },


                    ],
                  ),
                  const Gap(5),
                  Visibility(
                    visible: widget.subscription.status == StatusSub.active||
                        widget.subscription.status == StatusSub.planned,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${ParserPrice.getBalance(widget.subscription.balanceSub)} руб.',
                            style:TStyle.textStyleVelaSansMedium(colorGrey,size: 16.0)),
                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(right: 8.0,left:8.0,bottom: 2.0),
                          decoration: BoxDecoration(
                              color: widget.subscription.status == StatusSub.active?colorGreen:
                              colorRed,
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Text(widget.subscription.status == StatusSub.active?'активный'.tr():
                          'запланирован'.tr(),
                              style: TStyle.textStyleVelaSansBold(colorWhite,
                                  size: 10.0))
                        )
                      ],
                    ),
                  ),


                    Visibility(
                      visible: widget.subscription.nameTeacher.isNotEmpty,
                      child: Row(
                        children: [
                          Icon(Icons.person,color: colorGreen,size: 10.0),
                          const Gap(5.0),
                          Text(widget.subscription.nameTeacher,
                              style:TStyle.textStyleVelaSansMedium(colorGrey,size: 13.0)),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: widget.subscription.dateEnd.isNotEmpty,
                      child: Row(
                        children: [
                          Icon(Icons.timelapse,color: colorGreen,size: 10.0),
                          const Gap(5.0),
                          Text('Дата окончания'.tr(),
                              style:TStyle.textStyleVelaSansMedium(colorGrey,size: 13.0)),
                          const Gap(5.0),
                          Text(DateTimeParser.getDateFromApi(date:
                          widget.subscription.dateEnd),
                              style:TStyle.textStyleVelaSansMedium(colorGrey,size: 13.0)),
                        ],
                      ),
                    ),

                    Visibility(
                      visible: widget.subscription.option.status!=OptionStatus.unknown,
                      child: Row(
                        children: [
                          Icon(widget.subscription.option.status == OptionStatus.freezing?Icons.icecream:
                          Icons.free_breakfast_outlined,color: colorGreen,size: 10),
                          const Gap(5),
                          Text(widget.subscription.option.status == OptionStatus.freezing?
                          'Заморозка до '.tr()
                              :'Каникулы до '.tr(),
                              style: TStyle.textStyleVelaSansMedium(colorGrey,
                                  size: 13.0)),
                          Text(DateTimeParser.getDateFromApi(date: widget.subscription.option.dateEnd),
                              style: TStyle.textStyleVelaSansMedium(colorGrey,
                                  size: 13.0)),
                        ],
                      ),
                    ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: (){
                        widget.onTap.call(widget.subscription.nameDir);
                      },
                        child: Text('Подробнее',style: TStyle.textStyleVelaSansRegularUnderline(colorGrey,size: 12),)),
                  )

                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 5),
            color: Colors.transparent,
            child: Column(
              children: [
                RotatedBox(
                    quarterTurns: !_open?1:3,
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: colorGrey,
                      size: 16.0,
                    )),
                Divider(color: colorGrey),
              ],
            ),
          )
        ],
      ),
    ),
    );
  }
}






