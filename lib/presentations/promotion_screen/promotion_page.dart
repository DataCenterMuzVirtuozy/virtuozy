

 import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:virtuozy/router/paths.dart';

import '../../resourses/colors.dart';
import '../../utils/text_style.dart';

class PromotionPage extends StatefulWidget{
  const PromotionPage({super.key});

  @override
  State<PromotionPage> createState() => _PromotionPageState();
}

class _PromotionPageState extends State<PromotionPage> {
  final List<Map<String,String>> testPromo = [
    {'body':'Ответьте на 5 вопросов и мы зачислим 1 урок на ваш счет 3','title':'Бонусный урок за опрос'},
    {'body':'Подарим 1 урок, если ваш друг приобретет абонемент на любой курс','title':'Урок за друга'},
    {'body':'Верните подоходный налог от суммы, потраченной на обучение','title':'Налоговый вычет'},
    {'body':'Дарим 1 урок за 3 дня до и после дня рождения','title':'Имениннику'}
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: testPromo.length,
        itemBuilder: (context,index){
        if(index==0) {
          return Padding(
            padding: const EdgeInsets.only(left: 20.0,bottom: 10.0,top: 20.0),
            child: Text('Специальные предложения'.tr(),style: TStyle.textStyleGaretHeavy(colorBlack,size: 20.0)),
          );
        }

      return ItemPromotion(body: testPromo[index]['body']!, title: testPromo[index]['title']!);
    });
  }
}

 class ItemPromotion extends StatelessWidget{
   const ItemPromotion({super.key, required this.body, required this.title});

   final String body;
   final String title;

   @override
   Widget build(BuildContext context) {
     return GestureDetector(
       onTap: (){
          GoRouter.of(context).push(pathDetailPromo);
       },
       child: Container(
         margin: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 5.0),
         padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 15.0),
         decoration: BoxDecoration(
             borderRadius: BorderRadius.circular(15.0),
             color: colorBeruzaLight
         ),
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Padding(
               padding: const EdgeInsets.only(left: 47.0),
               child: Text(title,style: TStyle.textStyleVelaSansExtraBolt(colorBlack,size: 18.0)),
             ),
             const Gap(5.0),
             Row(
               children: [
                 Container(
                   padding: const EdgeInsets.all(5.0),
                   decoration: BoxDecoration(
                       color: colorOrange.withOpacity(0.2),
                       shape: BoxShape.circle
                   ),
                   child: Icon(Icons.electric_bolt,color: colorOrange),
                 ),
                 const Gap(15.0),
                 Expanded(child: Text(body,style: TStyle.textStyleVelaSansRegular(colorGrey,size: 14.0))),
               ],
             ),
             const Gap(10.0),
             Align(
               alignment: Alignment.centerRight,
               child: Text('Подробнее...'.tr(),style: TStyle.textStyleVelaSansMedium(colorBeruza,size: 13.0)),
             )
           ],
         ),
       ),
     );

   }

 }