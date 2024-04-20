


 import 'package:virtuozy/di/locator.dart';
import 'package:virtuozy/domain/entities/document_entity.dart';
import 'package:virtuozy/domain/entities/edit_profile_entity.dart';
import 'package:virtuozy/domain/entities/subway_entity.dart';
import 'package:virtuozy/domain/entities/user_entity.dart';
import 'package:virtuozy/domain/repository/user_repository.dart';

import '../../domain/entities/notifi_setting_entity.dart';
import '../utils/user_util.dart';

class UserRepositoryImpl extends UserRepository{

  final _util = locator.get<UserUtil>();

  @override
  Future<UserEntity> getUser({required String uid}) async {
    return await _util.getUser(uid: uid);
  }

  @override
  Future<void> saveSettingNotifi({required int uid,required List<NotifiSettingsEntity> settingEntity}) async {
    await _util.saveSettingNotifi(uid: uid,settingEntity: settingEntity);
  }

  @override
  Future<void> acceptDocuments({required int uid, required List<DocumentEntity> docs}) async {
    await _util.acceptDocuments(uid: uid, docs: docs);
  }

  @override
  Future<void> saveSettingDataProfile({required int uid, required EditProfileEntity profileEntity}) async {
    await _util.saveSettingDataProfile(uid: uid, profileEntity: profileEntity);
  }

  @override
  Future<String> loadAvaProfile({required int uid, required EditProfileEntity profileEntity}) async {
   return await _util.loadAvaProfile(uid: uid, profileEntity: profileEntity);
  }

  @override
  Future<List<SubwayEntity>> subways({required String  query}) async {
      return await _util.subways(query: query);
  }

}