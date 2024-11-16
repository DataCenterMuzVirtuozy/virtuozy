


 import 'package:virtuozy/data/mappers/document_mapper.dart';
import 'package:virtuozy/data/mappers/user_mapper.dart';
import 'package:virtuozy/data/models/subway_model.dart';
import 'package:virtuozy/data/services/user_service.dart';
import 'package:virtuozy/di/locator.dart';
import 'package:virtuozy/domain/entities/document_entity.dart';

import '../../domain/entities/edit_profile_entity.dart';
import '../../domain/entities/notifi_setting_entity.dart';
import '../../domain/entities/subway_entity.dart';
import '../../domain/entities/user_entity.dart';

class UserUtil{

    final _service = locator.get<UserService>();


    Future<UserEntity> getUser({required String uid}) async {
       final model = await _service.getUser(uid: uid);
       return UserMapper.fromApi(userModel: model);
    }

    Future<UserEntity> logIn({required String phone,required String password}) async {
      final model = await _service.logIn(phone: phone,password: password);
      return UserMapper.fromApi(userModel: model);
    }
    Future<void> signIn({required String phone, required String name, required String surName}) async{
       await _service.signIn(phone: phone,name: name,surName: surName);
      //return UserMapper.fromApi(userModel: model);
    }

    Future<void> saveSettingNotifi({required int uid,required List<NotifiSettingsEntity> settingEntity}) async {
      await _service.saveSettingNotifi(uid: uid,settingEntity: settingEntity);
    }

    Future<void> acceptDocuments({required int uid,required List<DocumentEntity> docs}) async {
      final docsModel = docs.map((e) => DocumentMapper.toApi(documentEntity: e)).toList();
      await _service.acceptDocuments(uid: uid, docs: docsModel);
    }

    Future<void> saveSettingDataProfile({required int uid,required EditProfileEntity profileEntity}) async{
      await _service.saveSettingDataProfile(uid: uid, profileEntity: profileEntity);
    }

    Future<String> loadAvaProfile({required int uid,required EditProfileEntity profileEntity}) async {
      return await _service.loadAvaProfile(uid: uid, profileEntity: profileEntity);
    }


    Future<List<SubwayEntity>> subways({required String  query}) async {
      final res = await _service.subways(query: query);
      return res.map((e) => UserMapper.fromApiSubway(model: SubwayModel.fromMap(e))).toList();
    }

 }