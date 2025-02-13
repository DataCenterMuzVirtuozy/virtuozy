import 'dart:async';
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:virtuozy/di/locator.dart';
import 'package:virtuozy/resourses/colors.dart';
import 'package:virtuozy/utils/auth_mixin.dart';
import 'package:virtuozy/utils/status_to_color.dart';

import '../../domain/entities/lesson_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../utils/text_style.dart';
import '../dialogs/dialoger.dart';
import 'custom_table_calendar.dart';

//ValueNotifier<int> currentDayNotifi = ValueNotifier<int>(0);

/// [resetFocusDay] true - при вызове метода build, возвращает календарь на текущую дату
///
class Calendar extends StatefulWidget {
  const Calendar(
      {super.key,
      required this.lessons,
      required this.onLesson,
      required this.onMonth,
      this.clickableDay = true,
      this.resetFocusDay = true,
      this.focusedDayStatus = true,
      this.visibleStatusColor = true,
      this.visibleInfoColors = true,
      this.colorFill = Colors.transparent,
      required this.onDate,
      required this.focusedDay});

  final List<Lesson> lessons;
  final Function onLesson;
  final Function onMonth;
  final Function onDate;
  final bool clickableDay;
  final DateTime focusedDay;
  final bool focusedDayStatus;
  final bool visibleStatusColor;
  final bool resetFocusDay;
  final Color colorFill;
  final bool visibleInfoColors;

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> with AuthMixin {
  final currentDayNotifi = locator.get<ValueNotifier<List<int>>>();
  int month = 0;
  DateTime day = DateTime.now();
  int i = 0;
  late DateTime _firstDay;
  late DateTime _focusedDay;
  late DateTime _lastDay;
  late DateTime _toDay;
  late int interval = 2000;
  var isClicked = false;
  late Timer _timer;

  _startTimer() {
    _timer = Timer(Duration(milliseconds: interval), () => isClicked = false);
  }

  @override
  void initState() {
    super.initState();
    _toDay = DateTime.now();
    _focusedDay = widget.focusedDay;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.resetFocusDay) {
      _focusedDay = DateTime.now();
    }
    _firstDay = _getFirstDate(lessons: widget.lessons);
    _lastDay = _getLastDate(lessons: widget.lessons);

    return Container(
      decoration: BoxDecoration(
          color: widget.colorFill,
          borderRadius: BorderRadius.circular(20.0)),
      child: Column(
        children: [
          CustomTableCalendar(
            key: ValueKey(_firstDay),
            daysOfWeekHeight: 20.0,
            rowHeight: 40.0,
            weekNumbersVisible: false,
            weekendDays: const [DateTime.saturday, DateTime.sunday],
            startingDayOfWeek: StartingDayOfWeek.monday,
            daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: TStyle.textStyleVelaSansBold(
                    Theme.of(context).textTheme.displayMedium!.color!),
                weekendStyle: TStyle.textStyleVelaSansBold(colorRed)),
            firstDay: _firstDay,
            lastDay: _lastDay,
            focusedDay: _focusedDay,
            onDayTapped: (DateTime day) {

              //widget.onDate.call(day.toString().split(' ')[0]);
            },
            calendarStyle: CalendarStyle(
              tablePadding: const EdgeInsets.symmetric(horizontal: 10.0),
              selectedTextStyle: TStyle.textStyleVelaSansBold(
                  Theme.of(context).textTheme.displayMedium!.color!),
              rangeStartTextStyle: TStyle.textStyleVelaSansBold(
                  Theme.of(context).textTheme.displayMedium!.color!),
              disabledTextStyle: TStyle.textStyleVelaSansBold(
                  Theme.of(context).textTheme.displayMedium!.color!),
              todayTextStyle: TStyle.textStyleVelaSansBold(colorWhite),
              rangeEndTextStyle: TStyle.textStyleVelaSansBold(
                  Theme.of(context).textTheme.displayMedium!.color!),
              weekendTextStyle: TStyle.textStyleVelaSansBold(
                  Theme.of(context).textTheme.displayMedium!.color!),
              outsideTextStyle: TStyle.textStyleVelaSansBold(
                  Theme.of(context).textTheme.displayMedium!.color!),
              defaultTextStyle: TStyle.textStyleVelaSansBold(
                  Theme.of(context).textTheme.displayMedium!.color!),
            ),
            onDaySelected: (d1, d2) {
              final selDay = d2.day;
              final nowDay = DateTime.now().day;
              if (selDay == nowDay) {
                Dialoger.showMessage('Нет записей на текущий день'.tr(),
                    context: context);
              }
            },
            headerStyle: HeaderStyle(
              titleCentered: true,
              titleTextStyle: TStyle.textStyleVelaSansBold(
                  Theme.of(context).textTheme.displayMedium!.color!,
                  size: 18.0),
              formatButtonVisible: false,
            ),
            onPageChanged: (day) {
              // if (_focusedDay.month < day.month) {
              //   print('Left');
              //   final h = _hasLessons(lessons: widget.lessons, dateTime: day);
              //   if(h){
              //     return;
              //   }
              //   Dialoger.showMessage('Нет записей на прошлый месяц'.tr(),
              //       context: context);
              //   return;
              // } else if (_focusedDay.month < day.month) {
              //   print('Right');
              //   final h = _hasLessons(lessons: widget.lessons, dateTime: day);
              //   // if(h){
              //   //   return;
              //   // }
              //   Dialoger.showMessage('Нет записей на следующий месяц'.tr(),
              //       context: context);
              //   return;
              // }
               _focusedDay = day;
              // final h = _hasLessons(lessons: widget.lessons, dateTime: day);
              // if(h){
              //   return;
              // }
              // if (isClicked == false) {
              //       _startTimer();
              //       Dialoger.showMessage('Нет записей в этом месяце'.tr(),
              //           context: context);
              //      isClicked = true;
              //     }



            },
            calendarBuilders: CalendarBuilders(
              outsideBuilder: (context, day, values) {
                return _handlerDay(
                    toDay: _toDay,
                    focusedDayStatus: widget.focusedDayStatus,
                    visibleStatusColor: widget.visibleStatusColor,
                    clickableDay: widget.clickableDay,
                    dateTime: day,
                    monthOfDay: day.month,
                    lessons: widget.lessons,
                    day: day.day,
                    context: context,
                    onLesson: (List<Lesson> lessons) {
                      widget.onLesson.call(lessons);
                    });
              },
              todayBuilder: (context, day, values) {
                if (userType.isTeacher) {
                  return _handleTodayTeacher(
                      onLesson: (d) {
                        //widget.onDate.call(d.toString().split(' ')[0]);
                      },
                      lessons: widget.lessons,
                      today: day);
                }
                return _handlerDay(
                    toDay: _toDay,
                    visibleStatusColor: widget.visibleStatusColor,
                    clickableDay: widget.clickableDay,
                    dateTime: day,
                    focusedDayStatus: widget.focusedDayStatus,
                    monthOfDay: day.month,
                    lessons: widget.lessons,
                    day: day.day,
                    context: context,
                    onLesson: (List<Lesson> lessons) {
                      widget.onLesson.call(lessons);
                    });
              },
              defaultBuilder: (context, day, values) {
                _onDay(day);
                _onMonth(day.month);
                return _handlerDay(
                  toDay: _toDay,
                    focusedDayStatus: widget.focusedDayStatus,
                    visibleStatusColor: widget.visibleStatusColor,
                    clickableDay: widget.clickableDay,
                    dateTime: day,
                    monthOfDay: day.month,
                    lessons: widget.lessons,
                    day: day.day,
                    context: context,
                    onLesson: (List<Lesson> lessons) {
                      widget.onLesson.call(lessons);
                    });
              },
            ),
            onLeftChevronTap: () {
              if (_focusedDay.month == _firstDay.month) {
                if (isClicked == false) {
                  _startTimer();
                  Dialoger.showMessage('Нет записей на прошлый месяц'.tr(),
                      context: context);
                  isClicked = true;
                }
              }
            },
            onRightChevronTap: () {
              if (_focusedDay.month == _lastDay.month) {
                if (isClicked == false) {
                  _startTimer();
                  Dialoger.showMessage('Нет записей на следующий месяц'.tr(),
                      context: context);
                  isClicked = true;
                }
              }
            },
          ),
          Visibility(
              visible: widget.visibleInfoColors, child: const InfoColor())
        ],
      ),
    );
  }

  _onMonth(int currentMonth) {
    if (month == 0 || month != currentMonth) {
      widget.onMonth.call(currentMonth);
      month = currentMonth;
    }
  }

  _onDay(DateTime currentDay) {
    if (day.month != currentDay.month) {
      widget.onDate.call(currentDay);
      day = currentDay;
    }
  }

  _handleTodayTeacher(
      {required List<Lesson> lessons,
      required DateTime today,
      required Function onLesson}) {
    return ValueListenableBuilder<List<int>>(
        valueListenable: currentDayNotifi,
        builder: (context, valueDay, child) {
          return Padding(
            padding: const EdgeInsets.all(3.0),
            child: InkWell(
                borderRadius: BorderRadius.circular(60.0),
                onTap: () {
                  onLesson.call(today);
                  //currentDayNotifi.value = today.day;
                },
                child: Container(
                  width: 45.0,
                  height: 45.0,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 45.0,
                        width: 45.0,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: StatusToColor.getColorNearLesson(
                                lessons: lessons, today: today),
                            border: Border.all(
                                color: colorOrange,
                                width: valueDay[0] == today.day && valueDay[1] == today.month ? 3.0 : 1.0)),
                      ),
                      Center(
                        child: Text(
                          today.day.toString(),
                          style: TStyle.textStyleVelaSansBold(colorBlack),
                        ),
                      ),
                    ],
                  ),
                )),
          );
        });
  }

  bool _hasLessons({required List<Lesson> lessons, required DateTime dateTime}){
     final l = lessons.where((l)=> DateFormat('yyyy-MM-dd').parse(l.date).month == dateTime.month&&
         DateFormat('yyyy-MM-dd').parse(l.date).year == dateTime.year).toList();
      return l.isNotEmpty;
   }

  _handlerDay(
      {required List<Lesson> lessons,
      required int day,
      required bool focusedDayStatus,
      required bool visibleStatusColor,
      required DateTime dateTime,
      required int monthOfDay,
        required DateTime toDay,
      required BuildContext context,
      required bool clickableDay,
      required Function onLesson}) {
    try {
      final stringDays = lessons.map((e) => e.date).toList();
      final today = toDay.day == dateTime.day&&toDay.month == dateTime.month;
      if (stringDays.contains(DateFormat('yyyy-MM-dd').format(dateTime))) {
        Lesson lesson = lessons.firstWhere((element) =>
            DateFormat('yyyy-MM-dd').parse(element.date).day == day &&
            DateFormat('yyyy-MM-dd').parse(element.date).month == monthOfDay &&
            DateFormat('yyyy-MM-dd').parse(element.date).year == dateTime.year);
        // final monthLesson = DateFormat('yyyy-MM-dd')
        //     .parse(lesson.date)
        //     .month;
        // if (monthLesson != monthOfDay) {
        //   return;
        // }
        final lessonsDay = _handleLessonsDay(lesson, lessons);

        return ValueListenableBuilder<List<int>>(
            valueListenable: currentDayNotifi,
            builder: (context, valuesDay, child) {
              // lesson = lesson.copyWith(
              //     status: lessonsDay.length > 1
              //         ? LessonStatus.layering
              //         : lessonsDay[0].status);
              return Padding(
                padding: const EdgeInsets.all(3.0),
                child: InkWell(
                    borderRadius: BorderRadius.circular(60.0),
                    onTap: () {
                      if (clickableDay) {
                        onLesson.call(lessonsDay);
                        if (!focusedDayStatus) {
                          return;
                        }

                        currentDayNotifi.value = [day,dateTime.month];
                      }
                    },
                    child: Container(
                      width: 45.0,
                      height: 45.0,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: 45.0,
                            width: 45.0,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: visibleStatusColor
                                    ? StatusToColor.getColor(
                                    lesson: lessonsDay.length>1?lessonsDay[1]:
                                    lesson, userType: userType)
                                    : Colors.transparent,
                                border: Border.all(
                                    color: colorOrange,
                                    width: valuesDay[0] == day&&valuesDay[1] == dateTime.month ? 3.0 : 1.0)),
                          ),
                          Visibility(
                            visible: lessonsDay.length>1,
                            child: Positioned(
                              top: 2.5,
                              left: -1,
                              child: RotationTransition(
                                turns: const AlwaysStoppedAnimation(135 / 360),
                                child: Container(
                                  height: 18.0,
                                  width: 33.0,
                                  decoration: BoxDecoration(
                                      color: visibleStatusColor
                                          ? StatusToColor.getColor(
                                          lesson: lessonsDay.length>1?lessonsDay[0]:lesson, userType: userType)
                                          : Colors.transparent,
                                      borderRadius:  const BorderRadius.only(
                                  bottomLeft: Radius.circular(45),
                                    bottomRight: Radius.circular(45)),
                                      border: Border.all(
                                          color: colorOrange,
                                          width: valuesDay[0] == day&&valuesDay[1] == dateTime.month ? 3.0 : 1.0)),

                                ),
                              ),
                            ),
                          ),
                          // Visibility(
                          //     visible: lessonsDay.length > 1,
                          //     child: RotationTransition(
                          //       turns: const AlwaysStoppedAnimation(135 / 360),
                          //       child: Container(
                          //         margin: const EdgeInsets.all(5),
                          //         height: valueDay == day ? 3.0 : 1.0,
                          //         color: colorOrange,
                          //       ),
                          //     )),
                          Center(
                            child: Text(
                              day.toString(),
                              style: TStyle.textStyleVelaSansBold(colorBlack,size: today?16:12),
                            ),
                          ),
                        ],
                      ),
                    )),
              );
            });
      }
    } catch (e) {
      print('Error ${e.toString()}');
    }
  }

  List<Lesson> _handleLessonsDay(Lesson lesson, List<Lesson> lessons) {
    final resultLessons = lessons.where((e) => e.date == lesson.date).toList();
    return resultLessons;
  }

  DateTime _getFirstDate({required List<Lesson> lessons}) {
    final List<int> millisecondsSinceEpochList = [];

    if (lessons.isEmpty) {
      final date =
          DateTime.now().millisecondsSinceEpoch - 10519200000; // -4 month
      return DateTime.fromMillisecondsSinceEpoch(date.toInt());
    }

    for (var element in lessons) {
      millisecondsSinceEpochList.add(
          DateFormat('yyyy-MM-dd').parse(element.date).millisecondsSinceEpoch);
    }

    final indexFirst = millisecondsSinceEpochList
        .indexOf(millisecondsSinceEpochList.reduce(min));
    final monthFirst = DateTime.fromMillisecondsSinceEpoch(
            millisecondsSinceEpochList[indexFirst])
        .month;
    final yearFirst = DateTime.fromMillisecondsSinceEpoch(
            millisecondsSinceEpochList[indexFirst])
        .year;
    final dayFirst = DateTime.fromMillisecondsSinceEpoch(
            millisecondsSinceEpochList[indexFirst])
        .day;
    return DateTime.utc(yearFirst, monthFirst, dayFirst);
  }

  DateTime _getLastDate({required List<Lesson> lessons}) {
    // final List<int> millisecondsSinceEpochList = [];
    //
    // for(var element in lessons){
    //   millisecondsSinceEpochList.add(DateFormat('yyyy-MM-dd').parse(element.date).millisecondsSinceEpoch);
    //
    // }
    // final indexLast = millisecondsSinceEpochList.indexOf(millisecondsSinceEpochList.reduce(max));
    // final monthLast = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpochList[indexLast]).month+2;
    // final yearLast = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpochList[indexLast]).year;
    // final dayLast = DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpochList[indexLast]).day;

    if (lessons.isEmpty) {
      final date =
          DateTime.now().millisecondsSinceEpoch + 10519200000; // +4 month
      return DateTime.fromMillisecondsSinceEpoch(date.toInt());
    }

    final monthLast = DateTime.now().month + 2;
    final yearLast = DateTime.now().year;
    final dayLast = DateTime.now().day;
    final lastDay = DateTime.utc(yearLast, monthLast, dayLast);
    if (!_focusedDay.isBefore(lastDay)) {
      return _focusedDay;
    }
    return lastDay;
  }
}

class InfoColor extends StatefulWidget {
  const InfoColor({super.key});

  @override
  State<InfoColor> createState() => _InfoColorState();
}

class _InfoColorState extends State<InfoColor> {
  double _heightBoxInfo = 45.0;
  final double _heightBoxInfoOpened = 340.0;

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
          onTap: () {
            setState(() {
              if (_heightBoxInfo == 45.0) {
                _heightBoxInfo = _heightBoxInfoOpened;
              } else {
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
                        if (_heightBoxInfo == 45.0) {
                          _heightBoxInfo = _heightBoxInfoOpened;
                        } else {
                          _heightBoxInfo = 45.0;
                        }
                      });
                    },
                    icon: Icon(Icons.info_outline,
                        color:
                            Theme.of(context).textTheme.displayMedium!.color!,
                        size: 20.0),
                  ),
                  Container(
                    height: 1.0,
                    width: 20.0,
                    color: Theme.of(context).textTheme.displayMedium!.color!,
                  ),
                ],
              ),
              ...List.generate(StatusToColor.statusColors.length, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 2.0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 30.0,
                        height: 20.0,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(color: colorOrange),
                                  color: StatusToColor.statusColors[index]),
                              width: 30.0,
                              height: 20.0,
                            ),
                            Visibility(
                              visible: index == 8,
                              child: RotationTransition(
                                turns: const AlwaysStoppedAnimation(135 / 360),
                                child: Container(
                                  height:  1.0,
                                  margin: const EdgeInsets.all(3),
                                  color: colorOrange,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const Gap(10.0),
                      Expanded(
                        child: Text(
                          StatusToColor.namesStatus[index],
                          style: TStyle.textStyleVelaSansBold(Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .color!),
                        ),
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




