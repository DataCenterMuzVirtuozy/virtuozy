

 import 'package:equatable/equatable.dart';

class TableEvent extends Equatable{
  @override
  List<Object?> get props => [];
  const TableEvent();
}

class GetInitLessonsEvent extends TableEvent{}
 class GetLessonsTableByIdSchool extends TableEvent{
   final String id;
   const GetLessonsTableByIdSchool({required this.id});
 }
 class GetLessonsTableByDate extends TableEvent{
  final int indexDate;
  const GetLessonsTableByDate({required this.indexDate});
 }

 class GetLessonsTableWeek extends TableEvent{

 }