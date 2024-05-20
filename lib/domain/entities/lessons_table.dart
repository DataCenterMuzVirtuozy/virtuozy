
  import 'package:time_planner/time_planner.dart';

import 'lesson_entity.dart';

class LessonsTable{


    final String date;
    final List<Lesson> lessons;
    final List<TimePlannerTask> tasks;

    LessonsTable({required this.lessons,required this.date,required this.tasks});

  }