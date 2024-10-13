

  import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';

import '../../../../resourses/images.dart';
import '../../../../utils/text_style.dart';

class FindLocationContent extends StatefulWidget{
  const FindLocationContent({super.key});

  @override
  State<FindLocationContent> createState() => _FindLocationContentState();
}

class _FindLocationContentState extends State<FindLocationContent> with TickerProviderStateMixin {

  String _currentAddress = '';
  final List<String> _filials = ['Новосибирская','Московская'];
  final List<String> _filialsTest= ['Минская','Московская'];

  @override
  void initState() {
    super.initState();
    _getCurrentPosition();
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
        position.latitude, position.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
         if(place.administrativeArea!.contains(_filialsTest[0])){
           _currentAddress = 'ms1';
         }else if(place.administrativeArea!.contains(_filialsTest[1])){
           _currentAddress = 'ns1';
         }else{
           _currentAddress = '-';
         }


      });
    }).catchError((e) {
      print('Position 2 Error ${e.toString()}');

    });
  }

  Future<void> _getCurrentPosition() async {
    print('Position 1');
    await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
       _getAddressFromLatLng(position);
    }).catchError((e) {
      print('Position Error ${e.toString()}');

    });
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0,),
        child: Column(
          children: [
            Lottie.asset(animationLocation,
              width: 150,
              repeat: true,

            ),
            const Gap(30.0),
            Text(_currentAddress.isEmpty?'Поиск филиалов поблизости....'.tr():_currentAddress,
                textAlign: TextAlign.center,
                style: TStyle.textStyleVelaSansBold(Theme
                    .of(context)
                    .textTheme
                    .displayMedium!
                    .color!,
                    size: 18.0)),
            const Gap(30.0),
          ],
        ));
  }
}



