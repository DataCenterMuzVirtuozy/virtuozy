


  import 'package:virtuozy/data/utils/teacher_util.dart';
import 'package:virtuozy/domain/entities/lesson_entity.dart';
import 'package:virtuozy/domain/entities/teacher_entity.dart';
import 'package:virtuozy/domain/repository/teacher_repository.dart';

import '../../di/locator.dart';

class TeacherRepositoryImpl extends TeacherRepository{

  final _util = locator.get<TeacherUtil>();

  @override
  Future<TeacherEntity> getTeacher({required String uid}) async {
   return await _util.getTeacher(uid: uid);
  }

  @override
  Future<void> editLesson({required Lesson lesson}) async {
    return await _util.editLesson(lesson: lesson);
  }

}