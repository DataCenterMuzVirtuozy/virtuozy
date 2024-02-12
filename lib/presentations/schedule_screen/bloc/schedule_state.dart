


 import 'package:equatable/equatable.dart';
import 'package:virtuozy/domain/entities/user_entity.dart';


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


 factory ScheduleState.unknown(){
  return ScheduleState(status: ScheduleStatus.unknown, error: '', user: UserEntity.unknown());
 }



  @override
  List<Object?> get props =>[status,error,user];

  const ScheduleState({
    required this.status,
    required this.error,
    required this.user,
  });

  ScheduleState copyWith({
    ScheduleStatus? status,
    String? error,
    UserEntity? user,
  }) {
    return ScheduleState(
      status: status ?? this.status,
      error: error ?? this.error,
      user: user ?? this.user,
    );
  }
}