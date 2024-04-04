


 import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:virtuozy/components/calendar/calendar.dart';
import 'package:virtuozy/components/dialogs/contents/alert_dialog/log_out_teacher_content.dart';
import 'package:virtuozy/components/dialogs/contents/alert_dialog/select_date_content.dart';
import 'package:virtuozy/components/dialogs/sealeds.dart';
import 'package:virtuozy/domain/entities/teacher_entity.dart';
import 'package:virtuozy/domain/entities/user_entity.dart';
import 'package:virtuozy/resourses/colors.dart';

import '../../di/locator.dart';
import '../../domain/entities/lesson_entity.dart';
import '../../presentations/main_screen/main_page.dart';
import '../../utils/text_style.dart';
import 'contents/bottom_sheet_menu/steps_confirm_lesson_content.dart';







class Dialoger{





   static void showActionMaterialSnackBar(
       { VoidCallback? onAction,
         required BuildContext context,
         required String title,
         String textAction = 'OK'}) {
     ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
           backgroundColor: colorWhite,
           behavior: SnackBarBehavior.floating,
           content: Text(
             title,
             style: TStyle.textStyleVelaSansRegular(colorOrange)
           ),
           action: SnackBarAction(
             textColor: colorOrange,
             label: textAction,
             onPressed: () {
               //onAction!.call();
             },
           ),
         ));
   }


   ///Return toast message
   static void showMessage(String message) {
     Fluttertoast.showToast(
       msg: message,
       textColor: colorBlack,
       backgroundColor: colorWhite,
       fontSize: 14.0,
       gravity: ToastGravity.CENTER,
     );
   }

   static void showModalBottomMenu({
     required String title,
     required DialogsContent content,
     bool blurred = false,
     Object? args}){
     final currentDayNotifi = locator.get<ValueNotifier<int>>();


     showModalBottomSheet(
         isDismissible:true,
         enableDrag: true,
         isScrollControlled: true,
         backgroundColor: Colors.transparent,
         context: scaffoldKeyGlobal.currentContext!, builder: (_){
       final body = switch(content){
         ConfirmLesson()=>ConfirmLesson().build(context: _,args: args),
         SelectBranch() => SelectBranch().build(context: _),
         SearchLocationComplete() => SearchLocationComplete().build(context: _,args: args),
         DetailsLesson() => DetailsLesson().build(context: _,args: args),
         ListBonuses() => ListBonuses().build(context: _,args: args),
       };
       return  BackdropFilter(
         filter:  blurred?ImageFilter.blur(sigmaX: 10, sigmaY: 5):
         ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
         child: Wrap(
           children: [
             Container(
               width: MediaQuery.of(_).size.width,
               padding:  EdgeInsets.only(
                 bottom: MediaQuery.of(_).viewInsets.bottom,
                   right: 10.0,
                   left: 10.0,
                   top: 10.0),
               decoration: BoxDecoration(
                   color: Theme.of(_).colorScheme.background,
                   borderRadius: const BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30))
               ),
               child: Column(
                 children: [
                   Container(
                     height: 45.0,
                     padding: const EdgeInsets.only(top: 5.0,right: 15.0,left: 20.0),
                     decoration: BoxDecoration(
                         color: colorGrey,
                         borderRadius: const BorderRadius.only(topRight: Radius.circular(20.0),topLeft: Radius.circular(20.0),
                             bottomLeft: Radius.circular(10.0),bottomRight: Radius.circular(10.0))
                     ),
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Text(title,style: TStyle.textStyleGaretHeavy(colorWhite,size: 18.0),),
                         InkWell(
                             onTap: (){
                                 Navigator.pop(_);

                             },
                             child: Icon(Icons.close_rounded,color: colorWhite)),

                       ],
                     ),
                   ),
                   const Gap(20.0),
                   body
                 ],
               ),
             ),
           ],
         ),
       );
     }).whenComplete(() {
     currentDayNotifi.value = 0;
     });
   }


   static void showBottomMenu({
     required String title,
     required BuildContext context,
     required DialogsContent content,
     bool blurred = true,
     Object? args}){


     final Widget body = switch(content){
       ConfirmLesson()=>ConfirmLesson().build(context: context,args: args),
       SelectBranch() => SelectBranch().build(context: context),
       SearchLocationComplete() => SearchLocationComplete().build(context: context),
       DetailsLesson() => DetailsLesson().build(context: context,args: args),
       ListBonuses() => ListBonuses().build(context: context,args: args),
     };

     showModalBottomSheet(
         isDismissible:true,
         enableDrag: true,
         backgroundColor: Colors.transparent,
         context: context, builder: (_){
       return  BackdropFilter(
         filter: blurred?ImageFilter.blur(sigmaX: 10, sigmaY: 5):
         ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
         child: Wrap(
           children: [
             Container(
               width: MediaQuery.of(context).size.width,
               padding: const EdgeInsets.only(
                      right: 10.0,
                      left: 10.0,
                      top: 10.0),
                  decoration: BoxDecoration(
             color: Theme.of(context).colorScheme.background,
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30))
             ),
               child: Column(
                 children: [
                   Container(
                     height: 45.0,
                     padding: const EdgeInsets.only(top: 5.0,right: 15.0,left: 20.0),
                     decoration: BoxDecoration(
                         color: colorGrey,
                         borderRadius: const BorderRadius.only(topRight: Radius.circular(20.0),topLeft: Radius.circular(20.0),
                             bottomLeft: Radius.circular(10.0),bottomRight: Radius.circular(10.0))
                     ),
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Text(title,style: TStyle.textStyleGaretHeavy(colorWhite,size: 18.0),),
                         InkWell(
                             onTap: (){
                               Navigator.pop(context);

                             },
                             child: Icon(Icons.close_rounded,color: colorWhite)),

                       ],
                     ),
                   ),
                   const Gap(20.0),
                   body
                 ],
               ),

             ),
           ],
         ),
       );
     }).whenComplete(() {
       currentDayNotifi.value = 0;
     });
   }


   static void showLogOut({required BuildContext context,required UserEntity user}){
     showCustomDialog(
         contextUp: context,
         args: user,
         content: LogOut()

     );


   }

   static void showLogOutTeacher({required BuildContext context,required TeacherEntity teacher}){
     showCustomDialog(
         contextUp: context,
         args: teacher,
         content: LogOutTeacher()

     );
   }

   static void showSelectDate({required BuildContext context,required List<Lesson> lessons}){
     showCustomDialog(
         contextUp: context,
         args: lessons,
         content: SelectDate()

     );
   }




   static Future<T?> showCustomDialog<T>({
     required BuildContext contextUp,
     required  AlertDialogContent  content,
      Object? args
   }) async {
     final Widget body = switch(content){
       LogOut()=>LogOut().build(context: contextUp,args: args),
       LogOutTeacher() => LogOutTeacher().build(context: contextUp,args: args),
       SelectDate() => SelectDate().build(context: contextUp,args: args),
       AcceptDocuments() => AcceptDocuments().build(context: contextUp,args: args),
       DownloadDocument() => DownloadDocument().build(context: contextUp,args: args),
     };
     return showDialog<T>(
       context: contextUp,
       useRootNavigator: false,
       builder: (context) => AlertDialog(
         contentPadding: const EdgeInsets.all(0.0),
         backgroundColor: Theme.of(context).dialogBackgroundColor,
         shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(20.0)),
         content: Container(
           padding: const EdgeInsets.only(left: 30.0,right: 30.0,top: 15.0,bottom: 15.0),
           decoration: BoxDecoration(
             borderRadius: BorderRadius.circular(20.0),
             color: Theme.of(context).dialogBackgroundColor,
           ),
           child: Column(
             mainAxisSize: MainAxisSize.min,
             crossAxisAlignment: CrossAxisAlignment.center,
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               body,
             ],
           ),
         ),

       ),
     );
   }




}





