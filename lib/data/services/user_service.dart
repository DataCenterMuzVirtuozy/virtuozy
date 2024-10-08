


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
import '../../domain/user_cubit.dart';
import '../../resourses/strings.dart';
import '../models/notifi_setting_model.dart';
import '../models/subway_model.dart';
import '../models/user_model.dart';

class UserService{





   Future<UserModel> getUser({required String uid}) async {

     final dioInit = locator.get<DioClient>().init();
     final dioApi = locator.get<DioClient>().initApi();
    try{
      var dio = Dio();
      var idUser = 0;
      if(uid.contains('111')){
        dio = dioInit;
      }else{
        dio = dioApi;
      }


       final res = await dio.get(Endpoints.user,
       queryParameters: {
          'phoneNumber': uid.replaceAll(' ', '')
       });


       if((res.data as List<dynamic>).isEmpty){
        await PreferencesUtil.clear();
        return throw   Failure('Пользователь не найден'.tr());
       }


      if(uid.contains('111')){
         idUser = res.data[0]['id'] as int;
      }else{
         idUser = res.data[0]['id'] as int;
       //idUser = 1;

      }

       //api crm
       final resSubs = await dio.get(Endpoints.subsUser,
           queryParameters: {
            'idUser': idUser
           });

       //print('Response Subs ${resSubs.data}');


      // api crm
       final resLessons = await dio.get(Endpoints.lessons,
           queryParameters: {
             'idStudent': idUser
           });


      var listLess = [];
      var listSubs = [];

      if(uid.contains('111')){
        listLess = resLessons.data;
        listSubs  = resSubs.data;
      }else{
        listSubs = resSubs.data['data'];
        listLess = resLessons.data['data'];
      }
      //print('Response Lessons ${listLess}');
       return UserModel.fromMap(mapUser: res.data[0],mapSubsAll: listSubs,lessons: listLess);
    } on Failure catch(e){
       throw  Failure(e.message);
    } on DioException catch(e){
     throw  Failure(e.message!);
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


       for(var s in profileEntity.subways){
         subWay.add({
           "value":s.name,
           "color":s.color
         });
       }

       await dioApi.patch('${Endpoints.user}/$uid',
           data: {
             'subways':subWay,
             'sex': profileEntity.sex,
             'date_birth':profileEntity.dateBirth,
             'has_kids': profileEntity.hasKind,
             'avaUrl':profileEntity.urlAva,
             'about_me':profileEntity.aboutMe,
             'who_find':profileEntity.whoFindTeem

           });

     } on Failure catch(e){
       print('Error 1 ${e.message}');
       throw  Failure(e.message);
     } on DioException catch(e){
       print('Error 2 ${e.toString()}');
       throw  Failure(e.toString());
     }
   }


   Future<String> loadAvaProfile({required int uid,required EditProfileEntity profileEntity}) async{
     try{
       String fileName = profileEntity.fileImageUrl!.path.split('/').last;
       var request = http.MultipartRequest('POST', Uri.parse('https://cce5275ac71003a6.mokky.dev/uploads'));
       request.files.add(await http.MultipartFile.fromPath('file', profileEntity.fileImageUrl!.path,filename: fileName));
       var streamedResponse = await request.send();
       var response = await http.Response.fromStream(streamedResponse);
       if(streamedResponse.statusCode == 201){
         final url = convert.jsonDecode(response.body)['url'];
         return url;
       }else{
         throw const Failure('Ошибка загрузки фото');
       }

     } on Failure catch(e){

       throw  Failure(e.message);
     } on DioException catch(e){

       throw  Failure(e.toString());
     } catch(e){

       throw const Failure('Ошибка загрузки фото');
     }
   }

   Future<List<dynamic>> subways({required String  query}) async {
     try{
       final dioApi = locator.get<DioClient>().initApi();
     final user = locator.get<UserCubit>();
     final res =  await dioApi.post(Endpoints.subways,
           options: Options(
             headers: {"Authorization": "Token $apiKeyDaData"}
           ),
           data: {
            'query':query,
             'filters':[
               {
                 "city": user.userEntity.branchName,
               }
             ]
           });

      return res.data['suggestions'];
     } on Failure catch(e){

       throw  Failure(e.message);
     } on DioException catch(e){

       throw  Failure(e.toString());
     }
   }

 }


