

 import 'dart:io';

 //import 'package:android_dynamic_icon/android_dynamic_icon.dart';
//import 'package:flutter_dynamic_icon/flutter_dynamic_icon.dart';


 enum AppIcon {
   nsk,
   msk,
 }

class ChangeIconApp{

    //static final _androidDynamicIconPlugin = AndroidDynamicIcon();

     static changeAppIcon(AppIcon icon) async {

       try{

         if(Platform.isAndroid){
          // if(icon.name == 'msk'){
          //   await _androidDynamicIconPlugin
          //       .changeIcon(classNames: ['IconOne', '']);
          // }else{
          //   await _androidDynamicIconPlugin
          //       .changeIcon(classNames: ['IconTwo', '']);
          // }

         }else{
           // if(await FlutterDynamicIcon.supportsAlternateIcons){
           //   await FlutterDynamicIcon.setAlternateIconName(icon.name);
           //   return;
           // }else{
           //   print('Not Suprted');
           // }
         }


       } catch (e){
         print('Error Change icon $e');

       }

     }




 }