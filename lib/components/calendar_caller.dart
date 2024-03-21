
 import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../domain/entities/lesson_entity.dart';
import 'dialogs/dialoger.dart';

class CalendarCaller extends StatelessWidget{
  const CalendarCaller({super.key, required this.lessons});
  final List<Lesson> lessons;

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
       Dialoger.showSelectDate(context: context, lessons: lessons);
     },
       icon: Icon(Icons.calendar_month,color: Theme.of(context)
           .textTheme.displayMedium!.color!,size: 18,),),
   );
  }

}