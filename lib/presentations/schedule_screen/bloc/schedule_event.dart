

 import 'package:equatable/equatable.dart';
import 'package:virtuozy/domain/entities/schedule_lessons.dart';

import '../../../domain/entities/user_entity.dart';

class ScheduleEvent extends Equatable{


  @override
  List<Object?> get props => [];

  const ScheduleEvent();
}

class GetScheduleEvent extends ScheduleEvent{
  final int currentDirIndex;
  final int month;

  const GetScheduleEvent({required this.currentDirIndex,required this.month});
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