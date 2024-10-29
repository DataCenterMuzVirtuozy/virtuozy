

 import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';

import '../../components/checkbox_menu.dart';
import '../../components/dialogs/dialoger.dart';
import '../../components/dialogs/sealeds.dart';
import '../../utils/preferences_util.dart';

class LocationUtil{


  static Future<bool> handleLocationPermission({required BuildContext context, bool isMenuAction = false}) async {
     bool serviceEnabled;
     LocationPermission permission;
     serviceEnabled = await Geolocator.isLocationServiceEnabled();
     print('A1');
     if (!serviceEnabled) {
       Dialoger.showCustomDialog(contextUp: context,
           args: false,
           content: OpenSettingsLocations());

       return false;
     }
     print('A2');
     permission = await Geolocator.checkPermission();
     if (permission == LocationPermission.denied) {
       permission = await Geolocator.requestPermission();
       if (permission == LocationPermission.denied) {
         Dialoger.showActionMaterialSnackBar(
             context: context, title: 'Разрешения на местоположение отклонены');
         //_openAppSettings();
         return false;
       }
     }
     print('A3');
     if (permission == LocationPermission.deniedForever) {
       Dialoger.showActionMaterialSnackBar(
           context: context,
           title:
           'Разрешения на определение местоположения навсегда отклонены, мы не можем запрашивать разрешения.');
       return false;
     }
     print('A4');
     final baseUrlApi = PreferencesUtil.urlSchool;
     if(baseUrlApi.isEmpty||isMenuAction){
       controllerMenu.open();
       return false;
     }
     return true;
   }
 }