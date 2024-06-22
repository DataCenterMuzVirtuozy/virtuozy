


  import 'package:virtuozy/data/mappers/lesson_mapper.dart';
import 'package:virtuozy/data/utils/teacher_util.dart';
import 'package:virtuozy/domain/entities/client_entity.dart';
import 'package:virtuozy/domain/entities/lesson_entity.dart';
import 'package:virtuozy/domain/entities/teacher_entity.dart';
import 'package:virtuozy/domain/repository/teacher_repository.dart';

import '../../di/locator.dart';
import '../../domain/entities/lids_entity.dart';

class TeacherRepositoryImpl extends TeacherRepository{


  final _util = locator.get<TeacherUtil>();

  @override
  Future<TeacherEntity> getTeacher({required String uid}) async {
   return await _util.getTeacher(uid: uid);
  }

  @override
  Future<void> editLesson({required Lesson lesson}) async {
     await _util.editLesson(lesson: lesson);
  }

  @override
  Future<void> addLesson({required Lesson lesson}) async {
    await _util.addLesson(lessonModel: LessonMapper.toApi(lesson));
  }

  @override
  Future<List<LidsEntity>> getLids({required int idTeacher}) async {
   return await _util.getLids(idTeacher:idTeacher);
  }

  @override
  Future<List<ClientEntity>> getClients({required int idTeacher}) async {
    return await _util.getClients(idTeacher: idTeacher);
  }

}