

  import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:virtuozy/components/buttons.dart';
import 'package:virtuozy/components/checkbox_menu.dart';
import 'package:virtuozy/components/dialogs/contents/bottom_sheet_menu/add_lesson_content.dart';
import 'package:virtuozy/resourses/colors.dart';
import 'package:virtuozy/utils/preferences_util.dart';

import '../../../../resourses/images.dart';
import '../../../../resourses/strings.dart';
import '../../../../utils/text_style.dart';
import '../../dialoger.dart';



class FindLocationContent extends StatefulWidget{
  const FindLocationContent({super.key});



  @override
  State<FindLocationContent> createState() => _FindLocationContentState();
}

class _FindLocationContentState extends State<FindLocationContent> with TickerProviderStateMixin {

  String _currentAddress = '';
  final List<String> _filials = ['Новосибирская','Московская'];
  final List<String> _titles = ['Новосибирск','Москва'];
  final List<String> _filialsTest= ['Минская','Московская'];
  late final AnimationController _controller;
  String _administrativeArea = '';
  bool _visibleAdminArea  = false;


  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this,duration: const Duration(milliseconds: 1000));
    _getCurrentPosition();
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();


  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
        position.latitude, position.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _administrativeArea = place.administrativeArea!;
         if(place.administrativeArea!.contains(_filials[0])){
           _currentAddress = 'msk';
         }else if(place.administrativeArea!.contains(_filials[1])){
           _currentAddress = 'nsk';
         }else{
           _currentAddress = '1';
         }
        _controller.stop();

      });
    }).catchError((e) {
      setState(() {
        _currentAddress = '0';
        _controller.stop();
      });


    });
  }

  Future<void> _getCurrentPosition() async {
    await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
       _getAddressFromLatLng(position);
    }).catchError((e) {
      setState(() {
        _currentAddress = '0';
        _controller.stop();
      });

    });
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0,).copyWith(bottom: 30),
        child: Column(
          children: [
            Lottie.asset(animationLocation,
              controller: _controller,
              width: 150,
              repeat: true,

            ),
            const Gap(15.0),
            GestureDetector(
              onTap: (){
                if(_administrativeArea.isEmpty){
                  return;
                }
                setState(()  {
                   if(_visibleAdminArea){
                     _visibleAdminArea = false;
                   }else{
                     _visibleAdminArea = true;
                   }
                });
              },
              child: _visibleAdminArea?Text(_administrativeArea, textAlign: TextAlign.center,
              style: TStyle.textStyleVelaSansBold(colorGrey,size: 18),):
              Text(_currentAddress.isEmpty?'Поиск школ поблизости....'.tr():_currentAddress == '0'?
                  'Ошибка.\nМестоположение не определено'.tr():
              _currentAddress == '1'?'Нет ближайшей школы'.tr():
              'Ближайшая школа в \n${_currentAddress == 'ns1'?'г. ${_titles[0]}':'г. ${_titles[1]}'}',
                  textAlign: TextAlign.center,
                  style:
                  TStyle.textStyleVelaSansBold(_currentAddress == '0'||_currentAddress == '1'?colorRed:
                  Theme
                      .of(context)
                      .textTheme
                      .displayMedium!
                      .color!,
                      size: 18.0)),
            ),
            const Gap(15.0),
            Visibility(
              visible: _currentAddress.isNotEmpty,
              child: SizedBox(
                height: 40,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Visibility(
                        visible: _currentAddress == '0'||_currentAddress == '1',
                        child: Expanded(
                          child: SubmitButton(
                            borderRadius: 10,
                            textSize: 12,
                            onTap: (){
                              setState(() {
                                _currentAddress = '';
                                _controller.forward();
                              });
                              _getCurrentPosition();
                            },
                            textButton: 'Повторить поиск'.tr(),
                          ),
                        ),
                      ),
                      const Gap(10),
                      Expanded(
                        child: SubmitButton(
                          onTap: () async {
                            if(_currentAddress=='1'||_currentAddress == '0'){
                              Navigator.pop(context);
                              controllerMenu.open();
                              return;
                            }
                            Navigator.pop(context);
                            Dialoger.showToast('Филиал школы в г. ${_currentAddress == 'nsk'?_titles[0]:_titles[1]}');
                            await PreferencesUtil.setUrlSchool(_currentAddress == 'nsk'?nskUrl:mskUrl);
                          },
                          borderRadius: 10,
                          textSize: 12,
                          colorFill: _currentAddress == '0'?colorRed:colorGreen,
                          textButton: _currentAddress == '0'||_currentAddress == '1'?'Выбрать вручную'.tr():'Подтвердить'.tr(),
                        ),
                      )
                    ],
                  ).animate().fade(duration: const Duration(milliseconds: 400)),
                ),
              ),
            )
          ],
        ));
  }
}



