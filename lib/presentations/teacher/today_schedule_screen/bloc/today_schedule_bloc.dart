


 import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtuozy/di/locator.dart';
import 'package:virtuozy/domain/teacher_cubit.dart';
import 'package:virtuozy/presentations/teacher/today_schedule_screen/bloc/today_schedule_event.dart';
import 'package:virtuozy/presentations/teacher/today_schedule_screen/bloc/today_schedule_state.dart';
import 'package:virtuozy/utils/failure.dart';

import '../../../../domain/entities/lesson_entity.dart';
import '../../../../domain/entities/today_lessons.dart';

class TodayScheduleBloc extends Bloc<TodayScheduleEvent,TodayScheduleState>{
  TodayScheduleBloc(): super(TodayScheduleState.unknown()){
     on<GetIdsSchoolEvent>(getIdsSchool);
     on<GetLessonsByIdSchoolEvent>(getLessonsByIdSchool);
  }

  final _cubitTeacher = locator.get<TeacherCubit>();


  void getIdsSchool(GetIdsSchoolEvent event, emit) async {
    try{
      emit(state.copyWith(status: TodayScheduleStatus.loadingIdsSchool,error: ''));
      await Future.delayed(const Duration(seconds: 1));
      final lessons = _cubitTeacher.teacherEntity.lessons;
      final ids = getIds(lessons);
      final lessonsById = getLessonsByIdsSchool(ids[0], lessons);
      final todayLessons = getTodayLessons(lessonsById);
      emit(state.copyWith(status: TodayScheduleStatus.loadedIdsSchool,idsSchool: ids, todayLessons: todayLessons));
    }on Failure catch(e){
      emit(state.copyWith(status: TodayScheduleStatus.error,error: e.message));
    }

  }

  List<TodayLessons> getTodayLessons(List<Lesson> lessons){
    List<TodayLessons> less = [];
    lessons.sort((a, b) => DateFormat('yyyy-MM-dd').parse(a.date).millisecondsSinceEpoch.compareTo(
       DateFormat('yyyy-MM-dd').parse(b.date).millisecondsSinceEpoch
   ));

    // for(var l in lessons){
    //    if(!less.map((e) => e.date).toList().contains(l.date)){
    //      less.add(TodayLessons(date: date, lessons: lessons))
    //    }
    // }

    return less;
  }

  void getLessonsByIdSchool(GetLessonsByIdSchoolEvent event,emit) async {
    try{
      final lessons = _cubitTeacher.teacherEntity.lessons;
      final ids = getIds(lessons);
      emit(state.copyWith(status: TodayScheduleStatus.loadedIdsSchool,idsSchool: ids));
    }on Failure catch(e){
      emit(state.copyWith(status: TodayScheduleStatus.error,error: e.message));
    }
  }

  List<Lesson> getLessonsByIdsSchool(String idSchool,List<Lesson> lessons){
    return lessons.where((element) => element.idSchool == idSchool).toList();
  }


  List<String> getIds(List<Lesson> lessons){
    List<String> ids = [];
    for(var l in lessons){
      if(!ids.contains(l.idSchool)){
        ids.add(l.idSchool);
      }
    }


    return ids;

  }




}