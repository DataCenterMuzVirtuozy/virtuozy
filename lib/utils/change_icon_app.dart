

 import 'package:flutter_dynamic_icon/flutter_dynamic_icon.dart';


 enum AppIcon {
   nsk,
   msk,
 }

class ChangeIconApp{



     static changeAppIcon(AppIcon icon) async {

       try{
         if(await FlutterDynamicIcon.supportsAlternateIcons){
           await FlutterDynamicIcon.setAlternateIconName(icon.name);
           return;
         }else{
           print('Not Suprted');
         }

       } catch (e){
         print('Error Change icon $e');

       }

     }




 }