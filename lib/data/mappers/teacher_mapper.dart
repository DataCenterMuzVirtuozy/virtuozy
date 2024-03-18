

  import 'package:virtuozy/data/models/teacher_model.dart';
import 'package:virtuozy/domain/entities/teacher_entity.dart';

class TeacherMapper{



    static TeacherEntity fromApi({required TeacherModel teacherModel}){
      return TeacherEntity(
          id: teacherModel.id,
          lastName: teacherModel.lastName,
          firstName: teacherModel.firstName,
          phoneNum: teacherModel.phoneNum);
    }

  }