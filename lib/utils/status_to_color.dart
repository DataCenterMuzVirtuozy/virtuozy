


 import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:virtuozy/domain/entities/user_entity.dart';

import '../domain/entities/client_entity.dart';
import '../domain/entities/lesson_entity.dart';

class StatusToColor{

  static final List<Color> _colors = [
     const Color.fromRGBO(255, 255, 255, 1.0),
   const Color.fromRGBO(255, 0, 0, 1.0),
   const Color.fromRGBO(255, 153, 0, 1.0),
   const Color.fromRGBO(245, 245, 245, 1.0),
   const Color.fromRGBO(120, 63, 4, 1.0),
   const Color.fromRGBO(153, 0, 255, 1.0),
   const Color.fromRGBO(230, 230, 230, 1.0),
    const Color.fromRGBO(0, 148, 77, 1.0),
    const Color.fromRGBO(3, 252, 244,1.0),
    const Color.fromRGBO(0, 255, 0, 1),
    const Color.fromRGBO(255, 230, 0, 1),
  ];

  static final List<String> _namesStatus = [
    'Запланирован',
    'Пробный урок',
        'Отмена урока',
    'Бронь',
    'Пропуск',
    'Самостоятельные',
    'Проведен',
     'Ожидает подтверждения ученика',
    'Совпадение уроков из нескольких направлений',
    'Первый урок',
    'Последний урок',
    'Перенесен',
    'Заморозка'


  ];

  static List<Color> get statusColors => _colors;

 static List<String> get namesStatus => _namesStatus;

 static String getNameStatus(LessonStatus status) {
   switch (status) {
     case LessonStatus.planned:
       return StatusToColor.namesStatus[0];
     case LessonStatus.complete:
       return StatusToColor.namesStatus[6];
     case LessonStatus.cancel:
       return StatusToColor.namesStatus[2];
     case LessonStatus.out:
       return StatusToColor.namesStatus[4];
     case LessonStatus.reservation:
       return StatusToColor.namesStatus[3];
     case LessonStatus.singly:
       return StatusToColor.namesStatus[5];
     case LessonStatus.trial:
       return StatusToColor.namesStatus[1];
     case LessonStatus.awaitAccept:
       return StatusToColor.namesStatus[7];
     case LessonStatus.layering:
       return StatusToColor.namesStatus[8];
     case LessonStatus.unknown:
       return '';

     case LessonStatus.reschedule:
       return StatusToColor.namesStatus[11];
     case LessonStatus.freezing: return  StatusToColor.namesStatus[12];

   }
 }

   static Color getColor({required Lesson lesson, UserType userType = UserType.unknown,}){

     if(userType.isTeacher){
       return _colors[3];
      }

     if(lesson.status == LessonStatus.layering){
       return _colors[8];
     }

     if(lesson.type!=LessonType.unknown){

       if(lesson.isFirst){
         return _colors[9];
       }

       if(lesson.isLast){
         return _colors[10];
       }

       if(lesson.type.isPU){
         return _colors[1];
       }

       if(lesson.type.isINDEPENDENT){
         return _colors[5];
       }

       if(lesson.type.isGROUP||lesson.type.isINDIVIDUAL&&lesson.isFirst){
         return _colors[9];
       }

       if(lesson.type.isGROUP||lesson.type.isINDIVIDUAL&&lesson.isLast){
         return _colors[10];
       }
     }

    switch(lesson.status){
     case LessonStatus.planned: return _colors[0];
     case LessonStatus.complete: return _colors[6];
     case LessonStatus.cancel: return _colors[2];
     case LessonStatus.out: return _colors[4];
     case LessonStatus.reservation: return _colors[3];
     case LessonStatus.singly: return _colors[5];
     case LessonStatus.trial: return _colors[1];
      case LessonStatus.awaitAccept:return _colors[7];
      case LessonStatus.layering: return _colors[8];
      case LessonStatus.unknown: return const Color.fromRGBO(255, 255, 255, 0.0);
      case LessonStatus.reschedule:return _colors[2];
      case LessonStatus.freezing: return _colors[5];

    }



   }

  static LessonStatus lessonStatusFromApi(int status){


   switch(status){
      case 1: return LessonStatus.planned; // !
      case 2: return LessonStatus.complete; // !
      case 3: return LessonStatus.cancel; // !
      case 6: return LessonStatus.out; // !
      case 7: return LessonStatus.reservation; // !
      case -1: return LessonStatus.singly; // not work
      case -2: return LessonStatus.trial;  //not work
      case 11 :return LessonStatus.awaitAccept;
      case 8 : return LessonStatus.freezing; // !
      case -3: return LessonStatus.reschedule; // not work
    }
    return LessonStatus.unknown;
  }

  static LessonType lessonType(int status){
    switch(status){
      case 3: return LessonType.CAN_PU_TYPE;
      case 2: return LessonType.PU_TYPE;
      case 5: return LessonType.GROUP_TYPE;
      case 4: return LessonType.RESERVE_TYPE;
      case 6: return LessonType.INDEPENDENT_TYPE; //самостоятельный
      case 1: return LessonType.INDIVIDUAL_TYPE; //индивидуальный
    }

    return LessonType.unknown;
  }



  static ClientStatus clientStatusFromApi(int status){
    switch(status){
      case 0: return ClientStatus.empty;
      case 1: return ClientStatus.action;
      case 2: return ClientStatus.archive;
      case 3: return ClientStatus.replacement;
      case 4: return ClientStatus.trial;
   }

   return ClientStatus.unknown;

  }


   //показать статус ближайшего урока
  static  Color getColorNearLesson({required List<Lesson> lessons,required DateTime today}){
    final dt = today.millisecondsSinceEpoch;
    for(var l  in lessons){
      final dl = DateFormat('yyyy-MM-dd').parse(l.date).millisecondsSinceEpoch;
      if(dl>dt){
        return getColor(lesson: l);
      }
    }
     return _colors[3];
   }

 }