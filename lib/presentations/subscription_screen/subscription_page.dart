


 import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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




  @override
  void initState() {
    super.initState();
   context.read<SubBloc>().add(GetUserEvent(currentDirIndex: _selIndexDirection,
   refreshDirection: false));
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

  }



  @override
  Widget build(BuildContext context) {

    return BlocConsumer<SubBloc,SubState>(
     listener: (c,s){
        if(s.subStatus == SubStatus.confirm){
          context.read<BlocFinance>().add(WritingOfMoneyEvent(currentDirection: s.userEntity.directions[_selIndexDirection]));
        }




        if(s.subStatus == SubStatus.loaded){
          if(s.userEntity.directions[_selIndexDirection].bonus.isNotEmpty){
            bonus = s.userEntity.directions[_selIndexDirection].bonus[0];
            if(bonus.active){
              _hasBonus = false;
            }else{
              _hasBonus = true;
            }

          }else{
            _hasBonus = false;
          }
          int length = s.userEntity.directions.length;
          _titlesDirections = s.userEntity.directions.map((e) => e.name).toList();
          if(length>1){
           _titlesDirections.insert(length, 'Все направления'.tr());
          }
        }


     },
     builder: (context,state) {
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


       if(state.userEntity.directions.isEmpty && state.subStatus == SubStatus.loaded){
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
                     _selIndexDirection = index;
                     context.read<SubBloc>().add(GetUserEvent(currentDirIndex: _selIndexDirection,
                     refreshDirection: true));

                   },)
               ),
               const Gap(10.0),
                Calendar(lessons: state.userEntity.directions[_selIndexDirection].lessons,
                  onMonth: (month){
                     globalCurrentMonthCalendar = month;
                  },
                  onLesson: (lesson){
                    Dialoger.showModalBottomMenu(
                      blurred: false,
                        title: 'Урок'.tr(),
                        context: context,
                        args: [lesson,state.userEntity.directions[_selIndexDirection]],
                        content: DetailsLesson());
                  },),
               const Gap(10.0),
               Column(
                 children: List.generate(1, (index) {
                  return  ItemSubscription(
                      direction: state.userEntity.directions[_selIndexDirection]);
                 }),
               ),
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
                                   state.userEntity.directions[_selIndexDirection],state.listNotAcceptLesson],
                                   title:'Подтверждение урока'.tr(),context: context,
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
                       visible: _hasBonus,
                       child: SizedBox(
                         height: 40.0,
                         child: OutLineButton(
                           onTap: (){
                                GoRouter.of(context).push(pathDetailBonus, extra:
                                [bonus,
                                  state.userEntity.directions[_selIndexDirection]]);
                           },
                           borderRadius: 10.0,
                           textButton: bonus.title,
                         ),
                       ),
                     ),
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
  required this.direction});

  final DirectionLesson direction;




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
          //todo local
          Text('Баланс абонемента'.tr(),
              style:TStyle.textStyleVelaSansExtraBolt(Theme.of(context).textTheme.displayMedium!.color!,
              size: 18.0)),
          const Gap(5.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(direction.name,
                  style:TStyle.textStyleVelaSansMedium(colorGrey,size: 16.0)),
              Row(
                children: [
                  Text('Осталось уроков '.tr(),style:TStyle.textStyleVelaSansMedium(colorGrey,size: 14.0)),
                  const Gap(5.0),
                  Container(
                    padding: const EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        shape: BoxShape.circle),
                    child: Text('${direction.subscription.balanceLesson}',
                        style:TStyle.textStyleVelaSansBold(colorWhite,size: 10.0)),
                  ),
                ],
              ),
            ],
          ),
          const Gap(5.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    shape: BoxShape.circle
                ),
                child: Icon(CupertinoIcons.money_rubl_circle,color: colorWhite,size: 20.0,),),
              const Gap(5.0),
              Row(
                children: [
                  Text(ParserPrice.getBalance(direction.subscription.balanceSub),
                      style:TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!,size: 25.0)),
                  Icon(CupertinoIcons.money_rubl,color: Theme.of(context).iconTheme.color,size: 30.0,)
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
                GoRouter.of(context).push(pathPay,extra: direction);
              }
            ),
          )
        ],
      ),
    );

  }





 }

