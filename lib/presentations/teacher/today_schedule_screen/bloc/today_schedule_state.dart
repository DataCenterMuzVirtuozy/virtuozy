


 import 'package:equatable/equatable.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../domain/entities/lesson_entity.dart';
import '../../../../domain/entities/today_lessons.dart';


 enum TodayScheduleStatus{
   error,
   loaded,
   loading,
   unknown
 }


 enum EditScheduleStatus{
   error,
   loaded,
   loading,
   unknown
 }

 enum AddScheduleStatus{
   error,
   loaded,
   loading,
   unknown
 }

class TodayScheduleState extends Equatable {

  final String error;
  final TodayScheduleStatus status;
  final EditScheduleStatus editScheduleStatus;
  final AddScheduleStatus addScheduleStatus;
  final List<Lesson> lessons;
  final List<String> idsSchool;
  final String currentIdSchool;
  final List<TodayLessons> todayLessons;
  final int indexByDateNow;
  final bool visibleTodayButton;


  const TodayScheduleState({required this.error, required this.status,required this.lessons,
    required this.idsSchool,required this.currentIdSchool,
  required this.todayLessons,
    required this.addScheduleStatus,
    required this.editScheduleStatus,
    required  this.visibleTodayButton,
  required this.indexByDateNow});


  factory TodayScheduleState.unknown(){
    return const TodayScheduleState(
      visibleTodayButton: false,
        addScheduleStatus: AddScheduleStatus.unknown,
        editScheduleStatus: EditScheduleStatus.unknown,
        error: '', status: TodayScheduleStatus.unknown,lessons: [],idsSchool: ['...'],currentIdSchool: '...', todayLessons: [], indexByDateNow: 0);
  }

  TodayScheduleState copyWith({
    String? error,
    TodayScheduleStatus? status,
    List<Lesson>? lessons,
    List<String>? idsSchool,
    String? currentIdSchool,
    List<TodayLessons>? todayLessons,
    int? indexByDateNow,
    bool? visibleTodayButton,
    EditScheduleStatus? editScheduleStatus,
    AddScheduleStatus? addScheduleStatus
}){
    return TodayScheduleState(
      addScheduleStatus: addScheduleStatus??this.addScheduleStatus,
        editScheduleStatus: editScheduleStatus??this.editScheduleStatus,
        visibleTodayButton: visibleTodayButton??this.visibleTodayButton,
      indexByDateNow: indexByDateNow??this.indexByDateNow,
      todayLessons: todayLessons??this.todayLessons,
      currentIdSchool: currentIdSchool??this.currentIdSchool,
      idsSchool: idsSchool??this.idsSchool,
      lessons: lessons?? this.lessons,
        error: error??this.error,

        status: status??this.status);
 }

  @override
  List<Object?> get props => [error,status,lessons,idsSchool,currentIdSchool,todayLessons,visibleTodayButton,editScheduleStatus,addScheduleStatus];





}