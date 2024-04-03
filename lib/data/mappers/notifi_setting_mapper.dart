


 import 'package:virtuozy/data/models/notifi_setting_model.dart';
import 'package:virtuozy/domain/entities/notifi_setting_entity.dart';

class NotifiSettingMapper{


   static NotifiSettingsEntity fromApi({required NotifiSettingModel notifiSettingModel}){
     return NotifiSettingsEntity(name: notifiSettingModel.name, config: notifiSettingModel.config);
   }

 }