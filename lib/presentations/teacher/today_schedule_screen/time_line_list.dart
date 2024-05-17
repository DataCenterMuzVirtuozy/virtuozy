


  import 'package:flutter/cupertino.dart';
import 'package:virtuozy/presentations/teacher/today_schedule_screen/timeline_schedule.dart';

import '../../../domain/entities/today_lessons.dart';

  late PageController pageControllerTimeList;

class TimeLineList extends StatefulWidget{
  const TimeLineList({super.key, required this.todayLessons, required this.initIndex});

  final List<TodayLessons>  todayLessons;
  final int initIndex;

  @override
  State<TimeLineList> createState() => _TimeLineListState();
}

class _TimeLineListState extends State<TimeLineList> {




  @override
  void initState() {
    super.initState();
    pageControllerTimeList = PageController(initialPage: widget.initIndex);

  }


  @override
  Widget build(BuildContext context) {
    return   Expanded(child: PageView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.todayLessons.length,
      controller: pageControllerTimeList,
      itemBuilder: (BuildContext context, int index) {
        return TimelineSchedule(
          todayLessons: widget.todayLessons[index],
        );
      },
    ));
  }
}