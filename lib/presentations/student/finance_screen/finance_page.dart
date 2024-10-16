



 import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:virtuozy/components/buttons.dart';
import 'package:virtuozy/components/teacher_contacts.dart';
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
import '../subscription_screen/subscription_page.dart';
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

  Future<void> _refreshData() async {
    context.read<BlocFinance>().add(RefreshSubscriptionEvent(
        refreshDirection: true,
        indexDirection: _selIndexDirection,
        allViewDir: widget.selIndexDirection<0?true:false));
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
           child: RefreshIndicator(
             onRefresh: (){
               return _refreshData();
             },
             child: SingleChildScrollView(
               physics: const AlwaysScrollableScrollPhysics(),
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
                       color: Theme.of(context).colorScheme.surfaceContainerHighest,
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
                   Visibility(
                     visible: ParserPrice.getBalance(_summaBalance(directions: state.directions))!='0.00',
                     child: BoxSubs(
                         key: ValueKey(state.directions),
                         namesDir: _titlesDirections,
                         directions: state.directions,
                         allViewDirection: _allViewDirection),
                   ),
                   // ...List.generate(state.expiredSubscriptions.length, (index) {
                   //   return Container(
                   //     margin: const EdgeInsets.all(5.0),
                   //     decoration: BoxDecoration(
                   //         color: colorBeruza.withOpacity(0.3),
                   //         borderRadius: const BorderRadius.only(
                   //             topLeft: Radius.circular(10.0),
                   //             topRight: Radius.circular(20.0),
                   //             bottomRight: Radius.circular(20.0),
                   //             bottomLeft: Radius.circular(20.0))),
                   //     child: Column(
                   //       children: [
                   //         Padding(
                   //           padding: const EdgeInsets.only(left: 20.0,right: 15.0,top: 10.0),
                   //           child: Row(
                   //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   //             children: [
                   //               Expanded(
                   //                 child: Text(
                   //                     state.expiredSubscriptions[index].name,
                   //                     style: TStyle.textStyleVelaSansBold(
                   //                         Theme.of(context)
                   //                             .textTheme
                   //                             .displayMedium!
                   //                             .color!,
                   //                         size: 16.0)),
                   //               ),
                   //               Visibility(
                   //                 visible:  state.expiredSubscriptions[index].status==StatusSub.active,
                   //                 child: Container(
                   //                   width: 90.0,
                   //                   alignment: Alignment.center,
                   //                   padding: const EdgeInsets.only(right: 8.0,left:8.0,bottom: 2.0),
                   //                   decoration: BoxDecoration(
                   //                       color: colorGreen,
                   //                       borderRadius: BorderRadius.circular(10.0)),
                   //                   child: Text('активный',
                   //                       style:TStyle.textStyleVelaSansBold(colorWhite,size: 10.0)),
                   //                 ),
                   //               )
                   //             ],
                   //           ),
                   //         ),
                   //         Visibility(
                   //           visible: state.expiredSubscriptions[index].nameTeacher.isNotEmpty&&
                   //               state.expiredSubscriptions[index].status==StatusSub.active,
                   //           child: Padding(
                   //             padding: const EdgeInsets.only(left: 20.0,right: 15.0,bottom: 8),
                   //             child: Row(
                   //               children: [
                   //                 // Icon(Icons.person,color: colorGreen,size: 15.0),
                   //                 // const Gap(5.0),
                   //                 Text(state.expiredSubscriptions[index].nameTeacher,
                   //                     style:TStyle.textStyleVelaSansMedium(colorGrey,size: 14.0)),
                   //               ],
                   //             ),
                   //           ),
                   //         ),
                   //
                   //   //todo test date end
                   //   Visibility(
                   //           visible: false,
                   //           child: Padding(
                   //             padding: const EdgeInsets.only(left: 20.0,bottom: 5.0),
                   //             child: Row(
                   //               children: [
                   //                 Row(
                   //                   children: [
                   //                     Text('Дата окончания'.tr(),
                   //                         style: TStyle.textStyleVelaSansRegular( Theme.of(context)
                   //                         .textTheme
                   //                         .displayMedium!
                   //                         .color!,size: 10.0)),
                   //                     const Gap(5.0),
                   //                     Text(DateTimeParser.getDateFromApi(date: state.expiredSubscriptions[index].dateEnd),
                   //                         style: TStyle.textStyleVelaSansBold( Theme.of(context)
                   //                         .textTheme
                   //                         .displayMedium!
                   //                         .color!,size: 10.0))
                   //                   ],
                   //                 ),
                   //               ],
                   //
                   //
                   //             ),
                   //           ),
                   //         ),
                   //         const Gap(5.0),
                   //         Padding(
                   //           padding: const EdgeInsets.only(left: 20.0,right: 20.0,bottom: 5.0),
                   //           child: Row(
                   //             crossAxisAlignment: CrossAxisAlignment.center,
                   //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   //             children: [
                   //               if(state.expiredSubscriptions[index].status==StatusSub.active)...{
                   //                 Column(
                   //                   crossAxisAlignment: CrossAxisAlignment.start,
                   //                   children: [
                   //                     Row(
                   //                       children: [
                   //                         Text('Осталось уроков: '.tr(),
                   //                             style: TStyle
                   //                                 .textStyleVelaSansMedium(
                   //                                 Theme.of(context)
                   //                                     .textTheme
                   //                                     .displayMedium!
                   //                                     .color!,
                   //                                 size: 14.0)),
                   //                         Text(
                   //                             '${ state.expiredSubscriptions[index].balanceLesson}',
                   //                             style: TStyle
                   //                                 .textStyleVelaSansBold(
                   //                                 Theme.of(context)
                   //                                     .textTheme
                   //                                     .displayMedium!
                   //                                     .color!,
                   //                                 size: 14.0)),
                   //                       ],
                   //                     ),
                   //                     const Gap(3.0),
                   //                     Row(
                   //                       children: [
                   //                         Text('Дата окончания'.tr(),style: TStyle.textStyleVelaSansRegular( Theme.of(context)
                   //                             .textTheme
                   //                             .displayMedium!
                   //                             .color!,size: 10.0)),
                   //                         const Gap(5.0),
                   //                         Text(' ${DateTimeParser.getDateFromApi(date: state.expiredSubscriptions[index].dateEnd)}',
                   //                             style: TStyle.textStyleVelaSansBold( Theme.of(context)
                   //                             .textTheme
                   //                             .displayMedium!
                   //                             .color!,size: 10.0))
                   //                       ],
                   //                     ),
                   //                     Visibility(
                   //                       visible: state.expiredSubscriptions[index].option.status!=OptionStatus.unknown,
                   //                       child: Row(
                   //                         children: [
                   //                           Text(state.expiredSubscriptions[index].option.status == OptionStatus.freezing?
                   //                           'Заморозка до '.tr()
                   //                               :'Каникулы до '.tr(),
                   //                               style: TStyle.textStyleVelaSansRegular(Theme.of(context)
                   //                                   .textTheme
                   //                                   .displayMedium!
                   //                                   .color!,
                   //                                   size: 10.0)),
                   //                           Text(DateTimeParser.getDateFromApi(date: state.expiredSubscriptions[index].option.dateEnd),
                   //                               style: TStyle.textStyleVelaSansBold(Theme.of(context)
                   //                                   .textTheme
                   //                                   .displayMedium!
                   //                                   .color!,
                   //                                   size: 10.0)),
                   //                         ],
                   //                       ),
                   //                     )
                   //
                   //
                   //                   ],
                   //                 )
                   //               }else ...{
                   //                 Container(
                   //                   alignment: Alignment.center,
                   //                   width: 100.0,
                   //                   padding: const EdgeInsets.only(right: 8.0,left:8.0,bottom: 2.0),
                   //                   decoration: BoxDecoration(
                   //                       color: colorRed,
                   //                       borderRadius:
                   //                       BorderRadius.circular(
                   //                           10.0)),
                   //                   child: Text(
                   //                       state.expiredSubscriptions[index].status==StatusSub.inactive?'неактивный'.tr():
                   //                       'запланирован'.tr(),
                   //                       style: TStyle
                   //                           .textStyleVelaSansBold(
                   //                           colorWhite,
                   //                           size: 10.0)),
                   //                 ),
                   //               },
                   //               Visibility(
                   //                 visible: _allViewDirection,
                   //                 child: Text(
                   //                     state.expiredSubscriptions[index].nameDir,
                   //                     style: TStyle.textStyleVelaSansBold(
                   //                         Theme.of(context)
                   //                             .textTheme
                   //                             .displayMedium!
                   //                             .color!,
                   //                         size: 13.0)),
                   //               )
                   //             ],
                   //           ),
                   //         ),
                   //         const Gap(10.0)
                   //       ],
                   //     ),
                   //   );
                   // }),

                   const Gap(20.0),
                   GestureDetector(
                     onTap: (){
                       GoRouter.of(context).push(pathListSubscriptionsHistory,extra: state.subscriptionHistory);
                     },
                     child: Container(
                       padding: const EdgeInsets.symmetric(vertical: 20.0,horizontal: 20.0),
                       decoration: BoxDecoration(
                           color: Theme.of(context).colorScheme.surfaceContainerHighest,
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
                           color: Theme.of(context).colorScheme.surfaceContainerHighest,
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
                           color: Theme.of(context).colorScheme.surfaceContainerHighest,
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
           ),
         );
       }
     ),
   );
  }
}


 class BoxSubs extends StatefulWidget{
   const BoxSubs({super.key,
     required this.directions,
     required this.allViewDirection,
     required this.namesDir
   });

   final List<DirectionLesson> directions;
   final bool allViewDirection;
   final List<String> namesDir;

   @override
   State<BoxSubs> createState() => _BoxSubsState();
 }

 class _BoxSubsState extends State<BoxSubs> {



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
       padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
       width: MediaQuery.sizeOf(context).width,
       decoration: BoxDecoration(
           color: Theme.of(context).colorScheme.surfaceContainerHighest,
           borderRadius: BorderRadius.circular(20.0)
       ),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [

           // Text('Активные абонементы'.tr(),
           //     style:TStyle.textStyleVelaSansExtraBolt(Theme.of(context).textTheme.displayMedium!.color!,
           //         size: 18.0)),
           // const Gap(10.0),
           Divider(color: colorGrey),
           Column(
             children: [
               ...List.generate(subs.length, (index) {

                 // if(widget.directions[index].lastSubscriptions.isEmpty){
                 //   return Container();
                 // }

                 return ItemSubs(
                     onTap: (String nameDir){
                       // if(widget.allViewDirection){
                       //   final selIndexDir = widget.namesDir.indexWhere((element) => element == nameDir);
                       //   GoRouter.of(context).push(pathFinance,extra: selIndexDir);
                       // }else{
                       //   final direction = widget.directions.firstWhere((element) => element.name == nameDir);
                       //   GoRouter.of(context).push(pathPay,extra: widget.directions);
                       // }
                     },
                     subscription: subs[index]);

                 // return ItemSubscription(direction: directions[index],
                 //     allViewDirection: allViewDirection, namesDir: namesDir);
               })
             ],
           ),
           // BoxSubscription(directions: directions,allViewDirection: allViewDirection,
           // namesDir: namesDir),
           //const Gap(5.0),
           // Row(
           //   mainAxisAlignment: MainAxisAlignment.center,
           //   children: [
           //     Container(
           //       margin: const EdgeInsets.only(top: 2.0),
           //       decoration: BoxDecoration(
           //           color: Theme.of(context).colorScheme.secondary,
           //           shape: BoxShape.circle
           //       ),
           //       child: Icon(CupertinoIcons.money_rubl_circle,color: colorWhite,size: 20.0,),),
           //     const Gap(5.0),
           //     Row(
           //       crossAxisAlignment: CrossAxisAlignment.center,
           //       children: [
           //         Text(ParserPrice.getBalance(_summaBalance(directions: widget.directions)),
           //             style:TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!,size: 25.0)),
           //         Padding(
           //           padding: const EdgeInsets.only(top: 4.0),
           //           child: Icon(CupertinoIcons.money_rubl,color: Theme.of(context).iconTheme.color,size: 30.0,),
           //         )
           //       ],
           //     ),
           //   ],
           // ),
           // const Gap(10.0),
           // SizedBox(
           //   height: 40.0,
           //   child: SubmitButton(
           //       textButton: 'Пополнить'.tr(),
           //       onTap: () {
           //         GoRouter.of(context).push(pathPay,extra: widget.directions);
           //       }
           //   ),
           // )
         ],
       ),
     );

   }
 }

 class ItemSubs extends StatefulWidget{
   const ItemSubs({super.key, required this.subscription, required this.onTap});

   final SubscriptionEntity subscription;
   final Function onTap;

   @override
   State<ItemSubs> createState() => _ItemSubsState();
 }

 class _ItemSubsState extends State<ItemSubs> {


   bool _open = false;


   // int _countAllLesson(SubscriptionEntity subscription){
   //   final i1 = subscription.price;
   //   final i2 = subscription.priceOneLesson;
   //   return i1~/i2;
   // }

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
             Column(
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
                             child: Text('${widget.subscription.balanceLesson} из ${widget.subscription.maxLessonsCount}',
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

                  const Gap(5.0),
                 Visibility(
                   visible: widget.subscription.nameTeacher.isNotEmpty,
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Row(
                         children: [
                           Icon(Icons.person,color: colorGreen,size: 10.0),
                           const Gap(5.0),
                           Text(widget.subscription.nameTeacher,
                               style:TStyle.textStyleVelaSansMedium(colorGrey,size: 13.0)),

                         ],
                       ),
                       TeacherContacts(contacts: widget.subscription.contactValues, size: 20)
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
                   visible: widget.subscription.option.status!=OptionStatus.unknown&&
                       widget.subscription.option.dateEnd.isNotEmpty,
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

               ],
             ),
             Divider(color: colorGrey),
           ],
         ),
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