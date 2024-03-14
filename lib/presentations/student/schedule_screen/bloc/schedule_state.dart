


 import 'package:equatable/equatable.dart';
import 'package:virtuozy/domain/entities/user_entity.dart';

import '../../../../domain/entities/schedule_lessons.dart';




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
  final int schedulesLength;
  final List<Lesson> lessons;
  final List<ScheduleLessons> schedulesList;


  factory ScheduleState.unknown(){
  return ScheduleState(
    lessons: const [],
      schedulesLength:0,
    schedulesList: const [],
        status: ScheduleStatus.loading,
        error: '',
        user: UserEntity.unknown());
  }



  @override
  List<Object?> get props =>[status,error,user,schedulesList,schedulesLength,lessons];

  const ScheduleState({
    required this.lessons,
    required this.schedulesLength,
    required this.schedulesList,
    required this.status,
    required this.error,
    required this.user,
  });

  ScheduleState copyWith({
    ScheduleStatus? status,
    String? error,
    UserEntity? user,
    ScheduleLessons? scheduleLessons,
    List<ScheduleLessons>? schedulesList,
    int? schedulesLength,
    List<Lesson>? lessons
  }) {
    return ScheduleState(
      lessons: lessons??this.lessons,
      schedulesLength:schedulesLength??this.schedulesLength,
      schedulesList: schedulesList??this.schedulesList,
      status: status ?? this.status,
      error: error ?? this.error,
      user: user ?? this.user,
    );
  }
}