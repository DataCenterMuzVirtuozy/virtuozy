


 import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:virtuozy/resourses/colors.dart';

import '../utils/text_style.dart';



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

   static void showBottomMenu({required BuildContext context}){
     showModalBottomSheet(
         backgroundColor: Colors.transparent,
         context: context, builder: (_){
       return  BackdropFilter(
         filter: ImageFilter.blur(sigmaX: 10, sigmaY: 5),
         child: Container(
             height: 510.0,
             padding:   const EdgeInsets.only(
             right: 30.0,left: 30.0,top: 10.0),
         decoration: BoxDecoration(
         color: colorWhite,
         borderRadius: const BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30))
         ),
         ),
       );
     });
   }




}