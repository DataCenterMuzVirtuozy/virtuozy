

  import 'package:time_planner/time_planner.dart';
import 'package:virtuozy/domain/entities/lesson_entity.dart';

class TableTask{

    final TimePlannerDateTime timePlannerDateTime;
    final Lesson lesson;

    TableTask({required this.timePlannerDateTime, required this.lesson});

}