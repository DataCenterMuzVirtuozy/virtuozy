


 import '../entities/teacher_entity.dart';

abstract class TeacherRepository{


   Future<TeacherEntity> getTeacher({required String uid});

 }