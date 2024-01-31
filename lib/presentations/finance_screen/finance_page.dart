



 import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:virtuozy/components/buttons.dart';
import 'package:virtuozy/resourses/colors.dart';
import 'package:virtuozy/router/paths.dart';

import '../../components/drawing_menu_selected.dart';
import '../../utils/text_style.dart';

class FinancePage extends StatefulWidget{
  const FinancePage({super.key});

  @override
  State<FinancePage> createState() => _FinancePageState();
}

class _FinancePageState extends State<FinancePage> {

  int _selIndexDirection = 0;
  List<String> _listDirection =  [
    'Вокал'.tr(),
    'Академический вокал'.tr(),
    'Фортепиано'.tr(),
    'Все направления'.tr()
  ];
  @override
  Widget build(BuildContext context) {
   return Padding(
     padding: const EdgeInsets.symmetric(horizontal: 20.0),
     child: SingleChildScrollView(
       child: Column(
         children: [
           DrawingMenuSelected(items: _listDirection,
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
                     Text('10989.00'.tr(),style: TStyle.textStyleVelaSansExtraBolt(colorBlack,size: 30.0)),
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
                             children: [
                               //todo local
                               Text('Абонемент “Утренний” 8 уроков',style: TStyle.textStyleVelaSansBold(colorBlack,size: 16.0)),
                               const Gap(5.0),
                               Text('2 урока осталось',style: TStyle.textStyleVelaSansMedium(colorBlack,size: 14.0)),
                             ],
                             crossAxisAlignment: CrossAxisAlignment.start,
                           ),
                         ),
                       ),
                       const Gap(10.0),
                       FloatingActionButton(onPressed: (){
                         GoRouter.of(context).push(pathPay,extra: _selIndexDirection == 3?
                         '':_listDirection[_selIndexDirection]);
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
           GestureDetector(
             onTap: (){},
             child: Container(
               padding: const EdgeInsets.symmetric(vertical: 20.0,horizontal: 20.0),
               decoration: BoxDecoration(
                   color: colorBeruzaLight,
                   borderRadius: BorderRadius.circular(20.0)
               ),
               child: Column(
                 children: [
                   Text('1 бонусный урок',style: TStyle.textStyleGaretHeavy(colorBlack,size: 22.0)),
                   const Gap(20.0),
                  SubmitButton(
                    onTap: (){},
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
}