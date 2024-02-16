


 import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:virtuozy/domain/entities/user_entity.dart';

class StatusToColor{

  static final List<Color> _colors = [
     const Color.fromRGBO(255, 255, 255, 1.0),
   const Color.fromRGBO(255, 0, 0, 1.0),
   const Color.fromRGBO(255, 153, 0, 1.0),
   const Color.fromRGBO(243, 243, 243, 1.0),
   const Color.fromRGBO(120, 63, 4, 1.0),
   const Color.fromRGBO(153, 0, 255, 1.0),
   const Color.fromRGBO(255, 255, 255, 1.0),
    const Color.fromRGBO(0, 148, 77, 1.0)
  ];

  static final List<String> _namesStatus = [
    'Запланирован',
    'Пробный урок',
        'Отмена урока',
    'Бронь',
    'Пропуск',
    'Самостоятельные',
    'Проведен',
     'Ожидает подтверждения ученика'
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
     case LessonStatus.unknown:
       return '';
   }
 }

   static Color getColor({required LessonStatus lessonStatus}){
    switch(lessonStatus){
     case LessonStatus.planned: return _colors[6];
     case LessonStatus.complete: return _colors[0];
     case LessonStatus.cancel: return _colors[2];
     case LessonStatus.out: return _colors[4];
     case LessonStatus.reservation: return _colors[3];
     case LessonStatus.singly: return _colors[5];
     case LessonStatus.trial: return _colors[1];
      case LessonStatus.awaitAccept:return _colors[7];
      case LessonStatus.unknown: return const Color.fromRGBO(255, 255, 255, 0.0);

    }

   }

 }