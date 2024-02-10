


  import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:virtuozy/resourses/colors.dart';
import 'package:virtuozy/utils/status_to_color.dart';

import '../domain/entities/user_entity.dart';
import '../utils/text_style.dart';

class Calendar extends StatelessWidget{
  const Calendar({super.key, required this.lessons});

  final List<Lesson> lessons;

  @override
  Widget build(BuildContext context) {
   return Container(
     decoration: BoxDecoration(
       color: Theme.of(context).colorScheme.surfaceVariant,
       borderRadius: BorderRadius.circular(20.0)
     ),
     child: TableCalendar(
       daysOfWeekHeight: 20.0,
       rowHeight: 40.0,
       weekNumbersVisible: false,
       daysOfWeekStyle: DaysOfWeekStyle(
         weekdayStyle: TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!),
         weekendStyle: TStyle.textStyleVelaSansBold(colorRed)
       ),
       firstDay: _getFirstDate(lessons: lessons),
       lastDay:_getLastDate(lessons: lessons),
       focusedDay: DateTime.now(),
       calendarStyle: CalendarStyle(
         tablePadding: const EdgeInsets.only(bottom: 10.0),
         selectedTextStyle: TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!),
         rangeStartTextStyle: TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!),
         disabledTextStyle: TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!),
         todayTextStyle: TStyle.textStyleVelaSansBold(colorWhite),
         rangeEndTextStyle: TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!),
         weekendTextStyle: TStyle.textStyleVelaSansBold(colorGrey),
         outsideTextStyle: TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!),
         defaultTextStyle: TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!),
         // todayDecoration: BoxDecoration(
         //   color: colorOrange,
         //   shape: BoxShape.circle,
         // )
       ),
       headerStyle:  HeaderStyle(
         titleCentered: true,
         titleTextStyle: TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!,size: 18.0),
         formatButtonVisible: false,
       ),
       calendarBuilders: CalendarBuilders(
         markerBuilder: (context, day,values) {
           return _handlerDay(lessons: lessons, day: day.day,context: context);
         },
       ),
       // selectedDayPredicate: (day){
       //   return true;
       // },
     ),
   );
  }

   _handlerDay({required List<Lesson> lessons,required int day,required BuildContext context}){
    final intDays = lessons.map((e) => DateFormat('yyyy-MM-dd').parse(e.date).day).toList();
    if(intDays.contains(day)){
      final lesson = lessons.firstWhere((element) => DateFormat('yyyy-MM-dd').parse(element.date).day == day);
      return Padding(
        padding: const EdgeInsets.all(3.0),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: StatusToColor.getColor(lessonStatus: lesson.status),
            shape: BoxShape.circle,
            border: Border.all(color: Theme.of(context).textTheme.displayMedium!.color!,
            width: 0.5)
          ),
          child: Center(
            child: Text(
              day.toString(),
              style:  TStyle.textStyleVelaSansBold(colorBlack),
            ),
          ),
        ),
      );
    }

  }

  DateTime _getFirstDate({required List<Lesson> lessons}){
    final List<int> millisecondsSinceEpochList = [];
    for(var element in lessons){
      millisecondsSinceEpochList.add(DateFormat('yyyy-MM-dd').parse(element.date).millisecondsSinceEpoch);

    }
    final indexFirst = millisecondsSinceEpochList.indexOf(millisecondsSinceEpochList.reduce(min));
    final monthFirst = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpochList[indexFirst]).month;
    final yearFirst = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpochList[indexFirst]).year;
    final dayFirst = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpochList[indexFirst]).day;
    return DateTime.utc(yearFirst, monthFirst, dayFirst);
  }


  DateTime _getLastDate({required List<Lesson> lessons}){
    final List<int> millisecondsSinceEpochList = [];

    for(var element in lessons){
      millisecondsSinceEpochList.add(DateFormat('yyyy-MM-dd').parse(element.date).millisecondsSinceEpoch);

    }
    final indexLast = millisecondsSinceEpochList.indexOf(millisecondsSinceEpochList.reduce(max));
    final monthLast = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpochList[indexLast]).month;
    final yearLast = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpochList[indexLast]).year;
    final dayLast = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpochList[indexLast]).day;
    return DateTime.utc(yearLast, monthLast, dayLast);
  }




}