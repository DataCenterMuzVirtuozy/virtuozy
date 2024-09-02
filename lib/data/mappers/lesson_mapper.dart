

 import 'package:virtuozy/data/models/user_model.dart';
import 'package:virtuozy/domain/entities/lesson_entity.dart';

class LessonMapper{


   static LessonModel toApi(Lesson lesson){
     return LessonModel(
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
       case LessonStatus.firstLesson: return 9345; //not work
       case LessonStatus.lastLesson: return 10345; //not work
       case LessonStatus.unknown: return 0;
       case LessonStatus.layering: return 12;
       case LessonStatus.reschedule: return 4; //not work
       case LessonStatus.freezing: return 8; //
     }

   }


   static int _lessonType(LessonType type){
     switch(type){
       case LessonType.trial: return 1;
       case LessonType.group: return 2;
       case LessonType.singly: return 3;
       case LessonType.unknown: return 0;

     }


   }

 }