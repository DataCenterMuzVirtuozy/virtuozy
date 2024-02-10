


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
   const Color.fromRGBO(255, 255, 255, 0.0)
  ];


   static Color getColor({required LessonStatus lessonStatus}){
    switch(lessonStatus){
     case LessonStatus.booked: return _colors[0];
     case LessonStatus.complete: return _colors[0];
     case LessonStatus.cancel: return _colors[2];
     case LessonStatus.out: return _colors[4];
     case LessonStatus.reservation: return _colors[3];
     case LessonStatus.singly: return _colors[5];
     case LessonStatus.trial: return _colors[1];
      case LessonStatus.unknown: return _colors[6];

    }

   }

 }