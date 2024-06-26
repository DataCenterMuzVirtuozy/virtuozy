import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtuozy/domain/entities/lesson_entity.dart';
import 'package:virtuozy/domain/entities/today_lessons.dart';
import 'package:virtuozy/presentations/teacher/today_schedule_screen/bloc/today_schedule_bloc.dart';
import 'package:virtuozy/presentations/teacher/today_schedule_screen/time_line_list.dart';
import 'package:virtuozy/utils/date_time_parser.dart';

import '../presentations/teacher/today_schedule_screen/bloc/today_schedule_state.dart';
import '../utils/text_style.dart';
import 'dialogs/dialoger.dart';

late PageController pageControllerDatesSchedule;

class DatePageView extends StatefulWidget {
  const DatePageView(
      {super.key,
      required,
      required this.lessonsToday,
      required this.initIndex,
      required this.onVisibleTodayButton,
      this.weekMode = false,
      required this.loading,
  required this.lessons,
  required this.dateSelect});

  final List<TodayLessons> lessonsToday;
  final int initIndex;
final List<Lesson> lessons;
final Function dateSelect;
  final Function onVisibleTodayButton;
  final bool weekMode;
  final bool loading;

  @override
  State<DatePageView> createState() => _DatePageViewState();
}

class _DatePageViewState extends State<DatePageView> {
  int page = 0;
  int countLessons = 0;

  @override
  void initState() {
    super.initState();

  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final indexDate = context.watch<TodayScheduleBloc>().state.indexByDateNow;
    pageControllerDatesSchedule = PageController(initialPage: indexDate);
    final dateNow = DateTime.now().toString().split(' ')[0];
    pageControllerDatesSchedule.addListener(() {
      if (widget.lessonsToday[pageControllerDatesSchedule.page!.toInt()].date ==
          dateNow) {
        widget.onVisibleTodayButton.call(false);
      } else {
        widget.onVisibleTodayButton.call(true);
      }
    });
    page = indexDate;
    countLessons = getCountLessons(
        lessonsToday: widget.lessonsToday, weekMode: widget.weekMode);

  }

  int getCountLessons(
      {required List<TodayLessons> lessonsToday, required bool weekMode}) {
    return lessonsToday.length;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        width: 280.0,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(20.0)),
        child: Flex(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          direction: Axis.horizontal,
          children: [
            Flexible(
                flex: 1,
                child: IconButton(
                    onPressed: () {
                      if (page > 0) {
                        page = pageControllerDatesSchedule.page!.toInt() - 1;
                      }

                      if (pageControllerDatesSchedule.page!.toInt() == 0) {
                        Dialoger.showMessage('Нет записей'.tr(),
                            context: context);
                        return;
                      }
                      pageControllerDatesSchedule.animateToPage(page,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.ease);
                      pageControllerTimeList.animateToPage(page,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.ease);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_rounded,
                      size: 16,
                      color: Theme.of(context).textTheme.displayMedium!.color!,
                    ))),
            Flexible(
              flex: 2,
              child: SizedBox(
                height: 20.0,
                child: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: pageControllerDatesSchedule,
                  children: [
                    if (widget.loading) ...{
                      Text('...',
                          textAlign: TextAlign.center,
                          style: TStyle.textStyleVelaSansExtraBolt(
                              Theme.of(context).textTheme.displayMedium!.color!,
                              size: 13.0))
                    } else ...{
                      ...List.generate(widget.lessonsToday.length, (index) {
                        return InkWell(
                          onTap: (){
                            Dialoger.showSelectDate(
                                context: context,
                                lessons: widget.lessons,
                                onDate: (String date) {
                                  widget.dateSelect.call(date);
                                });
                          },
                          child: Text(parseDate(widget.lessonsToday[index].date),
                              textAlign: TextAlign.center,
                              style: TStyle.textStyleVelaSansExtraBolt(
                                  Theme.of(context)
                                      .textTheme
                                      .displayMedium!
                                      .color!,
                                  size: 13.0)),
                        );
                      })
                    }
                  ],
                ),
              ),
            ),
            Flexible(
                flex: 1,
                child: IconButton(
                    onPressed: () {
                      if (page < countLessons - 1) {
                        page = pageControllerDatesSchedule.page!.toInt() + 1;
                      }

                      if (pageControllerDatesSchedule.page!.toInt() ==
                          countLessons - 1) {
                        Dialoger.showMessage('Нет записей'.tr(),
                            context: context);
                        return;
                      }

                      pageControllerDatesSchedule.animateToPage(page,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.ease);
                      pageControllerTimeList.animateToPage(page,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.ease);
                    },
                    icon: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16,
                      color: Theme.of(context).textTheme.displayMedium!.color!,
                    ))),
          ],
        ));
  }

  String parseDate(String date) {
    final d = DateFormat('yyyy-MM-dd').parse(date);
    final m = switch (d.month) {
      1 => 'янв.',
      2 => 'февр.',
      3 => 'март',
      4 => 'апрель',
      5 => 'май',
      6 => 'июнь',
      7 => 'июль',
      8 => 'авг.',
      9 => 'сент.',
      10 => 'октяб.',
      11 => 'ноябрь',
      12 => 'дек.',
      int() => throw UnimplementedError(),
    };

    final nameDay = DateTimeParser.getDayByNumber(d.weekday);
    return '$nameDay,  ${d.day} $m ${d.year}';
  }
}
