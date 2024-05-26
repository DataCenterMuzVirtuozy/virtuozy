

 import 'package:equatable/equatable.dart';

class TableEvent extends Equatable{
  @override
  List<Object?> get props => [];
  const TableEvent();
}

class GetInitLessonsEvent extends TableEvent{
  final bool weekMode;
  const GetInitLessonsEvent({required this.weekMode});
}
 class GetLessonsTableByIdSchool extends TableEvent{
   final String id;
   const GetLessonsTableByIdSchool({required this.id});
 }
 class GetLessonsTableByDate extends TableEvent{
  final int indexDate;
  final bool weekMode;
  const GetLessonsTableByDate( {required this.weekMode,required this.indexDate});
 }

 class GetLessonsTableWeek extends TableEvent{
   final bool weekMode;
   const GetLessonsTableWeek({required this.weekMode});
 }


 class GetLessonsTableByCalendarDateEvent extends TableEvent{
  final String date;
  final bool weekMode;
  const GetLessonsTableByCalendarDateEvent({required this.date,required this.weekMode});
 }