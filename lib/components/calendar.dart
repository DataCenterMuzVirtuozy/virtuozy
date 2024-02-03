


  import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:virtuozy/resourses/colors.dart';

import '../utils/text_style.dart';

class Calendar extends StatelessWidget{
  const Calendar({super.key});

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
       firstDay: DateTime.utc(2010, 10, 16),
       lastDay: DateTime.utc(2030, 3, 14),
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
           if (day.day == 22) {
             final text = DateFormat.E().format(day);
             return DecoratedBox(
               decoration: BoxDecoration(
                 color: colorBeruza,
                 shape: BoxShape.circle,
               ),
               child: Center(
                 child: Text(
                     day.day.toString(),
                   style:  TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!),
                 ),
               ),
             );
           }
           if (day.day == 5) {
             final text = DateFormat.E().format(day);
             return DecoratedBox(
               decoration: BoxDecoration(
                 color: colorGrey,
                 shape: BoxShape.circle,
               ),
               child: Center(
                 child: Text(
                     day.day.toString(),
                   style:  TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!),
                 ),
               ),
             );
           }
           if (day.day == 10) {
             final text = DateFormat.E().format(day);
             return DecoratedBox(
               decoration: BoxDecoration(
                 color: colorRed,
                 shape: BoxShape.circle,
               ),
               child: Center(
                 child: Text(
                   day.day.toString(),
                   style:  TStyle.textStyleVelaSansBold(colorBlack),
                 ),
               ),
             );
           }
         },
       ),
       // selectedDayPredicate: (day){
       //   return true;
       // },
     ),
   );
  }



}