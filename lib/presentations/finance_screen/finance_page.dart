



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



  @override
  void initState() {
    super.initState();
  context.read<BlocFinance>().add(GetBalanceSubscriptionEvent(indexDirection: _selIndexDirection));
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

  }

  @override
  Widget build(BuildContext context) {




   return BlocConsumer<BlocFinance,StateFinance>(
     listener: (c,s){

       if(s.applyBonusStatus == ApplyBonusStatus.loading){
         _hasBonus = false;
       }



       if(s.status == FinanceStatus.loaded){
         if(s.user.directions[_selIndexDirection].bonus.isNotEmpty){
           _hasBonus = s.user.directions[_selIndexDirection].bonus[0].active;
         }else{
           _hasBonus = false;
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
               DrawingMenuSelected(items: state.directions.map((e) => e.name).toList(),
                 onSelected: (index){
                    setState(() {
                       _selIndexDirection = index;
                    });
               },),
               const Gap(20.0),
               Container(
                 decoration: BoxDecoration(
                   color: colorBeruzaLight,
                   borderRadius: BorderRadius.circular(20.0)
                 ),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.center,
                   children: [
                     const Gap(20.0),
                     Text('Баланс счета'.tr(),style: TStyle.textStyleVelaSansBold(colorBlack,size: 16.0)),
                     Row(
                       crossAxisAlignment: CrossAxisAlignment.center,
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Text(ParserPrice.getBalance(state.directions[_selIndexDirection].subscription.balanceSub),
                             style: TStyle.textStyleVelaSansExtraBolt(colorBlack,size: 30.0)),
                         Padding(
                           padding: const EdgeInsets.only(top: 2.0),
                           child: Icon(CupertinoIcons.money_rubl,color: colorBlack,size: 35.0),
                         )
                       ],
                     ),
                     const Gap(10.0),
                     Container(
                       padding: const EdgeInsets.only(left: 10.0),
                       margin: const EdgeInsets.all(5.0),
                       decoration: BoxDecoration(
                         color: colorBeruza.withOpacity(0.3),
                         borderRadius: const BorderRadius.only(topLeft: Radius.circular(10.0),topRight: Radius.circular(20.0),
                         bottomRight: Radius.circular(20.0),bottomLeft: Radius.circular(20.0))
                       ),
                       child: Row(
                         crossAxisAlignment: CrossAxisAlignment.end,
                         children: [
                           Expanded(
                             child: Padding(
                               padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 5.0),
                               child: Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   Text(state.directions[_selIndexDirection].subscription.name,
                                       style: TStyle.textStyleVelaSansBold(colorBlack,size: 16.0)),
                                   const Gap(5.0),
                                   Row(
                                     children: [
                                       Text('Осталось уроков '.tr(),style: TStyle.textStyleVelaSansMedium(colorBlack,size: 14.0)),
                                       Text('${state.directions[_selIndexDirection].subscription.balanceLesson}',
                                           style: TStyle.textStyleVelaSansMedium(colorBlack,size: 14.0)),
                                     ],
                                   ),
                                 ],
                               ),
                             ),
                           ),
                           const Gap(10.0),
                           FloatingActionButton(onPressed: (){
                             GoRouter.of(context).push(pathPay,extra:state.directions[_selIndexDirection]);
                           },
                             backgroundColor: colorBeruza,
                             child:  Icon(Icons.add,color: colorWhite,),)
                         ],
                       ),
                     )
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
                       color: colorBeruzaLight,
                       borderRadius: BorderRadius.circular(20.0)
                   ),
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Expanded(child: Text('История абонементов'.tr(),
                           style: TStyle.textStyleVelaSansMedium(colorBlack,size: 22.0))),
                       Icon(Icons.arrow_forward_ios_rounded,color: colorBlack)
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
                       color: colorBeruzaLight,
                       borderRadius: BorderRadius.circular(20.0)
                   ),
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Text('Операции по счету'.tr(),style: TStyle.textStyleVelaSansMedium(colorBlack,size: 22.0)),
                       Icon(Icons.arrow_forward_ios_rounded,color: colorBlack)
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