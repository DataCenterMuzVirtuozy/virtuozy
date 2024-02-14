


 import 'package:equatable/equatable.dart';
import 'package:virtuozy/domain/entities/user_entity.dart';

import '../../../domain/entities/schedule_lessons.dart';


enum ScheduleStatus{
 loading,
 loaded,
 error,
 unknown


}

class ScheduleState extends Equatable{

  final ScheduleStatus status;
  final String error;
  final UserEntity user;
  final ScheduleLessons scheduleLessons;
  final List<ScheduleLessons> schedulesList;


  factory ScheduleState.unknown(){
  return ScheduleState(
    schedulesList: const [],
        status: ScheduleStatus.loading,
        error: '',
        user: UserEntity.unknown(),
        scheduleLessons: ScheduleLessons.unknown());
  }



  @override
  List<Object?> get props =>[status,error,user];

  const ScheduleState({
    required this.schedulesList,
    required this.scheduleLessons,
    required this.status,
    required this.error,
    required this.user,
  });

  ScheduleState copyWith({
    ScheduleStatus? status,
    String? error,
    UserEntity? user,
    ScheduleLessons? scheduleLessons,
    List<ScheduleLessons>? schedulesList
  }) {
    return ScheduleState(
      schedulesList: schedulesList??this.schedulesList,
      status: status ?? this.status,
      error: error ?? this.error,
      user: user ?? this.user,
      scheduleLessons: scheduleLessons??this.scheduleLessons,
    );
  }
}