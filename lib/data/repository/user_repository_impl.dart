


 import 'package:virtuozy/di/locator.dart';
import 'package:virtuozy/domain/entities/document_entity.dart';
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

}