


 import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:virtuozy/components/box_info.dart';
import 'package:virtuozy/components/calendar.dart';
import 'package:virtuozy/components/dialogs/dialoger.dart';
import 'package:virtuozy/domain/entities/user_entity.dart';
import 'package:virtuozy/presentations/finance_screen/bloc/bloc_finance.dart';
import 'package:virtuozy/presentations/finance_screen/bloc/event_finance.dart';
import 'package:virtuozy/presentations/subscription_screen/bloc/sub_bloc.dart';
import 'package:virtuozy/presentations/subscription_screen/bloc/sub_event.dart';
import 'package:virtuozy/resourses/colors.dart';
import 'package:virtuozy/router/paths.dart';
import 'package:virtuozy/utils/auth_mixin.dart';
 import 'package:badges/badges.dart' as badges;
import '../../components/buttons.dart';
import '../../components/dialogs/sealeds.dart';
import '../../components/drawing_menu_selected.dart';
import '../../di/locator.dart';
import '../../utils/parser_price.dart';
import '../../utils/text_style.dart';
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
       allViewDir: false,
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
          context.read<BlocFinance>().add(WritingOfMoneyEvent(currentDirection: s.userEntity.directions[_selIndexDirection]));
        }

        if(s.subStatus == SubStatus.loaded){
          _titlesDirections = s.titlesDrawingMenu;
        }


     },
     builder: (context,state) {

       print('State ${state.subStatus}');
       if(state.subStatus == SubStatus.unknown){
         return Container();
       }

       if(state.subStatus == SubStatus.loading){
         return Center(child: CircularProgressIndicator(color: colorOrange));
       }

       if(state.userEntity.userStatus.isModeration || state.userEntity.userStatus.isModeration){
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
                  resetFocusDay: _resetFocus,
                  lessons: state.lessons,
                  onMonth: (month){
                    _resetFocus = false;
                     globalCurrentMonthCalendar = month;
                  },
                  onLesson: (lessons){
                    Dialoger.showModalBottomMenu(
                      blurred: false,
                        title: 'Урок'.tr(),
                        args: [lessons,state.userEntity.directions],
                        content: DetailsLesson());
                  },),
               const Gap(10.0),
               ItemSubscription(directions: state.directions,allViewDirection: _allViewDirection),
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
                     Visibility(
                       visible: _visibleButtonBonus(bonuses: state.bonuses),
                       child: Padding(
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
                       ),
                     )
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


 class ItemSubscription extends StatelessWidget{
  const ItemSubscription({super.key,
  required this.directions, required this.allViewDirection});

  final List<DirectionLesson> directions;
  final bool allViewDirection;

  double _summaBalance({required List<DirectionLesson> directions}){
     double sum = 0.0;
     for(var dir in directions){
       sum +=dir.subscription.balanceSub;
     }

    return sum;
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

          Text(directions.length>1?'Баланс абонементов'.tr():'Баланс абонемента'.tr(),
              style:TStyle.textStyleVelaSansExtraBolt(Theme.of(context).textTheme.displayMedium!.color!,
              size: 18.0)),
          const Gap(10.0),
          ...List.generate(directions.length, (index) {

            return Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(directions[index].name,
                          style:TStyle.textStyleVelaSansMedium(colorGrey,size: 16.0)),
                      if(directions[index].subscription.balanceSub>0.0)...{
                        Row(
                          children: [
                            Text('Осталось уроков '.tr(),style:TStyle.textStyleVelaSansMedium(colorGrey,size: 14.0)),
                            const Gap(5.0),
                            Container(
                              padding: const EdgeInsets.all(3.0),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.secondary,
                                  shape: BoxShape.circle),
                              child: Text('${directions[index].subscription.balanceLesson}',
                                  style:TStyle.textStyleVelaSansBold(colorWhite,size: 10.0)),
                            ),
                          ],
                        )
                      }else ...{
                        Container(
                          padding: const EdgeInsets.only(right: 8.0,left:8.0,bottom: 2.0),
                          decoration: BoxDecoration(
                              color: colorRed,
                              borderRadius: BorderRadius.circular(10.0)),
                          alignment: Alignment.center,
                          child: Text('неактивный',
                              style: TStyle.textStyleVelaSansBold(colorWhite,
                                  size: 10.0)),
                        ),
                      }


                    ],
                  ),
                  const Gap(5.0),
                  Visibility(
                    visible: directions[index].subscription.balanceSub>0.0&&allViewDirection,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${ParserPrice.getBalance(directions[index].subscription.balanceSub)} руб.',
                            style:TStyle.textStyleVelaSansMedium(colorGrey,size: 16.0)),
                        Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(right: 8.0,left:8.0,bottom: 2.0),
                          decoration: BoxDecoration(
                              color: colorGreen,
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Text('активный',
                              style:TStyle.textStyleVelaSansBold(colorWhite,size: 10.0)),
                        ),
                      ],
                    ),
                  ),
                  const Gap(5.0),
                  Visibility(
                    visible: directions.length>1,
                      child: const Divider()),

                ],
              ),
            );
          }),
          const Gap(5.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 2.0),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    shape: BoxShape.circle
                ),
                child: Icon(CupertinoIcons.money_rubl_circle,color: colorWhite,size: 20.0,),),
              const Gap(5.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(ParserPrice.getBalance(_summaBalance(directions: directions)),
                      style:TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!,size: 25.0)),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Icon(CupertinoIcons.money_rubl,color: Theme.of(context).iconTheme.color,size: 30.0,),
                  )
                ],
              ),
            ],
          ),
          const Gap(10.0),
          SizedBox(
            height: 40.0,
            child: SubmitButton(
              textButton: 'Пополнить'.tr(),
              onTap: () {
                GoRouter.of(context).push(pathPay,extra: directions);
              }
            ),
          )
        ],
      ),
    );

  }





 }

