



import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:virtuozy/domain/entities/lesson_entity.dart';
import 'package:virtuozy/domain/entities/today_lessons.dart';
import 'package:virtuozy/presentations/teacher/today_schedule_screen/time_line_list.dart';

import '../utils/text_style.dart';
import 'dialogs/dialoger.dart';



class DatePageTable extends StatefulWidget{
  const DatePageTable({super.key,required, required this.lessonsToday, required this.initIndex, required this.onChange});

final List<TodayLessons> lessonsToday;
final int initIndex;
final Function onChange;


@override
State<DatePageTable> createState() => _DatePageTableState();
}




class _DatePageTableState extends State<DatePageTable> {


  int page = 0;
  int countLessons = 0;
  late PageController _pageControllerDates;


  @override
  void initState() {
    super.initState();
    _pageControllerDates = PageController(initialPage: widget.initIndex);
    _pageControllerDates.addListener(() {
      widget.onChange.call(_pageControllerDates.page!.toInt());
    });
    page = widget.initIndex;
    countLessons = getCountLessons(lessonsToday: widget.lessonsToday);

  }

  int getCountLessons({required List<TodayLessons> lessonsToday}){
    return lessonsToday.length;
  }

  @override
  Widget build(BuildContext context) {
    return                 Container(
        alignment: Alignment.center,
        width: 220.0,
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
                      if(page > 0){
                        page = _pageControllerDates.page!.toInt()-1;
                      }

                      if (_pageControllerDates.page!.toInt() ==
                          0) {
                        Dialoger.showMessage('Нет записей'.tr(),context: context);
                        return;
                      }
                      _pageControllerDates.animateToPage(page,duration: const Duration(milliseconds: 400), curve: Curves.ease);

                    },
                    icon: Icon(
                      Icons.arrow_back_ios_rounded,
                      size: 16,
                      color: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .color!,
                    ))),
            Flexible(
              flex: 2,
              child: SizedBox(
                height: 18.0,
                child: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _pageControllerDates,
                  children: [
                    ...List.generate(countLessons, (index) {
                      return Text(widget.lessonsToday[index].date.contains('/')?
                          parseDateWeek(widget.lessonsToday[index].date):
                      parseDate(widget.lessonsToday[index].date),
                          textAlign: TextAlign.center,
                          style:TStyle.textStyleVelaSansExtraBolt(Theme.of(context)
                              .textTheme.displayMedium!.color!,size: 13.0));
                    })

                  ],
                ),
              ),
            ),
            Flexible(
                flex: 1,
                child: IconButton(onPressed: (){
                  if(page < countLessons-1){
                    page = _pageControllerDates.page!.toInt()+1;
                  }

                  if (_pageControllerDates.page!.toInt() ==
                      countLessons - 1) {
                    Dialoger.showMessage('Нет записей'.tr(),context: context);
                    return;
                  }

                  _pageControllerDates.animateToPage(page,duration: const Duration(milliseconds: 400), curve: Curves.ease);

                },
                    icon:  Icon(Icons.arrow_forward_ios_rounded,
                      size: 16,
                      color: Theme.of(context)
                          .textTheme.displayMedium!.color!,))),
          ],
        ));
  }


  String parseDateWeek(String date){
    final d1 = DateFormat('yyyy-MM-dd').parse(date.split('/')[0]);
    final d2 = DateFormat('yyyy-MM-dd').parse(date.split('/')[1]);
    if(d1.month == d2.month && d1.year == d2.year){
      final m = getMonth(d1.month);
      return  '${d1.day}-${d2.day} $m ${d1.year}';
    }else if(d1.month!=d2.month&&d1.year==d2.year){
      final m1 = getMonth(d1.month);
      final m2 = getMonth(d2.month);
      return '${d1.day} $m1 - ${d2.day} $m2 ${d1.year}';
    }else{
      final m1 = getMonth(d1.month);
      final m2 = getMonth(d2.month);
      return '${d1.day} $m1 ${d1.year} - ${d2.day} $m2 ${d2.year}';
    }
  }

  String getMonth(int m){
    return switch(m){
      1=> 'янв.',
      2 => 'фев.',
      3=> 'мар.',
      4 => 'апр.',
      5=> 'май',
      6 => 'июнь.',
      7 => 'июль.',
      8 => 'авг.',
      9 => 'сен.',
      10 => 'окт..',
      11 => 'нояб.',
      12 => 'дек.',
      int() => throw UnimplementedError(),
    };
  }



  String parseDate(String date){
    final d = DateFormat('yyyy-MM-dd').parse(date);
    final m = getMonth(d.month);

    return  '${d.day} $m ${d.year}';
  }

}