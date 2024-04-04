


 import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:virtuozy/data/models/document_model.dart';
import 'package:virtuozy/data/rest/dio_client.dart';
import 'package:virtuozy/data/rest/endpoints.dart';
import 'package:virtuozy/domain/entities/document_entity.dart';
import 'package:virtuozy/domain/entities/notifi_setting_entity.dart';
import 'package:virtuozy/utils/failure.dart';

import '../../di/locator.dart';
import '../models/notifi_setting_model.dart';
import '../models/user_model.dart';

class UserService{


   final _dio = locator.get<DioClient>().init();


   Future<UserModel> getUser({required String uid}) async {
    try{
       final res = await _dio.get(Endpoints.user,
       queryParameters: {
          'phoneNumber': uid.replaceAll(' ', '')
       });

       if((res.data as List<dynamic>).isEmpty){
        return throw   Failure('Пользователь не найден'.tr());
       }
       final idUser = res.data[0]['id'] as int;
       final resSubs = await _dio.get(Endpoints.subsUser,
           queryParameters: {
            'idUser': idUser
           });
       return UserModel.fromMap(mapUser: res.data[0],mapSubsAll: resSubs.data );
    } on Failure catch(e){
     print('Error 1 ${e.message}');
       throw  Failure(e.message);
    } on DioException catch(e){
     print('Error 2 ${e.message}');
     throw  Failure(e.message!);
    }
   }

   Future<void> saveSettingNotifi({required int uid,required List<NotifiSettingsEntity> settingEntity}) async{
    try{
      List<Map<String,dynamic>> data = [];
      for (var element in settingEntity) {
        data.add({
          'name': element.name,
          'config': element.config,
        });
      }


     await _dio.patch('${Endpoints.user}/$uid',
         data: {
          'settingNotifi': data
         });

    } on Failure catch(e){
     print('Error 1 ${e.message}');
     throw  Failure(e.message);
    } on DioException catch(e){
     print('Error 2 ${e.toString()}');
     throw  Failure(e.toString());
    }
   }

   Future<void> acceptDocuments({required int uid,required List<DocumentModel> docs}) async {
     try{
       List<Map<String,dynamic>> data = [];
       for (var element in docs) {
         data.add(element.toMap());
       }


       await _dio.patch('${Endpoints.user}/$uid',
           data: {
             'documents': data
           });
     }on Failure catch(e){

     }
   }

 }


