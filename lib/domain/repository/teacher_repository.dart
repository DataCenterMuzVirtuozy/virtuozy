


 import 'package:virtuozy/domain/entities/lesson_entity.dart';

import '../entities/teacher_entity.dart';

abstract class TeacherRepository{


   Future<TeacherEntity> getTeacher({required String uid});
    Future<void>  editLesson({required Lesson lesson});
 }