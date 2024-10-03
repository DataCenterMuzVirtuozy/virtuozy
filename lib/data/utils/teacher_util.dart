



 import 'package:flutter/cupertino.dart';
import 'package:virtuozy/data/mappers/clients_mapper.dart';
import 'package:virtuozy/data/mappers/lesson_mapper.dart';
import 'package:virtuozy/data/mappers/lids_mapper.dart';
import 'package:virtuozy/data/mappers/teacher_mapper.dart';
import 'package:virtuozy/data/models/client_model.dart';
import 'package:virtuozy/data/models/user_model.dart';
import 'package:virtuozy/data/services/teacher_service.dart';
import 'package:virtuozy/domain/entities/lesson_entity.dart';
import 'package:virtuozy/domain/entities/lids_entity.dart';

import '../../di/locator.dart';
import '../../domain/entities/client_entity.dart';
import '../../domain/entities/teacher_entity.dart';
import '../models/lesson_model.dart';
import '../models/lids_model.dart';

class TeacherUtil{


  final _service = locator.get<TeacherService>();

  Future<TeacherEntity> getTeacher({required String uid}) async {
   final model =await  _service.getTeacher(uid: uid);
   return TeacherMapper.fromApi(teacherModel: model);

  }

  Future<void> editLesson({required Lesson lesson}) async {
     await _service.editLesson(lessonModel: LessonMapper.toApi(lesson));
  }

  Future<void> addLesson({required LessonModel lessonModel}) async {
    await _service.addLesson(lessonModel: lessonModel);
  }

  // Future<List<LidsEntity>> getLids({required int idTeacher}) async {
  //  final maps =  await _service.getLids(idTeacher:idTeacher);
  //  final lidsModel =  maps.map((e) => LidsModel.fromApi(map: e)).toList();
  //  return lidsModel.map((e) => LidsMapper.fromApi(model: e)).toList();
  // }

  Future<List<ClientEntity>> getClients({required int idTeacher}) async {
    final map = await _service.getClients(idTeacher:idTeacher);
    return map.map((e) => ClientsMapper.fromApi(model: ClientModel.fromApi(map: e))).toList();
  }


}