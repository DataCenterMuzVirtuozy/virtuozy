

 import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';

import '../../components/dialogs/dialoger.dart';
import '../../components/dialogs/sealeds.dart';

class LocationUtil{


  static Future<bool> handleLocationPermission({required BuildContext context}) async {
     bool serviceEnabled;
     LocationPermission permission;
     serviceEnabled = await Geolocator.isLocationServiceEnabled();
     if (!serviceEnabled) {
       Dialoger.showCustomDialog(contextUp: context,
           args: false,
           content: OpenSettingsLocations());

       return false;
     }
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
     if (permission == LocationPermission.deniedForever) {
       Dialoger.showActionMaterialSnackBar(
           context: context,
           title:
           'Разрешения на определение местоположения навсегда отклонены, мы не можем запрашивать разрешения.');
       return false;
     }
     return true;
   }
 }