



 import 'package:virtuozy/data/mappers/teacher_mapper.dart';
import 'package:virtuozy/data/services/teacher_service.dart';

import '../../di/locator.dart';
import '../../domain/entities/teacher_entity.dart';

class TeacherUtil{


  final _service = locator.get<TeacherService>();

  Future<TeacherEntity> getTeacher({required String uid}) async {
   final model =await  _service.getTeacher(uid: uid);
   return TeacherMapper.fromApi(teacherModel: model);

  }

 }