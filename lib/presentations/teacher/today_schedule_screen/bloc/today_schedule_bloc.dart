


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
     on<GetTodayLessonsEvent>(getTodayLessons);
     on<GetLessonsByIdSchoolEvent>(getLessonsByIdSchool);
  }

  final _cubitTeacher = locator.get<TeacherCubit>();


  void getTodayLessons(GetTodayLessonsEvent event, emit) async {
    try{
      emit(state.copyWith(status: TodayScheduleStatus.loadingIdsSchool,error: ''));
      await Future.delayed(const Duration(seconds: 1));
      final lessons = _cubitTeacher.teacherEntity.lessons;
      final ids = getIds(lessons);
      final lessonsById = getLessonsByIdsSchool(ids[0], lessons);
      final todayLessons = getDays(lessonsById);
      final index = indexByDateNow(todayLessons);
      emit(state.copyWith(
        indexByDateNow: index,
          status: TodayScheduleStatus.loadedIdsSchool,idsSchool: ids, todayLessons: todayLessons));
    }on Failure catch(e){
      emit(state.copyWith(status: TodayScheduleStatus.error,error: e.message));
    }

  }

  int indexByDateNow(List<TodayLessons> todayLessons){
    final dateNow = DateTime.now().toString().split(' ')[0];
    final dateNowEpoch = DateTime.now().millisecondsSinceEpoch;
    int index = 0;
    final i = todayLessons.indexWhere((element) => element.date == dateNow);
    if(i<0){
     final i1 = todayLessons.indexWhere((element) =>
      DateFormat('yyyy-MM-dd').parse(element.date).millisecondsSinceEpoch>dateNowEpoch);
     if(i1<0){
       index = todayLessons.length - 1;
     }else{
       index = i1;
     }
    }else{
      index = i;
    }
    return index;
  }

  List<TodayLessons> getDays(List<Lesson> lessons){
    List<TodayLessons> less = [];
    List<String> dates = [];
    lessons.sort((a, b) => DateFormat('yyyy-MM-dd').parse(a.date).millisecondsSinceEpoch.compareTo(
       DateFormat('yyyy-MM-dd').parse(b.date).millisecondsSinceEpoch
   ));

    for(var l in lessons){
       if(!dates.contains(l.date)){
           dates.add(l.date);
       }
    }

    for(var d in dates){
      less.add(TodayLessons(
          date: d,
          lessons: lessons.where((element) => element.date == d).toList()));
    }

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