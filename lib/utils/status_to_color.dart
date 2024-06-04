


 import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:virtuozy/domain/entities/user_entity.dart';

import '../domain/entities/lesson_entity.dart';

class StatusToColor{

  static final List<Color> _colors = [
     const Color.fromRGBO(255, 255, 255, 1.0),
   const Color.fromRGBO(255, 0, 0, 1.0),
   const Color.fromRGBO(255, 153, 0, 1.0),
   const Color.fromRGBO(243, 243, 243, 1.0),
   const Color.fromRGBO(120, 63, 4, 1.0),
   const Color.fromRGBO(153, 0, 255, 1.0),
   const Color.fromRGBO(255, 255, 255, 1.0),
    const Color.fromRGBO(0, 148, 77, 1.0),
    const Color.fromRGBO(3, 252, 244,1.0),
    const Color.fromRGBO(0, 255, 0, 1),
    const Color.fromRGBO(255, 230, 0, 1)
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
    'Совпадение дней из нескольких направлений',
    'Первый урок',
    'Последний урок',
    'Перенесен'

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
     case LessonStatus.firstLesson:
       return StatusToColor.namesStatus[9];
     case LessonStatus.lastLesson:
       return StatusToColor.namesStatus[10];
     case LessonStatus.unknown:
       return '';

     case LessonStatus.reschedule:
       return StatusToColor.namesStatus[11];
   }
 }

   static Color getColor({required LessonStatus lessonStatus, UserType userType = UserType.unknown}){

     if(userType.isTeacher){
       return _colors[3];
      }

    switch(lessonStatus){
     case LessonStatus.planned: return _colors[6];
     case LessonStatus.complete: return _colors[0];
     case LessonStatus.cancel: return _colors[2];
     case LessonStatus.out: return _colors[4];
     case LessonStatus.reservation: return _colors[3];
     case LessonStatus.singly: return _colors[5];
     case LessonStatus.trial: return _colors[1];
      case LessonStatus.awaitAccept:return _colors[7];
      case LessonStatus.layering: return _colors[8];
      case LessonStatus.unknown: return const Color.fromRGBO(255, 255, 255, 0.0);
      case LessonStatus.firstLesson: return _colors[9];
      case LessonStatus.lastLesson: return _colors[10];

      case LessonStatus.reschedule:
        return _colors[2];
    }

   }


   //показать статус ближайшего урока
  static  Color getColorNearLesson({required List<Lesson> lessons,required DateTime today}){
    final dt = today.millisecondsSinceEpoch;
    for(var l  in lessons){
      final dl = DateFormat('yyyy-MM-dd').parse(l.date).millisecondsSinceEpoch;
      if(dl>dt){
        return getColor(lessonStatus: l.status);
      }
    }
     return _colors[3];
   }

 }