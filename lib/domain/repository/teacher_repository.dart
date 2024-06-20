


 import 'package:virtuozy/domain/entities/lesson_entity.dart';

import '../entities/lids_entity.dart';
import '../entities/teacher_entity.dart';

abstract class TeacherRepository{


   Future<TeacherEntity> getTeacher({required String uid});
    Future<void>  editLesson({required Lesson lesson});
   Future<void> addLesson({required Lesson lesson});
   Future<List<LidsEntity>> getLids({required int idTeacher});
}