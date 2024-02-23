


  import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:virtuozy/di/locator.dart';
import 'package:virtuozy/resourses/colors.dart';
import 'package:virtuozy/utils/status_to_color.dart';

import '../domain/entities/user_entity.dart';
import '../utils/text_style.dart';


//ValueNotifier<int> currentDayNotifi = ValueNotifier<int>(0);

class Calendar extends StatefulWidget{
  const Calendar({super.key, required this.lessons, required this.onLesson, required this.onMonth});

  final List<Lesson> lessons;
  final Function onLesson;
  final Function onMonth;




  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {


  final currentDayNotifi = locator.get<ValueNotifier<int>>();
  int month = 0;
  int i = 0;




  @override
  Widget build(BuildContext context) {


   return Container(
     decoration: BoxDecoration(
       color: Theme.of(context).colorScheme.surfaceVariant,
       borderRadius: BorderRadius.circular(20.0)
     ),
     child: Column(
       children: [
         TableCalendar(
           daysOfWeekHeight: 20.0,
           rowHeight: 40.0,
           weekNumbersVisible: false,
           daysOfWeekStyle: DaysOfWeekStyle(
             weekdayStyle: TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!),
             weekendStyle: TStyle.textStyleVelaSansBold(colorRed)
           ),
           firstDay: _getFirstDate(lessons: widget.lessons),
           lastDay:_getLastDate(lessons: widget.lessons),
           focusedDay: DateTime.now(),
           calendarStyle: CalendarStyle(
             tablePadding: const EdgeInsets.symmetric(horizontal: 10.0),
             selectedTextStyle: TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!),
             rangeStartTextStyle: TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!),
             disabledTextStyle: TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!),
             todayTextStyle: TStyle.textStyleVelaSansBold(colorWhite),
             rangeEndTextStyle: TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!),
             weekendTextStyle: TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!),
             outsideTextStyle: TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!),
             defaultTextStyle: TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!),
           ),
           headerStyle:  HeaderStyle(
             titleCentered: true,
             titleTextStyle: TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!,size: 18.0),
             formatButtonVisible: false,
           ),
           calendarBuilders: CalendarBuilders(
             defaultBuilder: (context, day,values) {
               _onMonth(day.month);
               return _handlerDay(
                   dateTime:day,
                   monthOfDay: day.month,
                   lessons: widget.lessons,
                   day: day.day,
                   context: context,
               onLesson: (lessons){
                 widget.onLesson.call(lessons);
               });
             },
           ),

         ),
         const InfoColor()
       ],
     ),
   );
  }


  _onMonth(int currentMonth){
    if(month == 0 || month!=currentMonth){
      widget.onMonth.call(currentMonth);
      month = currentMonth;
    }
  }

   _handlerDay({
     required List<Lesson> lessons,
     required int day,
     required DateTime dateTime,
     required int monthOfDay,
     required BuildContext context,
   required Function onLesson}){
    final stringDays = lessons.map((e) => e.date).toList();
     try{
       if(stringDays.contains(DateFormat('yyyy-MM-dd').format(dateTime))){
         final lesson = lessons.firstWhere((element) => DateFormat('yyyy-MM-dd').parse(element.date).day == day&&
             DateFormat('yyyy-MM-dd').parse(element.date).month == month);
         final monthLesson = DateFormat('yyyy-MM-dd').parse(lesson.date).month;
         if(monthLesson == monthOfDay) {
           final lessonsDay = _handleLessonsDay(lesson,lessons);
           return ValueListenableBuilder<int>(
               valueListenable: currentDayNotifi,
               builder: (context, valueDay, child) {
                 return Padding(
                   padding: const EdgeInsets.all(3.0),
                   child: InkWell(
                       borderRadius: BorderRadius.circular(60.0),
                       onTap: () {
                         onLesson.call(lessonsDay);
                         currentDayNotifi.value = day;
                       },
                       child: Container(
                         width: 45.0,
                         height: 45.0,
                         decoration: const BoxDecoration(
                           shape: BoxShape.circle
                         ),
                         child: Stack(
                           children: [

                             ...List.generate(lessonsDay.length, (index) {
                               return  RotationTransition(
                                 turns:  const AlwaysStoppedAnimation(135 / 360),
                                 child: Container(
                                   margin:  EdgeInsets.only(top: index>0?6.5:0.0,left: index>0?4.5:0.0),
                                   height: index>0?18.0:45.0,
                                   width: index>0?34.0:45.0,
                                   decoration: BoxDecoration(
                                       borderRadius: index == 0?null:const BorderRadius.vertical(bottom: Radius.circular(23.0)),
                                       color: StatusToColor.getColor(
                                           lessonStatus: lessonsDay.length>2?LessonStatus.layering:lessonsDay[index].status),
                                       shape: index==0?BoxShape.circle:BoxShape.rectangle,
                                       border: Border.all(color: colorOrange,
                                           width: valueDay == day ? 3.0 : 1.0)
                                   ),
                                 ),
                               );
                             }),
                             Center(
                               child: Text(
                                 day.toString(),
                                 style: TStyle.textStyleVelaSansBold(colorBlack),
                               ),
                             ),
                           ],
                         ),
                       )
                   ),
                 );
               }
           );
         }}
     }catch(e){
       print('$e');
     }

  }

  List<Lesson> _handleLessonsDay(Lesson lesson,List<Lesson> lessons){
    final resultLessons = lessons.where((e) => e.date == lesson.date).toList();
    return resultLessons;
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


class InfoColor extends StatefulWidget{
  const InfoColor({super.key});

  @override
  State<InfoColor> createState() => _InfoColorState();
}

class _InfoColorState extends State<InfoColor> {

   double _heightBoxInfo = 45.0;
   final double _heightBoxInfoOpened = 290.0;

  @override
  Widget build(BuildContext context) {

   return AnimatedContainer(
     padding: const EdgeInsets.symmetric(horizontal: 10.0),
     alignment: Alignment.topCenter,
      curve: Curves.easeIn,
      height: _heightBoxInfo,
      duration: const Duration(milliseconds: 300),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: GestureDetector(
          onTap: (){
            setState(() {
              if(_heightBoxInfo == 45.0){
                _heightBoxInfo = _heightBoxInfoOpened;
              }else{
                _heightBoxInfo = 45.0;
              }

            });
          },
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 1.0,
                    width: 20.0,
                    color: Theme.of(context).textTheme.displayMedium!.color!,
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if(_heightBoxInfo == 45.0){
                          _heightBoxInfo = _heightBoxInfoOpened;
                        }else{
                          _heightBoxInfo = 45.0;
                        }

                      });
                    },
                    icon: Icon(Icons.info_outline,
                        color: Theme.of(context).textTheme.displayMedium!.color!, size: 20.0),
                  ),
                  Container(
                    height: 1.0,
                    width: 20.0,
                    color: Theme.of(context).textTheme.displayMedium!.color!,
                  ),

                ],
              ),
              ...List.generate(StatusToColor.statusColors.length, (index){
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 2.0),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(10.0),
                          color: StatusToColor.statusColors[index]
                        ),
                        width: 30.0,
                        height: 20.0,
                      ),
                      const Gap(10.0),
                      Expanded(
                        child: Text(StatusToColor.namesStatus[index],
                          style: TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!),),
                      )
                    ],
                  ),
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}