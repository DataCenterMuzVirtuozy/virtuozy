

 import 'package:equatable/equatable.dart';

import '../../../domain/entities/user_entity.dart';

class ScheduleEvent extends Equatable{


  @override
  List<Object?> get props => [];

  const ScheduleEvent();
}

class GetScheduleEvent extends ScheduleEvent{}
 class UpdateUserEvent extends ScheduleEvent{
   final int currentDirIndex;
   final UserEntity user;

   const UpdateUserEvent({
     required this.currentDirIndex,
     required this.user,
   });
 }