



 import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:virtuozy/resourses/colors.dart';

import '../../components/app_bar.dart';
import '../../utils/text_style.dart';

class ListTransactionsPage extends StatelessWidget{
   ListTransactionsPage({super.key});



  final List<Map<String,String>> testData = [
    {
      'time':'01.10.23',
      'body':'Списание за урок',
      'quantity':'-1 930 Р'
    },

    {
      'time':'25.09.23',
      'body':'Списание за урок',
      'quantity':'-1 930 Р'
    },

    {
 'time':'16.09.23',
 'body':'Пополнение счета',
 'quantity':'+46 320 Р'
 },
    {
      'time':'10.09.23',
      'body':'Списание за урок',
      'quantity':'-1 930 Р'
    },

    {
      'time':'08.09.23',
      'body':'Бонусный урок',
      'quantity':'+1930 Р'
    }
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(title: 'Операции по счету'.tr()),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        itemCount: testData.length,
          itemBuilder: (c,i){
       return ItemTransaction(body: testData[i]['body']!,
           time: testData[i]['time']!,
           quantity: testData[i]['quantity']!);
      }),
    );
  }

}

 class ItemTransaction extends StatelessWidget{
   const ItemTransaction({super.key,
     required this.body,
     required this.time,
     required this.quantity
      });

   final String body;
   final String time;
   final String quantity;

   @override
   Widget build(BuildContext context) {
     return Container(
       margin: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 5.0),
       padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 15.0),
       decoration: BoxDecoration(
           borderRadius: BorderRadius.circular(15.0),
           color: colorBeruzaLight
       ),
       child: Column(
         children: [
           Row(
             children: [
               Container(
                 padding: const EdgeInsets.all(5.0),
                 decoration: BoxDecoration(
                     color: colorOrange.withOpacity(0.2),
                     shape: BoxShape.circle
                 ),
                 child: Icon(Icons.payment,color: colorOrange),
               ),
               const Gap(15.0),
               Expanded(child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text(body,style: TStyle.textStyleVelaSansBold(colorBlack,size: 14.0)),
                   Row(
                     children: [
                       Icon(Icons.timelapse_rounded,color: colorBeruza,size: 10.0),
                       const Gap(3.0),
                       Text(time,style: TStyle.textStyleVelaSansRegular(colorBeruza,size: 10.0)),
                     ],
                   ),
                 ],
               )),
             ],
           ),
           const Gap(10.0),
           Row(
             crossAxisAlignment: CrossAxisAlignment.center,
             mainAxisAlignment: MainAxisAlignment.end,
             children: [
               Text(quantity,style: TStyle.textStyleVelaSansExtraBolt(colorBlack,size: 14.0)),
             ],
           )
         ],
       ),
     );

   }

 }