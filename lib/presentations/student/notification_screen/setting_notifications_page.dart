

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:virtuozy/components/app_bar.dart';
import 'package:virtuozy/resourses/colors.dart';
import 'package:virtuozy/utils/text_style.dart';

import '../../../components/buttons.dart';

class SettingNotificationsPage extends StatefulWidget{
  const SettingNotificationsPage({super.key});

  @override
  State<SettingNotificationsPage> createState() => _SettingNotificationsPageState();
}

class _SettingNotificationsPageState extends State<SettingNotificationsPage> {

  List<Map<String,dynamic>> _settings = [
    {"name":"Уведомление об оплате",
      "status":0},
    {"name":"Подтверждение уроков",
      "status":0},
    {"name":"Напоминание об уроке",
      "status":0},
    {"name":"Пропуск урока",
      "status":0},
    {"name":"Уведомление о бонусах",
      "status":0},
    {"name":"Новые предложения",
      "status":0},
  ];
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: const AppBarCustom(title: 'Настройка уведомлений',),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 30),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).colorScheme.surfaceVariant
            ),
            child: Column(
              children: [
                ...List.generate(_settings.length, (index){
                  return  ItemSetting(
                    item: _settings[index],
                  );
                })
              ],
            ),
          ),
          const Gap(20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              height: 40.0,
              child: SubmitButton(
                  borderRadius: 8,
                  textButton: 'Сохранить изменения'.tr(),
                  onTap: () {

                  }
              ),
            ),
          )
        ],
      ),

    );
  }
}

class ItemSetting extends StatefulWidget{
  const ItemSetting({super.key, required this.item});

   final Map<String,dynamic> item;

  @override
  State<ItemSetting> createState() => _ItemSettingState();
}

class _ItemSettingState extends State<ItemSetting> {

  bool _change = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.item['name'],style:
          TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!,size: 16),),
          Switch(value: _change,
              onChanged: (value){
               setState(() {
                  _change = value;
               });
              })
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _change = widget.item['status'] == 1;
  }
}