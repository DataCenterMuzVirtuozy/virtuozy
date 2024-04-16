



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
import 'package:virtuozy/resourses/colors.dart';
import 'package:virtuozy/router/paths.dart';
import 'package:virtuozy/utils/auth_mixin.dart';
import 'package:virtuozy/utils/parser_price.dart';

import '../../../components/app_bar.dart';
import '../../../components/box_info.dart';
import '../../../components/dialogs/dialoger.dart';
import '../../../components/drawing_menu_selected.dart';
import '../../../domain/entities/subscription_entity.dart';
import '../../../utils/date_time_parser.dart';
import '../../../utils/text_style.dart';
import 'bloc/bloc_finance.dart';
import 'bloc/event_finance.dart';
import 'bloc/state_finance.dart';



class FinancePage extends StatefulWidget{
  const FinancePage({super.key, required this.selIndexDirection});


  final int selIndexDirection;



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

    if(widget.selIndexDirection>0){
      _selIndexDirection = widget.selIndexDirection;
    }
  context.read<BlocFinance>().add(GetBalanceSubscriptionEvent(
    refreshDirection: true,
      indexDirection: _selIndexDirection,
      allViewDir: widget.selIndexDirection<0?true:false));
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

  }


  double _summaBalance({required List<DirectionLesson> directions}){
    double sum = 0.0;
    for(var dir in directions){
      for(var s in dir.lastSubscriptions){
        sum +=s.balanceSub;
      }


    }

    return sum;
  }

  @override
  Widget build(BuildContext context) {




   return Scaffold(
       appBar: widget.selIndexDirection<0?null:const AppBarCustom(title: ''),
     body: BlocConsumer<BlocFinance,StateFinance>(
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

           if(s.directions.length>1){
             _allViewDirection =true;
           }
           _titlesDirections = s.titlesDrawingMenu;
         }

       },
       builder: (context,state) {

         if(state.status == FinanceStatus.loading){
           return const Center(child: CircularProgressIndicator());
         }

         if(state.user.userStatus.isModeration ||
             state.user.userStatus.isNotAuth&&state.status == FinanceStatus.loaded){
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
           padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 20.0),
           child: SingleChildScrollView(
             child: Column(
               children: [
                 DrawingMenuSelected(
                   initTitle: _titlesDirections.isNotEmpty?_titlesDirections[_selIndexDirection]:'',
                   items: _titlesDirections,
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
                   padding: const EdgeInsets.symmetric(vertical: 20.0),
                   decoration: BoxDecoration(
                     color: Theme.of(context).colorScheme.surfaceVariant,
                     borderRadius: BorderRadius.circular(20.0)
                   ),
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.center,
                     children: [
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
                       Padding(
                         padding: const EdgeInsets.symmetric(horizontal: 20.0),
                         child: SizedBox(
                           height: 40.0,
                           child: SubmitButton(
                             borderRadius: 20.0,
                              colorFill: colorBeruza,
                               textButton: 'Пополнить'.tr(),
                               onTap: () {
                                 GoRouter.of(context).push(pathPay,extra:state.directions);
                               }
                           ),
                         ),
                       ),
                     ],
                   ),
                 ),
                 const Gap(10.0),
                 ...List.generate(state.expiredSubscriptions.length, (index) {
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
                           padding: const EdgeInsets.only(left: 20.0,right: 15.0,top: 10.0),
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               Expanded(
                                 child: Text(
                                     state.expiredSubscriptions[index].name,
                                     style: TStyle.textStyleVelaSansBold(
                                         Theme.of(context)
                                             .textTheme
                                             .displayMedium!
                                             .color!,
                                         size: 16.0)),
                               ),
                               Visibility(
                                 visible:  state.expiredSubscriptions[index].status==StatusSub.active,
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
                         Visibility(
                           visible: state.expiredSubscriptions[index].nameTeacher.isNotEmpty&&
                               state.expiredSubscriptions[index].status==StatusSub.active,
                           child: Padding(
                             padding: const EdgeInsets.only(left: 20.0,right: 15.0,bottom: 8),
                             child: Row(
                               children: [
                                 // Icon(Icons.person,color: colorGreen,size: 15.0),
                                 // const Gap(5.0),
                                 Text(state.expiredSubscriptions[index].nameTeacher,
                                     style:TStyle.textStyleVelaSansMedium(colorGrey,size: 14.0)),
                               ],
                             ),
                           ),
                         ),

                   //todo test date end
                   Visibility(
                           visible: false,
                           child: Padding(
                             padding: const EdgeInsets.only(left: 20.0,bottom: 5.0),
                             child: Row(
                               children: [
                                 Row(
                                   children: [
                                     Text('Дата окончания'.tr(),
                                         style: TStyle.textStyleVelaSansRegular( Theme.of(context)
                                         .textTheme
                                         .displayMedium!
                                         .color!,size: 10.0)),
                                     const Gap(5.0),
                                     Text(DateTimeParser.getDateFromApi(date: state.expiredSubscriptions[index].dateEnd),
                                         style: TStyle.textStyleVelaSansBold( Theme.of(context)
                                         .textTheme
                                         .displayMedium!
                                         .color!,size: 10.0))
                                   ],
                                 ),
                               ],


                             ),
                           ),
                         ),
                         const Gap(5.0),
                         Padding(
                           padding: const EdgeInsets.only(left: 20.0,right: 20.0,bottom: 5.0),
                           child: Row(
                             crossAxisAlignment: CrossAxisAlignment.center,
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               if(state.expiredSubscriptions[index].status==StatusSub.active)...{
                                 Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                     Row(
                                       children: [
                                         Text('Осталось уроков: '.tr(),
                                             style: TStyle
                                                 .textStyleVelaSansMedium(
                                                 Theme.of(context)
                                                     .textTheme
                                                     .displayMedium!
                                                     .color!,
                                                 size: 14.0)),
                                         Text(
                                             '${ state.expiredSubscriptions[index].balanceLesson}',
                                             style: TStyle
                                                 .textStyleVelaSansBold(
                                                 Theme.of(context)
                                                     .textTheme
                                                     .displayMedium!
                                                     .color!,
                                                 size: 14.0)),
                                       ],
                                     ),
                                     const Gap(3.0),
                                     Row(
                                       children: [
                                         Text('Дата окончания'.tr(),style: TStyle.textStyleVelaSansRegular( Theme.of(context)
                                             .textTheme
                                             .displayMedium!
                                             .color!,size: 10.0)),
                                         const Gap(5.0),
                                         Text(' ${DateTimeParser.getDateFromApi(date: state.expiredSubscriptions[index].dateEnd)}',
                                             style: TStyle.textStyleVelaSansBold( Theme.of(context)
                                             .textTheme
                                             .displayMedium!
                                             .color!,size: 10.0))
                                       ],
                                     ),
                                     Visibility(
                                       visible: state.expiredSubscriptions[index].option.status!=OptionStatus.unknown,
                                       child: Row(
                                         children: [
                                           Text(state.expiredSubscriptions[index].option.status == OptionStatus.freezing?
                                           'Заморозка до '.tr()
                                               :'Каникулы до '.tr(),
                                               style: TStyle.textStyleVelaSansRegular(Theme.of(context)
                                                   .textTheme
                                                   .displayMedium!
                                                   .color!,
                                                   size: 10.0)),
                                           Text(DateTimeParser.getDateFromApi(date: state.expiredSubscriptions[index].option.dateEnd),
                                               style: TStyle.textStyleVelaSansBold(Theme.of(context)
                                                   .textTheme
                                                   .displayMedium!
                                                   .color!,
                                                   size: 10.0)),
                                         ],
                                       ),
                                     )


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
                                   child: Text(
                                       state.expiredSubscriptions[index].status==StatusSub.inactive?'неактивный'.tr():
                                       'запланирован'.tr(),
                                       style: TStyle
                                           .textStyleVelaSansBold(
                                           colorWhite,
                                           size: 10.0)),
                                 ),
                               },
                               Visibility(
                                 visible: _allViewDirection,
                                 child: Text(
                                     state.expiredSubscriptions[index].nameDir,
                                     style: TStyle.textStyleVelaSansBold(
                                         Theme.of(context)
                                             .textTheme
                                             .displayMedium!
                                             .color!,
                                         size: 13.0)),
                               )
                             ],
                           ),
                         ),
                         const Gap(10.0)
                       ],
                     ),
                   );
                 }),

                 const Gap(20.0),
                 GestureDetector(
                   onTap: (){
                     GoRouter.of(context).push(pathListSubscriptionsHistory,extra: state.subscriptionHistory);
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
                     GoRouter.of(context).push(pathListTransaction,extra: state.directions);
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
                 GestureDetector(
                   onTap: (){
                     GoRouter.of(context).push(pathBonusLessons);
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
                         Expanded(child: Text('Бонусные уроки'.tr(),
                             style: TStyle.textStyleVelaSansMedium(Theme.of(context).textTheme.displayMedium!.color!,size: 22.0))),
                         Icon(Icons.arrow_forward_ios_rounded,color: Theme.of(context).textTheme.displayMedium!.color!)
                       ],
                     ),
                   ),
                 ),

                 if(state.applyBonusStatus == ApplyBonusStatus.loading)...{
                   const CircularProgressIndicator()
                 },




               ],
             ),
           ),
         );
       }
     ),
   );
  }
}

class StatusSubscriptionWidget extends StatelessWidget{
  const StatusSubscriptionWidget({super.key, required this.subscriptionEntity});

  final SubscriptionEntity subscriptionEntity;

  @override
  Widget build(BuildContext context) {
   return Column(
     children: [
       Visibility(
         visible:  subscriptionEntity.balanceSub>0.0,
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