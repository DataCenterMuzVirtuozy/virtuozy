


 import 'package:equatable/equatable.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../domain/entities/lesson_entity.dart';
import '../../../../domain/entities/today_lessons.dart';


 enum TodayScheduleStatus{
   error,
   loaded,
   loading,
   loadingIdsSchool,
   loadedIdsSchool,
   unknown
 }

class TodayScheduleState extends Equatable {

  final String error;
  final TodayScheduleStatus status;
  final List<Lesson> lessons;
  final List<String> idsSchool;
  final String currentIdSchool;
  final List<TodayLessons> todayLessons;


  const TodayScheduleState({required this.error, required this.status,required this.lessons,
    required this.idsSchool,required this.currentIdSchool,
  required this.todayLessons});


  factory TodayScheduleState.unknown(){
    return const TodayScheduleState(error: '', status: TodayScheduleStatus.unknown,lessons: [],idsSchool: ['...'],currentIdSchool: '', todayLessons: []);
  }

  TodayScheduleState copyWith({
    String? error,
    TodayScheduleStatus? status,
    List<Lesson>? lessons,
    List<String>? idsSchool,
    String? currentIdSchool,
    List<TodayLessons>? todayLessons
}){
    return TodayScheduleState(
      todayLessons: todayLessons??this.todayLessons,
      currentIdSchool: currentIdSchool??this.currentIdSchool,
      idsSchool: idsSchool??this.idsSchool,
      lessons: lessons?? this.lessons,
        error: error??this.error,

        status: status??this.status);
 }

  @override
  List<Object?> get props => [error,status,lessons,idsSchool,currentIdSchool,todayLessons];





}