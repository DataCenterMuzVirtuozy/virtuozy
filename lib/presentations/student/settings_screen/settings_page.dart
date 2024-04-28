



   import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../components/app_bar.dart';

class SettingsPage extends StatelessWidget{
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
   return Scaffold(
      appBar: AppBarCustom(title: 'Настройки'.tr()),
      body: Column(
         children: [

         ],
      ),
   );
  }

}


