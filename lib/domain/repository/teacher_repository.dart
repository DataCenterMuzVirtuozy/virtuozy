


 import 'package:virtuozy/domain/entities/client_entity.dart';
import 'package:virtuozy/domain/entities/lesson_entity.dart';

import '../entities/lids_entity.dart';
import '../entities/teacher_entity.dart';

abstract class TeacherRepository{


   Future<TeacherEntity> getTeacher({required String uid});
    Future<void>  editLesson({required Lesson lesson});
   Future<void> addLesson({required Lesson lesson});
   Future<List<LidsEntity>> getLids({required int idTeacher});
   Future<List<ClientEntity>> getClients({required int idTeacher});
}