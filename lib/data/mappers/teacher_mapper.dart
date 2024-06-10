

  import 'package:virtuozy/data/models/teacher_model.dart';
import 'package:virtuozy/domain/entities/teacher_entity.dart';
import 'package:virtuozy/domain/entities/user_entity.dart';
import 'package:virtuozy/utils/status_to_color.dart';

import '../../domain/entities/lesson_entity.dart';
import '../models/user_model.dart';

class TeacherMapper{



    static TeacherEntity fromApi({required TeacherModel teacherModel}){
      final lessons = teacherModel.lessons.map((e) => _fromLessonModel(e,teacherModel.id)).toList();
      return TeacherEntity(
        lessons: lessons,
          userStatus: UserStatus.auth,
          id: teacherModel.id,
          lastName: teacherModel.lastName,
          firstName: teacherModel.firstName,
          phoneNum: teacherModel.phoneNum,
          urlAva: teacherModel.urlAva);
    }


    static Lesson _fromLessonModel(LessonModel lessonModel, int idTeacher){
      return Lesson(
        nameGroup: lessonModel.nameGroup,
        idStudent: lessonModel.idStudent,
        idDir: lessonModel.idDir,
        comments: lessonModel.comments,
        nameSub: lessonModel.nameSub,
        duration: lessonModel.duration,
        idTeacher: idTeacher,
        type: StatusToColor.lessonType(lessonModel.type),
          alien: lessonModel.idTeacher != idTeacher,
          contactValues: lessonModel.contactValues,
          idSub: lessonModel.idSub,
          bonus: lessonModel.bonus,
          nameDirection: lessonModel.nameDirection,
          id: lessonModel.id,
          date: lessonModel.date,
          timePeriod: lessonModel.timePeriod,
          idAuditory: lessonModel.idAuditory,
          nameTeacher: lessonModel.nameTeacher,
          timeAccept: lessonModel.timeAccept,
          status: StatusToColor.lessonStatusFromApi(lessonModel.status),
          nameStudent: lessonModel.nameStudent,
          idSchool: lessonModel.idSchool,
          online: lessonModel.online);
    }






  }

