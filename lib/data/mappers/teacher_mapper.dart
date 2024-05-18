

  import 'package:virtuozy/data/models/teacher_model.dart';
import 'package:virtuozy/domain/entities/teacher_entity.dart';

import '../../domain/entities/lesson_entity.dart';
import '../models/user_model.dart';

class TeacherMapper{



    static TeacherEntity fromApi({required TeacherModel teacherModel}){
      final lessons = teacherModel.lessons.map((e) => _fromLessonModel(e)).toList();
      lessons.add(Lesson(contactValues: ['',''],
          id: 33,
          idSub: 33,
          idSchool: 'мш2',
          bonus: false,
          timeAccept: '',
          date: '2024-05-16',
          timePeriod: '15:00-16:00',
          idAuditory: 'Rady',
          nameTeacher: 'Bob',
          nameStudent: 'Dan',
          status: LessonStatus.awaitAccept,
          nameDirection: 'Bass'));
      return TeacherEntity(
        lessons: lessons,
          id: teacherModel.id,
          lastName: teacherModel.lastName,
          firstName: teacherModel.firstName,
          phoneNum: teacherModel.phoneNum);
    }


    static Lesson _fromLessonModel(LessonModel lessonModel){
      return Lesson(
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
          idSchool: lessonModel.idSchool);
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
        case 8:return LessonStatus.awaitAccept;
        case 9: return LessonStatus.firstLesson;
        case 10: return LessonStatus.lastLesson;
      }
      return LessonStatus.unknown;
    }

  }

