


  import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:virtuozy/components/dialogs/dialoger.dart';
import 'package:virtuozy/components/dialogs/sealeds.dart';

import '../../../../resourses/colors.dart';
import '../../../../utils/text_style.dart';
import '../../../checkbox_menu.dart';

class OpenLocationSettingsContent extends StatefulWidget{
  const OpenLocationSettingsContent({super.key, required this.locationEnable});

  final bool locationEnable;

  @override
  State<OpenLocationSettingsContent> createState() => _OpenLocationSettingsContentState();
}

class _OpenLocationSettingsContentState extends State<OpenLocationSettingsContent> {
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(widget.locationEnable?Icons.location_on_outlined:
          Icons.location_off_outlined,color: Theme.of(context).textTheme.displayMedium!.color!,size: 40.0),
          const SizedBox(height: 15.0),
          Text(widget.locationEnable?'Определить местоположение?'.tr():'Открыть настройки?'.tr(),
              textAlign:TextAlign.center,
              style:TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!,size: 18.0)),
          const SizedBox(height: 5.0),
          Text(widget.locationEnable?'После определения местоположения, мы предложим ближайший к вам филиал школы'.tr():
          'Службы определения местоположения отключены. Пожалуйста, включите службы в настройках'.tr(),
              textAlign:TextAlign.center,
              style:TStyle.textStyleVelaSansRegular(Theme.of(context).textTheme.displayMedium!.color!,size: 16.0)),
          const SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    controllerMenu.open();
                  },
                  child: Text('Отмена'.tr(),
                      textAlign: TextAlign.center,
                      style: TStyle.textStyleVelaSansBold(
                          Theme.of(context).textTheme.displayMedium!.color!,
                          size: 16.0))),
              const Gap(5.0),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  if(!widget.locationEnable){
                    _openAppSettings();
                  }else{
                    Dialoger.showModalBottomMenu(title: 'Поиск местоположения'.tr(),
                        content: FindLocation());
                  }

                },
                child: Text(widget.locationEnable?'Начать'.tr():'Открыть'.tr(),
                    textAlign: TextAlign.center,
                    style:
                    TStyle.textStyleVelaSansBold(colorRed,size: 16.0)),)
            ],
          )
        ],
      ),
    );

  }

  void _openAppSettings() async {
    await _geolocatorPlatform.openLocationSettings();
  }
}