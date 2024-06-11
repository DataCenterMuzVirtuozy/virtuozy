import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtuozy/domain/entities/today_lessons.dart';
import 'package:virtuozy/presentations/teacher/schedule_table_screen/bloc/table_bloc.dart';
import 'package:virtuozy/presentations/teacher/schedule_table_screen/bloc/table_state.dart';
import 'package:virtuozy/presentations/teacher/schedule_table_screen/schedule_table_page.dart';

import '../domain/entities/lesson_entity.dart';
import '../utils/date_time_parser.dart';
import '../utils/text_style.dart';
import 'dialogs/dialoger.dart';

late PageController pageControllerDates;

class DatePageTable extends StatefulWidget {
  const DatePageTable(
      {super.key,
      required,
      required this.lessonsToday,
      required this.initIndex,
      required this.onChange,
      required this.lessons,
      required this.dateSelect,});

  final List<TodayLessons> lessonsToday;
  final int initIndex;
  final Function onChange;
  final List<Lesson> lessons;
  final Function dateSelect;


  @override
  State<DatePageTable> createState() => _DatePageTableState();
}

class _DatePageTableState extends State<DatePageTable> {
  int page = 0;


  @override
  void initState() {
    super.initState();

  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
     final indexDate = context.watch<TableBloc>().state.indexByDateNow;
     print('Index Pae $indexDate');
    if (indexDate < 0) {
      page = indexDate;
      pageControllerDates = PageController();
    } else {
      pageControllerDates = PageController(initialPage: indexDate);
      page = indexDate;
    }


    // pageControllerDates.addListener(() {
    //   widget.onChange.call(pageControllerDates.page!.toInt());
    // });
  }

  @override
  Widget build(BuildContext context) {



    return Container(
        alignment: Alignment.center,
        width: 230.0,
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
                        page = pageControllerDates.page!.toInt() - 1;
                      }

                      if (pageControllerDates.page!.toInt() == 0) {
                        Dialoger.showMessage('Нет записей'.tr(),
                            context: context);
                        return;
                      }
                      pageControllerDates.animateToPage(page,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.ease);
                      widget.onChange.call(page);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_rounded,
                      size: 16,
                      color: Theme.of(context).textTheme.displayMedium!.color!,
                    ))),
            Flexible(
              flex: 2,
              child: SizedBox(
                height: 17.0,
                child: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: pageControllerDates,
                  children: [
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
                        child: Text(
                            widget.lessonsToday[index].date.contains('/')
                                ? parseDateWeek(widget.lessonsToday[index].date)
                                : parseDate(widget.lessonsToday[index].date),
                            textAlign: TextAlign.center,
                            style: TStyle.textStyleVelaSansExtraBolt(
                                Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .color!,
                                size: 12.0)),
                      );
                    })

                  ],
                ),
              ),
            ),
            Flexible(
                flex: 1,
                child: IconButton(
                    onPressed: () {
                      if (page < widget.lessonsToday.length - 1) {
                        page = pageControllerDates.page!.toInt() + 1;
                      }

                      if (pageControllerDates.page!.toInt() ==
                          widget.lessonsToday.length - 1) {
                        Dialoger.showMessage('Нет записей'.tr(),
                            context: context);
                        return;
                      }

                      pageControllerDates.animateToPage(page,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.ease);
                      widget.onChange.call(page);
                    },
                    icon: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16,
                      color: Theme.of(context).textTheme.displayMedium!.color!,
                    ))),
          ],
        ));
  }

  String parseDateWeek(String date) {
    final d1 = DateFormat('yyyy-MM-dd').parse(date.split('/')[0]);
    final d2 = DateFormat('yyyy-MM-dd').parse(date.split('/')[1]);
    if (d1.month == d2.month && d1.year == d2.year) {
      final m = getMonth(d1.month);
      return '${d1.day}-${d2.day} $m ${d1.year}';
    } else if (d1.month != d2.month && d1.year == d2.year) {
      final m1 = getMonth(d1.month);
      final m2 = getMonth(d2.month);
      return '${d1.day} $m1 - ${d2.day} $m2 ${d1.year}';
    } else {
      final m1 = getMonth(d1.month);
      final m2 = getMonth(d2.month);
      return '${d1.day} $m1 ${d1.year} - ${d2.day} $m2 ${d2.year}';
    }
  }

  String getMonth(int m) {
    return switch (m) {
      1 => 'янв.',
      2 => 'фев.',
      3 => 'мар.',
      4 => 'апр.',
      5 => 'май',
      6 => 'июн.',
      7 => 'июл.',
      8 => 'авг.',
      9 => 'сен.',
      10 => 'окт..',
      11 => 'ноя.',
      12 => 'дек.',
      int() => throw UnimplementedError(),
    };
  }

  String parseDate(String date) {
    final d = DateFormat('yyyy-MM-dd').parse(date);
    final m = getMonth(d.month);
    final nameDay = DateTimeParser.getDayByNumber(d.weekday);
    return '$nameDay,  ${d.day} $m ${d.year}';
  }
}
