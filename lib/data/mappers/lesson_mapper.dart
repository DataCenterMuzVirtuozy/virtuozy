

 import 'package:virtuozy/data/models/user_model.dart';
import 'package:virtuozy/domain/entities/lesson_entity.dart';

import '../../utils/status_to_color.dart';
import '../models/lesson_model.dart';

class LessonMapper{


   static LessonModel toApi(Lesson lesson){
     return LessonModel(
       nameSchool: lesson.nameSchool,
       nameAuditory: lesson.nameAuditory,
       isFirst: lesson.isFirst,
       isLast: lesson.isLast,
       nameGroup: lesson.nameGroup,
       idStudent: lesson.idStudent,
         nameSub: lesson.nameSub,
         comments: lesson.comments,
         duration: lesson.duration,
         online: lesson.online,
         type: _lessonType(lesson.type),
         idTeacher: lesson.idTeacher,
         contactValues: lesson.contactValues,
         idDir: lesson.idDir,
         idSchool: lesson.idSchool,
         nameStudent: lesson.nameStudent,
         nameDirection: lesson.nameDirection,
         id: lesson.id,
         idSub: lesson.idSub,
         timeAccept: lesson.timeAccept,
         date: lesson.date,
         timePeriod: lesson.timePeriod,
         idAuditory: lesson.idAuditory,
         nameTeacher: lesson.nameTeacher,
         status: _lessonStatus(lesson.status),
         bonus: lesson.bonus);
   }

   static Lesson fromLessonModel(LessonModel lessonModel){
     return Lesson(
       nameSchool: lessonModel.nameSchool,
       nameAuditory: lessonModel.nameAuditory,
         isFirst: lessonModel.isFirst,
         isLast: lessonModel.isLast,
         nameGroup: lessonModel.nameGroup,
         idStudent: lessonModel.idStudent,
         idDir: lessonModel.idDir,
         idTeacher: lessonModel.idTeacher,
         type: StatusToColor.lessonType(lessonModel.type),
         alien: true,
         comments: lessonModel.comments,
         nameSub: lessonModel.nameSub,
         duration: lessonModel.duration,
         online: lessonModel.online,
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
         idSchool: lessonModel.idSchool);
   }



   static int _lessonStatus(LessonStatus status){
     switch(status){
       case LessonStatus.planned: return 1; //
       case LessonStatus.complete: return 2; //
       case LessonStatus.cancel: return 3; //
       case LessonStatus.out: return 6; //
       case LessonStatus.reservation: return 7; //
       case LessonStatus.singly: return 6343; //not work
       case LessonStatus.trial: return 73453; //not work
       case LessonStatus.awaitAccept:return 834; //not work
       case LessonStatus.unknown: return 0;
       case LessonStatus.layering: return 12;
       case LessonStatus.reschedule: return 4; //not work
       case LessonStatus.freezing: return 8; //
     }

   }


   static int _lessonType(LessonType type){
     switch(type){
       // case 3: return LessonType.CAN_PU_TYPE;
       // case 2: return LessonType.PU_TYPE;
       // case 5: return LessonType.GROUP_TYPE;
       // case 4: return LessonType.RESERVE_TYPE;
       // case 6: return LessonType.INDEPENDENT_TYPE;
       // case 1: return LessonType.INDIVIDUAL_TYPE;
       case LessonType.PU_TYPE: return 2;
       case LessonType.GROUP_TYPE: return 5;
       case LessonType.INDIVIDUAL_TYPE: return 1;
       case LessonType.unknown: return 0;

       case LessonType.CAN_PU_TYPE:
        return  3;
       case LessonType.RESERVE_TYPE:
         return 4;
       case LessonType.INDEPENDENT_TYPE:
         return 6;
     }


   }

 }