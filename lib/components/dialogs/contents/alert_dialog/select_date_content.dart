



 import 'package:flutter/cupertino.dart';
import 'package:virtuozy/resourses/colors.dart';

import '../../../../domain/entities/lesson_entity.dart';
import '../../../calendar/calendar.dart';
import '../bottom_sheet_menu/steps_confirm_lesson_content.dart';

class SelectDateContent extends StatelessWidget{
  const SelectDateContent({super.key, required this.lessons, required this.onDate});


  final List<Lesson> lessons;
  final Function onDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      constraints: const BoxConstraints(maxWidth: 400.0,maxHeight: 600.0),
      width: MediaQuery.of(context).size.width-100.0,
      height: MediaQuery.of(context).size.height/2.7,
      child: SingleChildScrollView(
        child: Calendar(
          focusedDay: DateTime.now(),
          visibleStatusColor: true,
          visibleInfoColors: false,
          clickableDay: true,
          focusedDayStatus: false,
          resetFocusDay: false,
          lessons: lessons,
          onMonth: (month){

          },
          onDate:(String date){
            onDate.call(date);
            Navigator.pop(context);
          },
          onLesson: (lessons){

          },),
      ),
    );
  }







}