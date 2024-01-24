


 import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:virtuozy/components/calendar.dart';
import 'package:virtuozy/resourses/colors.dart';

import '../../../components/buttons.dart';
import '../../../utils/text_style.dart';

class PageHome extends StatelessWidget{
  const PageHome({super.key});

  @override
  Widget build(BuildContext context) {
   return Padding(
     padding: const EdgeInsets.all(10.0),
     child: Column(
       children: [
         const Calendar(),
         const Gap(20.0),
         Container(
           padding: EdgeInsets.all(20.0),
           width: MediaQuery.sizeOf(context).width,
           decoration: BoxDecoration(
             color: colorBeruzaLight,
             borderRadius: BorderRadius.circular(20.0)
           ),
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   Text('Вокал',style:TStyle.textStyleVelaSansBold(colorBlack,size: 20.0)),
                   Text('2 урока осталось',style:TStyle.textStyleVelaSansMedium(colorGrey,size: 16.0)),
                 ],
               ),
               const Gap(10.0),
               Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                    Container(
                        decoration: BoxDecoration(
                      color: colorOrange,
                      shape: BoxShape.circle
                    ),
                        child: Icon(CupertinoIcons.money_rubl_circle,color: colorPink,size: 25.0,),),
                   const Gap(10.0),
                   Row(
                     children: [
                       Text('8999',style:TStyle.textStyleVelaSansBold(colorBlack,size: 25.0)),
                       Icon(CupertinoIcons.money_rubl,color: colorBlack,size: 30.0,)
                     ],
                   ),
                 ],
               ),
               const Gap(20.0),
               const SubmitButton(
                 textButton: 'Пополнить',
               )
             ],
           ),
         )
       ],
     ),
   );
  }

}