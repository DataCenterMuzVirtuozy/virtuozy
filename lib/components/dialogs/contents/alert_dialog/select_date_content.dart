



 import 'package:flutter/cupertino.dart';
import 'package:virtuozy/resourses/colors.dart';

import '../../../../domain/entities/lesson_entity.dart';
import '../../../calendar/calendar.dart';

class SelectDateContent extends StatelessWidget{
  const SelectDateContent({super.key, required this.lessons,});


  final List<Lesson> lessons;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      constraints: const BoxConstraints(maxWidth: 400.0,maxHeight: 600.0),
      width: MediaQuery.of(context).size.width-100.0,
      height: MediaQuery.of(context).size.height/2.7,
      child: Calendar(
        visibleInfoColors: false,
        resetFocusDay: false,
        lessons: lessons,
        onMonth: (month){

        },
        onLesson: (lessons){
            Navigator.pop(context);
        },),
    );
  }







}