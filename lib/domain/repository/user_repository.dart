


 import '../entities/document_entity.dart';
import '../entities/notifi_setting_entity.dart';
import '../entities/user_entity.dart';

abstract class UserRepository{
   Future<UserEntity> getUser({required String uid});
   Future<void> saveSettingNotifi({required int uid,required List<NotifiSettingsEntity> settingEntity});
   Future<void> acceptDocuments({required int uid,required List<DocumentEntity> docs});
 }