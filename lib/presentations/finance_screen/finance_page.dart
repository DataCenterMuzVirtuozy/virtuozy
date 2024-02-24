



 import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:virtuozy/components/buttons.dart';
import 'package:virtuozy/domain/entities/user_entity.dart';
import 'package:virtuozy/presentations/finance_screen/bloc/bloc_finance.dart';
import 'package:virtuozy/presentations/finance_screen/bloc/event_finance.dart';
import 'package:virtuozy/presentations/finance_screen/bloc/state_finance.dart';
import 'package:virtuozy/presentations/subscription_screen/bloc/sub_bloc.dart';
import 'package:virtuozy/resourses/colors.dart';
import 'package:virtuozy/router/paths.dart';
import 'package:virtuozy/utils/auth_mixin.dart';
import 'package:virtuozy/utils/parser_price.dart';

import '../../components/box_info.dart';
import '../../components/dialogs/dialoger.dart';
import '../../components/drawing_menu_selected.dart';
import '../../utils/text_style.dart';

class FinancePage extends StatefulWidget{
  const FinancePage({super.key});



  @override
  State<FinancePage> createState() => _FinancePageState();
}

class _FinancePageState extends State<FinancePage> {

  int _selIndexDirection = 0;
  bool _hasBonus = false;
  bool _allViewDirection = false;
  List<String> _titlesDirections = [];



  @override
  void initState() {
    super.initState();
  context.read<BlocFinance>().add(GetBalanceSubscriptionEvent(
    refreshDirection: true,
      indexDirection: _selIndexDirection, allViewDir: false));
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

  }


  double _summaBalance({required List<DirectionLesson> directions}){
    double sum = 0.0;
    for(var dir in directions){
      sum +=dir.subscription.balanceSub;
    }

    return sum;
  }

  @override
  Widget build(BuildContext context) {




   return BlocConsumer<BlocFinance,StateFinance>(
     listener: (c,s){

       if(s.applyBonusStatus == ApplyBonusStatus.loading){
         _hasBonus = false;
       }



       if(s.status == FinanceStatus.loaded){
         // if(s.user.directions[_selIndexDirection].bonus.isNotEmpty){
         //   _hasBonus = s.user.directions[_selIndexDirection].bonus[0].active;
         // }else{
         //   _hasBonus = false;
         // }

         int length = s.user.directions.length;
         _titlesDirections = s.user.directions.map((e) => e.name).toList();
         if(length>1){
           _titlesDirections.insert(length, 'Все направления'.tr());
         }

       }

     },
     builder: (context,state) {

       if(state.status == FinanceStatus.loading){
         return const Center(child: CircularProgressIndicator());
       }

       if(state.user.userStatus.isModeration || state.user.userStatus.isNotAuth){
         return Center(
           child: BoxInfo(
               buttonVisible: state.user.userStatus.isNotAuth,
               title: state.user.userStatus.isModeration?'Ваш аккаунт на модерации'.tr():'Финансы недоступны'.tr(),
               description: state.user.userStatus.isModeration?'На период модерации работа с финансами недоступна'.tr():
               'Для работы с балансом счета необходимо авторизироваться'.tr(),
               iconData: CupertinoIcons.creditcard),
         );
       }


       return Padding(
         padding: const EdgeInsets.symmetric(horizontal: 20.0),
         child: SingleChildScrollView(
           child: Column(
             children: [
               DrawingMenuSelected(items: _titlesDirections,
                 onSelected: (index){
                   _selIndexDirection = index;
                   if(index == _titlesDirections.length-1){
                     _allViewDirection = true;
                   }else{
                     _allViewDirection = false;
                   }

                   context.read<BlocFinance>().add(GetBalanceSubscriptionEvent(
                       indexDirection: _selIndexDirection,
                       refreshDirection: false,
                       allViewDir: _allViewDirection));
               },),
               const Gap(20.0),
               Container(
                 decoration: BoxDecoration(
                   color: Theme.of(context).colorScheme.surfaceVariant,
                   borderRadius: BorderRadius.circular(20.0)
                 ),
                 child: Stack(
                   alignment: Alignment.bottomRight,
                   children: [
                     Column(
                       crossAxisAlignment: CrossAxisAlignment.center,
                       children: [
                         const Gap(20.0),
                         Text('Баланс счета'.tr(),style: TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!,size: 16.0)),
                         Row(
                           crossAxisAlignment: CrossAxisAlignment.center,
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             Text(ParserPrice.getBalance(_summaBalance(directions: state.directions)),
                                 style: TStyle.textStyleVelaSansExtraBolt(Theme.of(context).textTheme.displayMedium!.color!,size: 30.0)),
                             Padding(
                               padding: const EdgeInsets.only(top: 5.0),
                               child: Icon(CupertinoIcons.money_rubl,color: Theme.of(context).textTheme.displayMedium!.color!,size: 35.0),
                             )
                           ],
                         ),
                         const Gap(10.0),
                         ...List.generate(state.directions.length, (index) {
                           return Container(
                            margin: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                                color: colorBeruza.withOpacity(0.3),
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    topRight: Radius.circular(20.0),
                                    bottomRight: Radius.circular(20.0),
                                    bottomLeft: Radius.circular(20.0))),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 15.0,right: 15.0,top: 10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                            state.directions[index]
                                                .subscription.name,
                                            style: TStyle.textStyleVelaSansBold(
                                                Theme.of(context)
                                                    .textTheme
                                                    .displayMedium!
                                                    .color!,
                                                size: 16.0)),
                                      ),
                                      Visibility(
                                        visible:   state.directions[index]
                                            .subscription.balanceSub>0.0,
                                        child: Container(
                                          width: 90.0,
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.only(right: 8.0,left:8.0,bottom: 2.0),
                                          decoration: BoxDecoration(
                                              color: colorGreen,
                                              borderRadius: BorderRadius.circular(10.0)),
                                          child: Text('активный',
                                              style:TStyle.textStyleVelaSansBold(colorWhite,size: 10.0)),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const Gap(5.0),
                                Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      if(state.directions[index].subscription.balanceSub>0.0)...{
                                        Row(
                                          children: [
                                            Text('Осталось уроков '.tr(),
                                                style: TStyle
                                                    .textStyleVelaSansMedium(
                                                    Theme.of(context)
                                                        .textTheme
                                                        .displayMedium!
                                                        .color!,
                                                    size: 14.0)),
                                            Text(
                                                '${ state.directions[index].subscription.balanceLesson}',
                                                style: TStyle
                                                    .textStyleVelaSansBold(
                                                    Theme.of(context)
                                                        .textTheme
                                                        .displayMedium!
                                                        .color!,
                                                    size: 14.0)),
                                          ],
                                        )
                                      }else ...{
                                        Container(
                                          alignment: Alignment.center,
                                          width: 100.0,
                                          padding: const EdgeInsets.only(right: 8.0,left:8.0,bottom: 2.0),
                                          decoration: BoxDecoration(
                                              color: colorRed,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      10.0)),
                                          child: Text('неактивный',
                                              style: TStyle
                                                  .textStyleVelaSansBold(
                                                      colorWhite,
                                                      size: 10.0)),
                                        ),
                                      },
                                      SizedBox(
                                        width: 50.0,
                                        height: 50.0,
                                        child: FloatingActionButton(onPressed: (){
                                          GoRouter.of(context).push(pathPay,extra:state.directions[index]);
                                        },
                                          backgroundColor: colorBeruza,
                                          child:  Icon(Icons.add,color: colorWhite,),),
                                      )
                                    ],
                                  ),
                                ),


                              ],
                            ),
                          );
                        })
                       ],
                     ),
                   ],
                 ),
               ),
               const Gap(20.0),
               GestureDetector(
                 onTap: (){
                   GoRouter.of(context).push(pathListSubscriptionsHistory);
                 },
                 child: Container(
                   padding: const EdgeInsets.symmetric(vertical: 20.0,horizontal: 20.0),
                   decoration: BoxDecoration(
                       color: Theme.of(context).colorScheme.surfaceVariant,
                       borderRadius: BorderRadius.circular(20.0)
                   ),
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Expanded(child: Text('История абонементов'.tr(),
                           style: TStyle.textStyleVelaSansMedium(Theme.of(context).textTheme.displayMedium!.color!,size: 22.0))),
                       Icon(Icons.arrow_forward_ios_rounded,color: Theme.of(context).textTheme.displayMedium!.color!)
                     ],
                   ),
                 ),
               ),
               const Gap(20.0),
               GestureDetector(
                 onTap: (){
                   GoRouter.of(context).push(pathListTransaction);
                 },
                 child: Container(
                   padding: const EdgeInsets.symmetric(vertical: 20.0,horizontal: 20.0),
                   decoration: BoxDecoration(
                       color: Theme.of(context).colorScheme.surfaceVariant,
                       borderRadius: BorderRadius.circular(20.0)
                   ),
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Text('Операции по счету'.tr(),style: TStyle.textStyleVelaSansMedium(Theme.of(context).textTheme.displayMedium!.color!,size: 22.0)),
                       Icon(Icons.arrow_forward_ios_rounded,color: Theme.of(context).textTheme.displayMedium!.color!)
                     ],
                   ),
                 ),
               ),
               const Gap(20.0),

               if(state.applyBonusStatus == ApplyBonusStatus.loading)...{
                 const CircularProgressIndicator()
               },


               Visibility(
                 visible: _hasBonus,
                 child: Container(
                   padding: const EdgeInsets.symmetric(vertical: 20.0,horizontal: 20.0),
                   decoration: BoxDecoration(
                       color: colorBeruzaLight,
                       borderRadius: BorderRadius.circular(20.0)
                   ),
                   child: Column(
                     children: [
                       Text('1 бонусный урок',
                           style: TStyle.textStyleGaretHeavy(colorBlack,size: 22.0)),
                       const Gap(20.0),
                      SubmitButton(
                        onTap: (){
                          Dialoger.showMessage('В разработке');
                          // context.read<BlocFinance>().add(ApplyBonusEvent(
                          //     idBonus: state.directions[_selIndexDirection].bonus[0].id,
                          //     currentDirection: state.directions[_selIndexDirection]));
                        },
                        borderRadius: 10.0,
                        textButton: 'Потратить'.tr(),
                      )
                     ],
                   ),
                 ),
               )


             ],
           ),
         ),
       );
     }
   );
  }
}

class StatusSubscriptionWidget extends StatelessWidget{
  const StatusSubscriptionWidget({super.key, required this.direction});

  final DirectionLesson direction;

  @override
  Widget build(BuildContext context) {
   return Column(
     children: [
       Visibility(
         visible:  direction
             .subscription.balanceSub>0.0,
         child: Container(
           width: 90.0,
           alignment: Alignment.center,
           padding: const EdgeInsets.only(right: 8.0,left:8.0,bottom: 2.0),
           decoration: BoxDecoration(
               color: colorGreen,
               borderRadius: BorderRadius.circular(10.0)),
           child: Text('активный',
               style:TStyle.textStyleVelaSansBold(colorWhite,size: 10.0)),
         ),
       ),
     ],
   );
  }

}