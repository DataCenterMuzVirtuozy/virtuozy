


 import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:virtuozy/data/models/document_model.dart';
import 'package:virtuozy/data/rest/dio_client.dart';
import 'package:virtuozy/data/rest/endpoints.dart';
import 'package:virtuozy/domain/entities/document_entity.dart';
import 'package:virtuozy/domain/entities/edit_profile_entity.dart';
import 'package:virtuozy/domain/entities/notifi_setting_entity.dart';
import 'package:virtuozy/utils/failure.dart';
 import 'package:http/http.dart' as http;
import 'package:virtuozy/utils/preferences_util.dart';
 import 'dart:convert' as convert;
 import 'dart:io';
import '../../di/locator.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/user_cubit.dart';
import '../../resourses/strings.dart';
import '../models/notifi_setting_model.dart';
import '../models/subway_model.dart';
import '../models/user_model.dart';

class UserService{


  Future<void> resetPass({required String phone}) async {
    final dioApi = locator.get<DioClient>().initApi();
    final phoneFormated = phone.replaceAll(RegExp(r'[^0-9]'), '');
    try {
      var formData = FormData.fromMap({
        'phone': '+$phoneFormated',
      });
       await dioApi.post(Endpoints.resetPass,
           data: formData);
    } on Failure catch (e) {
      throw Failure(e.message);
    } on DioException catch (e) {
      if(e.type == DioExceptionType.connectionError){
        throw Failure('Нет сети'.tr());
      }

      if(e.response?.statusCode == 404){
        throw  Failure('Номер телефона не зарегистрирован'.tr());
      }

      throw Failure('Ошибка сброса пароля'.tr());
    }
  }


  Future<void> editPass({required String phone, required String newPass}) async {
    final dioApi = locator.get<DioClient>().initApi();
    final token =  PreferencesUtil.token;
    final phoneUser = PreferencesUtil.phoneUser;
    final phoneFormated = phoneUser.replaceAll(RegExp(r'[^0-9]'), '');

    try {
      var formData = FormData.fromMap({
        'phone': '+$phoneFormated',
        'password': newPass
      });
      await dioApi.post(Endpoints.editPass,
          options: Options(
              headers: {'Authorization':'Bearer $token'}
          ),
          data: formData);
    } on Failure catch (e) {
      throw Failure(e.message);
    } on DioException catch (e) {
      if(e.type == DioExceptionType.connectionError){
        throw Failure('Нет сети'.tr());
      }

      if(e.response?.statusCode == 404){
        throw  Failure('Номер телефона не зарегистрирован'.tr());
      }

      throw Failure('Ошибка смены пароля'.tr());
    }
  }



  Future<void> deleteAccount() async {
    try{
      final dioApi = locator.get<DioClient>().initApi();

      final token =  PreferencesUtil.token;
      var data =  {
        'user_status_id': 3
      };
      await dioApi.post(Endpoints.update,
          options: Options(
              headers: {'Authorization':'Bearer $token'}
          ),
          data: jsonEncode(data));

    } on Failure catch(e){
      throw  Failure(e.message);
    } on DioException catch(e){
      if(e.type == DioExceptionType.connectionError){
        throw Failure('Нет сети'.tr());
      }
      throw  Failure(e.toString());
    }

  }

  Future<void> signIn({required String phone, required String name, required String surName}) async {

    final dioApi = locator.get<DioClient>().initApi();
    final phoneFormated = phone.replaceAll(RegExp(r'[^0-9]'), '');
    try{
      var formData = FormData.fromMap( {
        'phone': '+$phoneFormated',
        'name':name,
        'surname':surName
      });
      await dioApi.post(Endpoints.singIn, data: formData);
    } on Failure catch(e){
      throw  Failure(e.message);
    } on DioException catch(e){
      if(e.type == DioExceptionType.connectionError){
        throw Failure('Нет сети'.tr());
      }

      throw  Failure('Ошибка регистрации пользователя'.tr());
    }
  }


  Future<UserModel> logIn({required String phone, required String password}) async {
    final dioApi = locator.get<DioClient>().initApi();
    try{
      final resLogin = await dioApi.post(Endpoints.logIn,
          queryParameters: {
            'phone':  phone.replaceAll(' ', ''),
            'password':password
          });

      final  token = resLogin.data['token'];
     await PreferencesUtil.setToken(token: token);
      final resUser = await dioApi.get(Endpoints.user,
        options: Options(
            headers: {'Authorization':'Bearer $token'}
        ),);


      final resSubs = await dioApi.get(Endpoints.subsUser,
        options: Options(
            headers: {'Authorization':'Bearer $token'}
        ),);

      final resLessons = await dioApi.get(Endpoints.lessons,
          options: Options(
            headers: {'Authorization':'Bearer $token'}
          ),);

      var listLess = [];
      var listSubs = [];

      listSubs = resSubs.data['data'];
      listLess = resLessons.data['data'];

      return UserModel.fromMap(mapUser: resUser.data, mapSubsAll: listSubs,lessons: listLess);
    } on Failure catch(e){

      throw  Failure(e.message);
    } on DioException catch(e,stack){

      if(e.type == DioExceptionType.connectionError){
        throw Failure('Нет сети'.tr());
      }
      if(e.response?.statusCode == 404){
        throw  Failure('Номер телефона не зарегистрирован'.tr());
      }

      if(e.response?.statusCode == 403){
        throw  Failure('Данный аккаунт был удален пользователем'.tr());
      }

      if(e.response?.statusCode == 401){
        throw  Failure('Неправильно введен логин или пароль'.tr());
      }
      print('Login ${e.response!.statusCode}');
      throw  Failure('Ошибка авторизации'.tr());
    }
  }





  Future<UserModel> getUser({required String uid}) async {
     final dioApi = locator.get<DioClient>().initApi();
    try{
    final token =  PreferencesUtil.token;
      final resUser = await dioApi.get(Endpoints.user,
        options: Options(
            headers: {'Authorization':'Bearer $token'}
        ),);


      final resSubs = await dioApi.get(Endpoints.subsUser,
        options: Options(
            headers: {'Authorization':'Bearer $token'}
        ),);

      final resLessons = await dioApi.get(Endpoints.lessons,
        options: Options(
            headers: {'Authorization':'Bearer $token'}
        ),);

      var listLess = [];
      var listSubs = [];
      listSubs = resSubs.data['data'];
      listLess = resLessons.data['data'];
      return UserModel.fromMap(mapUser: resUser.data, mapSubsAll: listSubs,lessons: listLess);
    } on Failure catch(e){
       throw  Failure(e.message);
    } on DioException catch(e,stack){
      if(e.type == DioExceptionType.connectionError){
        throw Failure('Нет сети'.tr());
      }

      throw  Failure('Ошибка авторизации'.tr());
    }
   }



   //call api crm
   Future<void> saveSettingNotifi({required int uid,required List<NotifiSettingsEntity> settingEntity}) async{

     final dioApi = locator.get<DioClient>().initApi();

    try{
      List<Map<String,dynamic>> data = [];
      for (var element in settingEntity) {
        data.add({
          'name': element.name,
          'config': element.config,
        });
      }


     await dioApi.patch('${Endpoints.user}/$uid',
         data: {
          'settingNotifi': data
         });

    } on Failure catch(e){
     throw  Failure(e.message);
    } on DioException catch(e){
      if(e.type == DioExceptionType.connectionError){
        throw Failure('Нет сети'.tr());
      }
     throw  Failure(e.toString());
    } catch (e){
      throw  Failure(e.toString());
    }
   }

   Future<void> acceptDocuments({required int uid,required List<DocumentModel> docs}) async {
     try{
       final dioApi = locator.get<DioClient>().initApi();
       List<Map<String,dynamic>> data = [];
       for (var element in docs) {
         data.add(element.toMap());
       }


       await dioApi.patch('${Endpoints.user}/$uid',
           data: {
             'documents': data
           });
     }on Failure catch(e){

     }
   }

   Future<void> saveSettingDataProfile({required int uid,required EditProfileEntity profileEntity}) async{
     try{
       final dioApi = locator.get<DioClient>().initApi();
       final List<Map<String,dynamic>> subWay = [];

       final token =  PreferencesUtil.token;
       for(var s in profileEntity.subways){
         subWay.add({
           "value":s.name,
           //"color":s.color
         });
       }

       var data =  {
         'subways':subWay,
         'date_of_birth': profileEntity.dateBirth,
         'group_search_preferences':profileEntity.whoFindTeem,
         'has_child': profileEntity.hasKind?1:0,
         'about': profileEntity.aboutMe
       };
       await dioApi.post(Endpoints.update,
           options: Options(
               headers: {'Authorization':'Bearer $token'}
           ),
           data: jsonEncode(data));

     } on Failure catch(e){
       throw  Failure(e.message);
     } on DioException catch(e){
       if(e.type == DioExceptionType.connectionError){
         throw Failure('Нет сети'.tr());
       }
       throw  Failure(e.toString());
     }
   }


   Future<String> loadAvaProfile({required int uid,required EditProfileEntity profileEntity}) async{
     try{
       final baseUrl = PreferencesUtil.urlSchool;
       final token =  PreferencesUtil.token;
       String fileName = profileEntity.fileImageUrl!.path.split('/').last;
       var request = http.MultipartRequest('POST', Uri.parse('$baseUrl${Endpoints.update}'));
       request.headers.addAll({'Authorization':'Bearer $token'});
       final imgFile = await http.MultipartFile.fromPath('avatar', profileEntity.fileImageUrl!.path,filename: fileName);
       request.files.add(imgFile);
       var streamedResponse = await request.send();
       await http.Response.fromStream(streamedResponse);
       return '';

     } on Failure catch(e,s){
       print('Eror  ${s}');
       throw  Failure(e.message);
     } on DioException catch(e,s){
       if(e.type == DioExceptionType.connectionError){
         throw Failure('Нет сети'.tr());
       }
       throw  Failure(e.toString());
     } catch(e,s){
       print('Eror 2 ${s}');

       throw const Failure('Ошибка загрузки фото');
     }
   }

   Future<List<dynamic>> subways({required String  query}) async {
     try{
       final dioApi = locator.get<DioClient>().initApi();
     final user = locator.get<UserCubit>();
     final loc =  user.userEntity.branchName=='msk'?'Москва':'Новосибирск';
     final res =  await dioApi.post(Endpoints.subways,
           options: Options(
             headers: {"Authorization": "Token $apiKeyDaData"}
           ),
           data: {
            'query':query,
             'filters':[
               {
                 "city":loc,
               }
             ]
           });

      return res.data['suggestions'];
     } on Failure catch(e){

       throw  Failure(e.message);
     } on DioException catch(e){
       if(e.type == DioExceptionType.connectionError){
         throw Failure('Нет сети'.tr());
       }
       throw  Failure(e.toString());
     }
   }

 }


