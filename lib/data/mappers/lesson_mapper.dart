

 import 'package:virtuozy/data/models/user_model.dart';
import 'package:virtuozy/domain/entities/lesson_entity.dart';

class LessonMapper{


   static LessonModel toApi(Lesson lesson){
     return LessonModel(
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
       case LessonStatus.planned: return 1;
       case LessonStatus.complete: return 2;
       case LessonStatus.cancel: return 3;
       case LessonStatus.out: return 4;
       case LessonStatus.reservation: return 5;
       case LessonStatus.singly: return 6;
       case LessonStatus.trial: return 7;
       case LessonStatus.awaitAccept:return 8;
       case LessonStatus.firstLesson: return 9;
       case LessonStatus.lastLesson: return 10;
       case LessonStatus.unknown: return 0;
       case LessonStatus.layering: return 12;
       case LessonStatus.reschedule: return 11;

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