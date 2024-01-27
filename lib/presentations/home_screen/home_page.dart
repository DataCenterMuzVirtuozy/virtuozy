


 import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:virtuozy/components/calendar.dart';
import 'package:virtuozy/components/dialoger.dart';
import 'package:virtuozy/resourses/colors.dart';

import '../../components/buttons.dart';
import '../../components/drawing_menu_selected.dart';
import '../../utils/text_style.dart';

class HomePage extends StatelessWidget{
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
   return Padding(
     padding: const EdgeInsets.symmetric(horizontal: 10.0),
     child: SingleChildScrollView(
       child: Column(
         children: [
           //todo local
           Padding(
             padding: const EdgeInsets.symmetric(horizontal: 10.0),
             child: DrawingMenuSelected(items: [
               'Вокал'.tr(),
               'Академический вокал'.tr(),
               'Фортепиано'.tr(),
               'Все направления'.tr()
             ], onSelected: (index){

             },),
           ),
           const Gap(10.0),
           const Calendar(),
           const Gap(10.0),
           Column(
             children: List.generate(1, (index) {
              return const ItemSubscription();
             }),
           ),
           const Gap(10.0),
           Padding(
             padding: const EdgeInsets.symmetric(horizontal: 20.0),
             child: Column(
               children: [
                 SizedBox(
                   height: 40.0,
                   child: SubmitButton(
                     onTap: (){
                       Dialoger.showBottomMenu(context: context);
                     },
                     colorFill: colorGreen,
                  borderRadius: 10.0,
                  textButton: 'Подтвердите прохождение урока'.tr(),
                   ),
                 ),
                 const Gap(10.0),
                 SizedBox(
                   height: 40.0,
                   child: OutLineButton(
                     borderRadius: 10.0,
                     textButton: 'Получить бонусный урок'.tr(),
                   ),
                 ),
               ],
             ),
           )
         ],
       ),
     ),
   );
  }

}


 class ItemSubscription extends StatelessWidget{
  const ItemSubscription({super.key});

  @override
  Widget build(BuildContext context) {
    return            Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      padding: const EdgeInsets.all(20.0),
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
          color: colorBeruzaLight,
          borderRadius: BorderRadius.circular(20.0)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //todo local
          Text('Баланс абонемента'.tr(),style:TStyle.textStyleVelaSansExtraBolt(colorBlack,size: 18.0)),
          const Gap(5.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //todo local
              Text('Вокал',style:TStyle.textStyleVelaSansMedium(colorGrey,size: 16.0)),
              Text('2 урока осталось',style:TStyle.textStyleVelaSansMedium(colorGrey,size: 14.0)),
            ],
          ),
          const Gap(5.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: colorOrange,
                    shape: BoxShape.circle
                ),
                child: Icon(CupertinoIcons.money_rubl_circle,color: colorPink,size: 25.0,),),
              const Gap(5.0),
              Row(
                children: [
                  Text('8999',style:TStyle.textStyleVelaSansBold(colorBlack,size: 25.0)),
                  Icon(CupertinoIcons.money_rubl,color: colorBlack,size: 30.0,)
                ],
              ),
            ],
          ),
          const Gap(10.0),
          SizedBox(
            height: 40.0,
            child: SubmitButton(
              //todo local
              textButton: 'Пополнить'.tr(),
            ),
          )
        ],
      ),
    );

  }

 }

