

  import 'package:equatable/equatable.dart';
import 'package:time_planner/time_planner.dart';

import '../../../domain/entities/lesson_entity.dart';
import '../../../domain/entities/table_task.dart';
import '../../../domain/entities/titles_table.dart';
import '../../../domain/entities/today_lessons.dart';

enum TableStatus{
  loading,
  loaded,
  error,
  unknown
}

enum ScheduleStatus{
  loading,
  loaded,
  error,
  unknown
}

enum ViewModeTable{
  day,
  week,
  my,
  unknown
}

class TableState extends Equatable{

  final String error;
  final TableStatus status;
  final ScheduleStatus scheduleStatus;
  final ViewModeTable modeTable;
  final List<String> idsAuditory;
  final List<Lesson> lessons;
  final List<String> idsSchool;
  final String currentIdSchool;
  final List<TodayLessons> todayLessons;
  final List<TableTask> tasks;
  final List<TitlesTable> titles;
  final int indexByDateNow;
  final bool visibleTodayButton;



  const TableState(
      {required this.error,
      required this.status,
      required this.lessons,
      required this.idsSchool,
      required this.currentIdSchool,
      required this.todayLessons,
      required this.indexByDateNow,
      required this.visibleTodayButton,
      required this.idsAuditory,
        required this.tasks,
        required this.titles,
        required this.scheduleStatus,
      required this.modeTable});

  factory TableState.unknown(){
    return const TableState(error: '',
        status: TableStatus.unknown,
        lessons: [],
        idsSchool: [],
        scheduleStatus: ScheduleStatus.unknown,
        currentIdSchool: '',
        todayLessons: [],
        indexByDateNow: 0,
        tasks: [],
        titles: [],
        modeTable: ViewModeTable.unknown,
        idsAuditory: [],
        visibleTodayButton: false);
  }

  TableState copyWith({
     String? error,
     TableStatus? status,
     List<Lesson>? lessons,
     List<String>? idsSchool,
     String? currentIdSchool,
     List<TodayLessons>? todayLessons,
     int? indexByDateNow,
     bool? visibleTodayButton,
     ViewModeTable? modeTable,
    List<String>? idsAuditory,
    List<TableTask>? tasks,
    List<TitlesTable>? titles,
    ScheduleStatus? scheduleStatus
}){
    return TableState(error: error??this.error,
        status: status??this.status,
        titles: titles??this.titles,
        tasks: tasks??this.tasks,
        lessons: lessons??this.lessons,
        idsSchool: idsSchool??this.idsSchool,
        currentIdSchool: currentIdSchool??this.currentIdSchool,
        todayLessons: todayLessons??this.todayLessons,
        indexByDateNow: indexByDateNow??this.indexByDateNow,
        modeTable: modeTable??this.modeTable,
        idsAuditory: idsAuditory??this.idsAuditory,
        scheduleStatus: scheduleStatus??this.scheduleStatus,
        visibleTodayButton: visibleTodayButton??this.visibleTodayButton);
  }

  @override
  List<Object?> get props => [error,status,lessons,idsSchool,currentIdSchool,todayLessons,indexByDateNow,visibleTodayButton,idsAuditory,modeTable,titles,scheduleStatus];

}