



  import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:virtuozy/data/models/teacher_model.dart';
import 'package:virtuozy/data/models/user_model.dart';
import 'package:virtuozy/domain/entities/lesson_entity.dart';

import '../../di/locator.dart';
import '../../utils/failure.dart';
import '../rest/dio_client.dart';
import '../rest/endpoints.dart';

class TeacherService{

    final _dio = locator.get<DioClient>().init();



    Future<TeacherModel> getTeacher({required String uid}) async {
      try{
        final res = await _dio.get(Endpoints.teacher,
            queryParameters: {
              'phoneNum': uid.replaceAll(' ', '')
            });

        if((res.data as List<dynamic>).isEmpty){
          return throw   Failure('Пользователь не найден'.tr());
        }
        final idTeacher = res.data[0]['id'] as int;
        final resLesson = await _dio.get(Endpoints.lessons,
            // queryParameters: {
            //   'idTeacher': idTeacher
            // }
            );
        return TeacherModel.fromMap( mapTeacher: res.data[0], mapLessons: resLesson.data);
        //return TeacherModel.fromMap(mapTeacher: {}, mapLessons: []);
      } on Failure catch(e){
        throw  Failure(e.message);
      } on DioException catch(e){
        throw  Failure(e.message!);
      }
    }





    Future<void> editLesson({required LessonModel lessonModel}) async {
      try{
        await _dio.patch('${Endpoints.lessons}/${lessonModel.id}',
          data: {
            'status': lessonModel.status
          }
        );

      } on Failure catch(e){
        throw  Failure(e.message);
      } on DioException catch(e){
        throw  Failure(e.message!);
      }

    }

    Future<void> addLesson({required LessonModel lessonModel}) async {
      try{
        await _dio.post(Endpoints.lessons,
            data: LessonModel.toMap(lessonModel)
        );

      } on Failure catch(e){
        throw  Failure(e.message);
      } on DioException catch(e){
        throw  Failure(e.message!);
      }

    }







}


