


 import 'package:equatable/equatable.dart';
import 'package:fluttertoast/fluttertoast.dart';


 enum TodayScheduleStatus{
   error,
   loaded,
   loading,
   unknown
 }

class TodayScheduleState extends Equatable {

  final String error;
  final TodayScheduleStatus status;


  const TodayScheduleState({required this.error, required this.status});


  factory TodayScheduleState.unknown(){
    return const TodayScheduleState(error: '', status: TodayScheduleStatus.unknown);
  }

  TodayScheduleState copyWith({
    String? error,
    TodayScheduleStatus? status
}){
    return TodayScheduleState(
        error: error??this.error, status: status??this.status);
 }

  @override
  // TODO: implement props
  List<Object?> get props => [error,status];





}