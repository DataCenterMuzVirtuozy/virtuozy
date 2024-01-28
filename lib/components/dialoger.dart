


 import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:virtuozy/resourses/colors.dart';

import '../utils/text_style.dart';
import 'buttons.dart';



class Dialoger{

   static void showActionMaterialSnackBar(
       {required VoidCallback onAction,
         required BuildContext context,
         required String title,
         String textAction = 'OK'}) {
     ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
           backgroundColor: colorWhite,
           behavior: SnackBarBehavior.floating,
           content: Text(
             title,
             style: TStyle.textStyleVelaSansRegular(colorBlack)
           ),
           action: SnackBarAction(
             textColor: colorOrange,
             label: textAction,
             onPressed: () {
               onAction.call();
             },
           ),
         ));
   }

   static void showMessage(String message) {
     Fluttertoast.showToast(
       msg: message,
       textColor: colorBlack,
       backgroundColor: colorWhite,
       fontSize: 14.0,
       gravity: ToastGravity.CENTER,
     );
   }

   static void showBottomMenu({required BuildContext context,required DialogsContent content}){

     final body = switch(content){
       ConfirmLesson()=>ConfirmLesson.build(context: context)
     };

     showModalBottomSheet(
         backgroundColor: Colors.transparent,
         context: context, builder: (_){
       return  BackdropFilter(
         filter: ImageFilter.blur(sigmaX: 10, sigmaY: 5),
         child: Container(
             //height: 200.0,
             padding:   const EdgeInsets.only(
             right:10.0,left: 10.0,top: 10.0),
         decoration: BoxDecoration(
         color: colorWhite,
         borderRadius: const BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30))
         ),
           child: body,
         ),
       );
     });
   }




}


 sealed class DialogsContent{}


 class ConfirmLesson extends DialogsContent{

  static heightBox(){
    return 300.0;
  }


   static build({required BuildContext context}){
     return Column(
       children: [
          Container(
            height: 45.0,
            padding: const EdgeInsets.only(top: 5.0,right: 15.0,left: 20.0),
            decoration: BoxDecoration(
              color: colorGreenLight,
              borderRadius: const BorderRadius.only(topRight: Radius.circular(20.0),topLeft: Radius.circular(20.0),
              bottomLeft: Radius.circular(10.0),bottomRight: Radius.circular(10.0))
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Урок',style: TStyle.textStyleGaretHeavy(colorWhite,size: 18.0),),
                InkWell(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.close_rounded,color: colorWhite)),

              ],
            ),
          ),
         const Gap(10.0),
         Container(
           padding: const EdgeInsets.symmetric(vertical: 10.0),
           width: double.infinity,
           decoration: BoxDecoration(
               color: colorBeruzaLight,
               borderRadius:  BorderRadius.circular(10.0)
           ),
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.center,
             children: [
               Text('Среда, 1 ноября, 10:00 - 10:55',style: TStyle.textStyleVelaSansMedium(colorBlack,size: 18.0)),
               const Gap(10.0),
               Text('Кабинет №2338',style: TStyle.textStyleVelaSansMedium(colorGrey,size: 16.0)),
               const Gap(10.0),
               Text('Иванов Иван Иванович',style: TStyle.textStyleVelaSansMedium(colorGrey,size: 16.0)),
               const Gap(10.0),
               Text('Вокал',style: TStyle.textStyleVelaSansMedium(colorGrey,size: 16.0)),
             ],
           ),
         ),

         const Gap(10.0),
         SizedBox(
           height: 40.0,
           child: SubmitButton(
             borderRadius: 10.0,
             textButton: 'Подтвердить урок'.tr(),
           ),
         )

       ],
     );
   }
  }