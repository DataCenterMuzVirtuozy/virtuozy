

  import 'package:virtuozy/data/models/teacher_model.dart';
import 'package:virtuozy/domain/entities/teacher_entity.dart';
import 'package:virtuozy/domain/entities/user_entity.dart';

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
        idDir: lessonModel.idDir,
        comments: lessonModel.comments,
        nameSub: lessonModel.nameSub,
        duration: lessonModel.duration,
        idTeacher: idTeacher,
        type: _lessonType(lessonModel.type),
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
          status: _lessonStatus(lessonModel.status),
          nameStudent: lessonModel.nameStudent,
          idSchool: lessonModel.idSchool,
          online: lessonModel.online);
    }

    static LessonType _lessonType(int status){
      switch(status){
        case 1: return LessonType.trial;
        case 2: return LessonType.group;
        case 3: return LessonType.singly;
      }

      return LessonType.unknown;
    }


    static LessonStatus _lessonStatus(int status){
      switch(status){
        case 1: return LessonStatus.planned;
        case 2: return LessonStatus.complete;
        case 3: return LessonStatus.cancel;
        case 4: return LessonStatus.out;
        case 5: return LessonStatus.reservation;
        case 6: return LessonStatus.singly;
        case 7: return LessonStatus.trial;
        case 8 :return LessonStatus.awaitAccept;
        case 9: return LessonStatus.firstLesson;
        case 10: return LessonStatus.lastLesson;
      }
      return LessonStatus.unknown;
    }

  }

