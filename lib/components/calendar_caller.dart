
 import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../domain/entities/lesson_entity.dart';
import 'dialogs/contents/bottom_sheet_menu/steps_confirm_lesson_content.dart';
import 'dialogs/dialoger.dart';

class CalendarCaller extends StatelessWidget{
  const CalendarCaller({super.key, required this.lessons, required this.dateSelect});
  final List<Lesson> lessons;
  final Function dateSelect;

  @override
  Widget build(BuildContext context) {
   return  Container(
     alignment: Alignment.center,
    // padding: const EdgeInsets.only(bottom: 10.0),
     decoration: BoxDecoration(
       borderRadius: BorderRadius.circular(20.0),
       color: Theme.of(context).colorScheme.surfaceVariant,
     ),
     child: IconButton(
       padding: const EdgeInsets.only(bottom: 1.0),
       onPressed: () {
       Dialoger.showSelectDate(context: context, lessons: lessons,
       onDate: (String date){
         currentDayNotifi.value = 0;
         dateSelect.call(date);
       });
     },
       icon: Icon(Icons.calendar_month,color: Theme.of(context)
           .textTheme.displayMedium!.color!,size: 18,),),
   );
  }

}