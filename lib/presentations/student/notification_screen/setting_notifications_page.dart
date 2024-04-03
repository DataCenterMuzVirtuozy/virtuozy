

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:virtuozy/components/app_bar.dart';
import 'package:virtuozy/components/dialogs/dialoger.dart';
import 'package:virtuozy/domain/entities/notifi_setting_entity.dart';
import 'package:virtuozy/presentations/student/notification_screen/bloc/notifi_event.dart';
import 'package:virtuozy/resourses/colors.dart';
import 'package:virtuozy/utils/text_style.dart';
import 'package:virtuozy/utils/update_list_ext.dart';

import '../../../components/buttons.dart';
import 'bloc/notifi_bloc.dart';
import 'bloc/notifi_state.dart';

class SettingNotificationsPage extends StatefulWidget{
  const SettingNotificationsPage({super.key});

  @override
  State<SettingNotificationsPage> createState() => _SettingNotificationsPageState();
}

class _SettingNotificationsPageState extends State<SettingNotificationsPage> {


   bool _edit = false;
   List<int> _settings = [];

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: const AppBarCustom(title: 'Настройка уведомлений',),
      body: BlocConsumer<NotifiBloc,NotifiState>(
        listener: (c,s){
           if(s.error.isNotEmpty){
             Dialoger.showMessage(s.error);
           }
           if(s.status == NotifiStatus.saved){
             _edit = false;
             Dialoger.showActionMaterialSnackBar(context: context, title: 'Изменения сохранены'.tr());
           }
          if(_settings.isEmpty){
            for (var element in s.settings) {
              _settings.add(element.config);
            }
          }
           },
        builder: (context,state) {
          if(state.status == NotifiStatus.loading){
            return Center(child: CircularProgressIndicator(color: colorOrange));
          }
          return IgnorePointer(
            ignoring: state.status == NotifiStatus.saving,
            child: Column(
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
                      ...List.generate(state.settings.length, (index){
                        return  ItemSetting(
                          item: state.settings[index],
                          onChange: (args){
                            setState(() {
                              _edit = true;
                              // _settings.removeAt(args[1]);
                              // _settings.insert(args[1], args[0]);
                              _settings.update(args[1],args[0]);

                            });

                        },
                          index: index,
                        );
                      })
                    ],
                  ),
                ),
                const Gap(20),
                if(state.status == NotifiStatus.saving)...{
                  Center(child: CircularProgressIndicator(color: colorOrange),)
                }else...{
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      height: 40.0,
                      child: Opacity(
                        opacity: !_edit?0.3:1.0,
                        child: SubmitButton(
                            borderRadius: 8,
                            textButton: 'Сохранить изменения'.tr(),
                            onTap: () {
                              if(_edit){
                                context.read<NotifiBloc>().add(SaveSettingNotifiEvent(settings: _settings));
                              }
                            }
                        ),
                      ),
                    ),
                  )

                }
              ],
            ),
          );
        }
      ),

    );
  }

  @override
  void initState() {
    super.initState();
    context.read<NotifiBloc>().add(const GetNotifiSettingsEvent());
  }
}

class ItemSetting extends StatefulWidget{
  const ItemSetting({super.key, required this.item, required this.onChange, required this.index});

   final NotifiSettingsEntity item;
   final Function onChange;
   final int index;

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
          Text(widget.item.name,style:
          TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!,size: 16),),
          Switch(value: _change,
              onChanged: (value){
               setState(() {
                  _change = value;
                  widget.onChange.call([_change?1:0,widget.index]);
               });
              })
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _change = widget.item.config == 1;
  }
}