


 import 'package:virtuozy/domain/entities/subway_entity.dart';

import '../entities/document_entity.dart';
import '../entities/edit_profile_entity.dart';
import '../entities/notifi_setting_entity.dart';
import '../entities/user_entity.dart';

abstract class UserRepository{
   Future<UserEntity> getUser({required String uid});
   Future<void> saveSettingNotifi({required int uid,required List<NotifiSettingsEntity> settingEntity});
   Future<void> acceptDocuments({required int uid,required List<DocumentEntity> docs});
   Future<void> saveSettingDataProfile({required int uid,required EditProfileEntity profileEntity});
   Future<String> loadAvaProfile({required int uid,required EditProfileEntity profileEntity});
   Future<List<SubwayEntity>> subways({required  String query});
   Future<UserEntity> logIn({required String phone,required String password});
   Future<void> deleteAccount();
   Future<void> signIn({required String phone, required String name, required String surName});
   Future<void> resetPass({required String phone});
   Future<void> editPass({required String phone, required String newPass});
 }