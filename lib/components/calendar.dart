


  import 'package:flutter/cupertino.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:virtuozy/resourses/colors.dart';

import '../utils/text_style.dart';

class Calendar extends StatelessWidget{
  const Calendar({super.key});

  @override
  Widget build(BuildContext context) {
   return Container(
     decoration: BoxDecoration(
       color: colorBeruzaLight,
       borderRadius: BorderRadius.circular(20.0)
     ),
     child: TableCalendar(
       weekNumbersVisible: false,
       firstDay: DateTime.utc(2010, 10, 16),
       lastDay: DateTime.utc(2030, 3, 14),
       focusedDay: DateTime.now(),
       calendarStyle: CalendarStyle(
         selectedTextStyle: TStyle.textStyleVelaSansBold(colorBlack),
         rangeStartTextStyle: TStyle.textStyleVelaSansBold(colorBlack),
         disabledTextStyle: TStyle.textStyleVelaSansBold(colorBlack),
         todayTextStyle: TStyle.textStyleVelaSansBold(colorBlack),
         rangeEndTextStyle: TStyle.textStyleVelaSansBold(colorBlack),
         weekendTextStyle: TStyle.textStyleVelaSansBold(colorGrey),
         outsideTextStyle: TStyle.textStyleVelaSansBold(colorBlack),
         defaultTextStyle: TStyle.textStyleVelaSansBold(colorBlack),
         todayDecoration: BoxDecoration(
           color: colorOrange,
           shape: BoxShape.circle,
         )
       ),
       headerStyle:  HeaderStyle(
         titleTextStyle: TStyle.textStyleVelaSansBold(colorBlack,size: 18.0),
         formatButtonVisible: false,
       ),
       // selectedDayPredicate: (day){
       //   return true;
       // },
     ),
   );
  }



}