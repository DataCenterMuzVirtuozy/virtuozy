

 import 'package:equatable/equatable.dart';
import 'package:virtuozy/presentations/teacher/schedule_table_screen/bloc/table_state.dart';

class TableEvent extends Equatable{
  @override
  List<Object?> get props => [];
  const TableEvent();
}

class GetInitLessonsEvent extends TableEvent{
  final ViewModeTable viewMode;
  const GetInitLessonsEvent({required this.viewMode});
}
 class GetLessonsTableByIdSchool extends TableEvent{
   final String id;
   const GetLessonsTableByIdSchool({required this.id});
 }
 class GetLessonsTableByDate extends TableEvent{
  final int indexDate;
  final ViewModeTable viewMode;
  const GetLessonsTableByDate( {required this.viewMode,required this.indexDate});
 }

 class GetLessonsTableWeek extends TableEvent{
   final ViewModeTable viewMode;
   const GetLessonsTableWeek({required this.viewMode});
 }


 class GetMyLessonEvent extends TableEvent{
   final int indexDate;
   final bool weekMode;
   const GetMyLessonEvent({required this.indexDate, required this.weekMode});
 }


 class GetLessonsTableByCalendarDateEvent extends TableEvent{
  final String date;
  final ViewModeTable viewMode;
  const GetLessonsTableByCalendarDateEvent({required this.date,required this.viewMode});
 }