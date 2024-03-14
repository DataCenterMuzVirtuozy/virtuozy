

 import 'package:equatable/equatable.dart';
import 'package:virtuozy/domain/entities/schedule_lessons.dart';

import '../../../../domain/entities/user_entity.dart';



class ScheduleEvent extends Equatable{


  @override
  List<Object?> get props => [];

  const ScheduleEvent();
}

class GetScheduleEvent extends ScheduleEvent{
  final int currentDirIndex;
  final int month;
  final bool refreshDirection;
  final bool refreshMonth;
  final bool allViewDir;

  const GetScheduleEvent({
    required this.refreshMonth,
    required this.allViewDir,
    required this.refreshDirection,
    required this.currentDirIndex,
    required this.month});
}


 class GetDetailsScheduleEvent extends ScheduleEvent{
   final int currentDirIndex;
   final bool allViewDir;
   final bool refreshDirection;

   const GetDetailsScheduleEvent({
     required this.allViewDir,
     required this.refreshDirection,
     required this.currentDirIndex});
 }
 class UpdateUserEvent extends ScheduleEvent{
   final int currentDirIndex;
   final UserEntity user;
   final ScheduleLessons scheduleLessons;

   const UpdateUserEvent({
     required this.currentDirIndex,
     required  this.scheduleLessons,
     required this.user,
   });
 }