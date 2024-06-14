


 import 'dart:math';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtuozy/components/date_page_view.dart';
import 'package:virtuozy/di/locator.dart';
import 'package:virtuozy/domain/teacher_cubit.dart';
import 'package:virtuozy/presentations/teacher/today_schedule_screen/bloc/today_schedule_event.dart';
import 'package:virtuozy/presentations/teacher/today_schedule_screen/bloc/today_schedule_state.dart';
import 'package:virtuozy/utils/failure.dart';

import '../../../../domain/entities/lesson_entity.dart';
import '../../../../domain/entities/today_lessons.dart';
import '../../../../domain/repository/teacher_repository.dart';

class TodayScheduleBloc extends Bloc<TodayScheduleEvent,TodayScheduleState> {
  TodayScheduleBloc() : super(TodayScheduleState.unknown()) {
    on<GetTodayLessonsEvent>(getTodayLessons, transformer: droppable());
    on<GetLessonsByIdSchoolEvent>(
        getLessonsByIdSchool, transformer: droppable());
    on<GetLessonsBySelDateEvent>(
        _getLessonsBySelDate, transformer: droppable());
    on<GetLessonsByModeViewEvent>(
        _getLessonsByModeView, transformer: droppable());
    on<AddLessonFromScheduleEvent>(addNewLesson, transformer: droppable());
    on<EditLessonFromScheduleEvent>(editLesson,transformer: droppable());
  }

  final _cubitTeacher = locator.get<TeacherCubit>();
  final _teacherRepository = locator.get<TeacherRepository>();
  bool onlyWithLesson = false;


  void addNewLesson(AddLessonFromScheduleEvent event, emit) async {
    try {
      emit(state.copyWith(
        status: TodayScheduleStatus.loading, error: '', idsSchool: ['...'],));
      await _teacherRepository.addLesson(lesson: event.lesson);
      final phoneTeacher = _cubitTeacher.teacherEntity.phoneNum;
      final teacher = await _teacherRepository.getTeacher(uid: phoneTeacher);
      _cubitTeacher.setTeacher(teacher: teacher);
      final lessons = _cubitTeacher.teacherEntity.lessons.where((
          element) => element.idTeacher == teacher.id).toList();
      if (lessons.isEmpty) {
        emit(state.copyWith(
            indexByDateNow: 0,
            visibleTodayButton: false,
            lessons: [],
            currentIdSchool: '...',
            status: TodayScheduleStatus.loaded,
            idsSchool: ['...'],
            todayLessons: []));
        return;
      }

      final ids = getIds(lessons);
      final idSchool = ids.isEmpty ? '...' : ids[0];
      final lessonsById = getLessons(
          idSchool, lessons);
      final todayLessons = getDays(lessonsById, onlyWithLesson);
      final index = indexByDateNow(todayLessons, event.lesson.date);
      pageControllerDatesSchedule.jumpToPage(index.$1);
      emit(state.copyWith(
          indexByDateNow: index.$1,
          visibleTodayButton: index.$2,
          lessons: lessonsById,
          currentIdSchool: idSchool.isEmpty ? '...' : idSchool,
          status: TodayScheduleStatus.loaded,
          idsSchool: ids,
          todayLessons: todayLessons));
    } on Failure catch (e) {
      emit(state.copyWith(status: TodayScheduleStatus.error, error: e.message));
    }
  }

  void editLesson(EditLessonFromScheduleEvent event, emit) async {
   try{ emit(state.copyWith(
      status: TodayScheduleStatus.loading, error: '', idsSchool: ['...'],));
    await _teacherRepository.editLesson(lesson: event.lesson);
    final phoneTeacher = _cubitTeacher.teacherEntity.phoneNum;
    final teacher = await _teacherRepository.getTeacher(uid: phoneTeacher);
    _cubitTeacher.setTeacher(teacher: teacher);
    final lessons = _cubitTeacher.teacherEntity.lessons.where((
        element) => element.idTeacher == teacher.id).toList();
    if (lessons.isEmpty) {
      emit(state.copyWith(
          indexByDateNow: 0,
          visibleTodayButton: false,
          lessons: [],
          currentIdSchool: '...',
          status: TodayScheduleStatus.loaded,
          idsSchool: ['...'],
          todayLessons: []));
      return;
    }

    final ids = getIds(lessons);
    final idSchool = ids.isEmpty ? '...' : ids[0];
    final lessonsById = getLessons(
        idSchool, lessons);
    final todayLessons = getDays(lessonsById, onlyWithLesson);
    final index = indexByDateNow(todayLessons, event.lesson.date);
    pageControllerDatesSchedule.jumpToPage(index.$1);
    emit(state.copyWith(
        indexByDateNow: index.$1,
        visibleTodayButton: index.$2,
        lessons: lessonsById,
        currentIdSchool: idSchool.isEmpty ? '...' : idSchool,
        status: TodayScheduleStatus.loaded,
        idsSchool: ids,
        todayLessons: todayLessons));
  }

  on Failure

  catch

  (

  e) {
  emit(state.copyWith(status: TodayScheduleStatus.error, error: e.message));
  }
}




  void getTodayLessons(GetTodayLessonsEvent event, emit) async {
    try {
      emit(state.copyWith(
          status: TodayScheduleStatus.loading, error: '',idsSchool: ['...'],));
      final idTeacher = _cubitTeacher.teacherEntity.id;
      final lessons = _cubitTeacher.teacherEntity.lessons.where((element) => element.idTeacher == idTeacher).toList();
      await Future.delayed(const Duration(milliseconds: 300));
      if(lessons.isEmpty){
        emit(state.copyWith(
            indexByDateNow: 0,
            visibleTodayButton: false,
            lessons: [],
            currentIdSchool: '...',
            status: TodayScheduleStatus.loaded,
            idsSchool: ['...'],
            todayLessons: []));
        return;
      }

      final ids = getIds(lessons);
      final idSchool = ids.isEmpty ? '...' : ids[0];
      final lessonsById = getLessons(
          idSchool, lessons);
      final todayLessons = getDays(lessonsById, onlyWithLesson);
      final index = indexByDateNow(todayLessons);
      pageControllerDatesSchedule.jumpToPage(index.$1);
      emit(state.copyWith(
          indexByDateNow: index.$1,
          visibleTodayButton: index.$2,
          lessons: lessonsById,
          currentIdSchool: idSchool.isEmpty?'...':idSchool,
          status: TodayScheduleStatus.loaded,
          idsSchool: ids,
          todayLessons: todayLessons));
    } on Failure catch (e) {
      emit(state.copyWith(status: TodayScheduleStatus.error, error: e.message));
    }
  }

  (int,bool) indexByDateNow(List<TodayLessons> todayLessons,[String dateAdded = '']) {
    final dateNow = DateTime.now().toString().split(' ')[0];
    int i = 0;
    final dateNowEpoch = DateTime
        .now()
        .millisecondsSinceEpoch;
    int index = 0;
    bool visibleButtonToday = false;
    if(dateAdded.isNotEmpty){
      i = todayLessons.indexWhere((element) => element.date == dateAdded);
    }else{
    i = todayLessons.indexWhere((element) => element.date == dateNow);
    }

    if (i < 0) {
      visibleButtonToday = true;
      final i1 = todayLessons.indexWhere((element) =>
      DateFormat('yyyy-MM-dd')
          .parse(element.date)
          .millisecondsSinceEpoch > dateNowEpoch);
      if (i1 < 0) {
        index = todayLessons.length - 1;
      } else {
        index = i1;
      }
    } else {
      index = i;
    }
    return (index,visibleButtonToday);
  }




  (int,bool) indexByDateSelect(List<TodayLessons> todayLessons,String dateSelect) {
    int index = 0;
    bool visibleButtonToday = false;
    final now = DateTime.now().toString().split(' ')[0];
    if(now != dateSelect){
      visibleButtonToday = true;
    }
    index = todayLessons.indexWhere((element){
      return  element.date == dateSelect;
    });

    return (index,visibleButtonToday);
  }

  List<TodayLessons> getDays(List<Lesson> lessons, bool daysOnlyLesson) {
    List<TodayLessons> less = [];
    List<String> dates = [];
    lessons.sort((a, b) =>
        DateFormat('yyyy-MM-dd')
            .parse(a.date)
            .millisecondsSinceEpoch
            .compareTo(
            DateFormat('yyyy-MM-dd')
                .parse(b.date)
                .millisecondsSinceEpoch
        ));
    if (daysOnlyLesson) {
      for (var l in lessons) {
        if (!dates.contains(l.date)) {
          dates.add(l.date);
        }
      }
    } else {
      final fDay = _getFirstDate(lessons: lessons);
      final lDay = _getLastDate(lessons: lessons);
      for (int i = 0; i <= lDay
          .difference(fDay)
          .inDays; i++) {
        var d = fDay.add(Duration(days: i)).toString().split(' ')[0];
        dates.add(d);
      }
    }

    for (var d in dates) {
      less.add(TodayLessons(
          date: d,
          lessons: lessons.where((element) => element.date == d).toList()
      ));
    }

    return less;
  }

  DateTime _getFirstDate({required List<Lesson> lessons}) {
    final List<int> millisecondsSinceEpochList = [];
    for (var element in lessons) {
      millisecondsSinceEpochList.add(DateFormat('yyyy-MM-dd')
          .parse(element.date)
          .millisecondsSinceEpoch);
    }

    final indexFirst = millisecondsSinceEpochList.indexOf(
        millisecondsSinceEpochList.reduce(min));
    final monthFirst = DateTime
        .fromMillisecondsSinceEpoch(millisecondsSinceEpochList[indexFirst])
        .month;
    final yearFirst = DateTime
        .fromMillisecondsSinceEpoch(millisecondsSinceEpochList[indexFirst])
        .year;
    // final dayFirst = DateTime
    //     .fromMillisecondsSinceEpoch(millisecondsSinceEpochList[indexFirst])
    //     .day;
    return DateTime.utc(yearFirst, monthFirst, 1);
  }

  DateTime _getLastDate({required List<Lesson> lessons}) {
    // final List<int> millisecondsSinceEpochList = [];
    //
    // for(var element in lessons){
    //   millisecondsSinceEpochList.add(DateFormat('yyyy-MM-dd').parse(element.date).millisecondsSinceEpoch);
    //
    // }
    // final indexLast = millisecondsSinceEpochList.indexOf(millisecondsSinceEpochList.reduce(max));
    final monthLast = DateTime
        .now()
        .month + 2;
    final yearLast = DateTime
        .now()
        .year;
    final dayLast = DateTime
        .now()
        .day;
    final lastDay = DateTime.utc(yearLast, monthLast, dayLast);
    return lastDay;
  }


  void getLessonsByIdSchool(GetLessonsByIdSchoolEvent event, emit) async {
    try {
      emit(state.copyWith(
          status: TodayScheduleStatus.loading, error: ''));
      await Future.delayed(const Duration(milliseconds: 300));
      final idTeacher = _cubitTeacher.teacherEntity.id;
      final lessons = _cubitTeacher.teacherEntity.lessons
          .where((element) => element.idTeacher == idTeacher)
          .toList();
      final lessonsByIdSchool = getLessons(
          event.id, lessons);
      final todayLessons = getDays(lessonsByIdSchool, onlyWithLesson);
      final index = indexByDateNow(todayLessons);
      pageControllerDatesSchedule.jumpToPage(index.$1);
      emit(state.copyWith(
          indexByDateNow: index.$1,
          visibleTodayButton: index.$2,
          lessons: lessonsByIdSchool,
          currentIdSchool: event.id,
          status: TodayScheduleStatus.loaded,
          todayLessons: todayLessons));
    } on Failure catch (e) {
      emit(state.copyWith(status: TodayScheduleStatus.error, error: e.message));
    }
  }

  List<Lesson> getLessons(String idSchool, List<Lesson> lessons) {
    if (idSchool.isEmpty) return lessons;
    return lessons.where((element) => element.idSchool == idSchool).toList();
  }



  void _getLessonsBySelDate(GetLessonsBySelDateEvent event, emit) async {
    try {
      emit(state.copyWith(
          status: TodayScheduleStatus.loading, error: ''));
      await Future.delayed(const Duration(milliseconds: 300));
      final idTeacher = _cubitTeacher.teacherEntity.id;
      final lessons = _cubitTeacher.teacherEntity.lessons
          .where((element) => element.idTeacher == idTeacher)
          .toList();
      final lessonsByIdSchool = getLessons(state.currentIdSchool, lessons);
      final todayLessons = getDays(lessonsByIdSchool, false);
      final index = indexByDateSelect(todayLessons,event.date);
      pageControllerDatesSchedule.jumpToPage(index.$1);
      emit(state.copyWith(
          indexByDateNow: index.$1,
          visibleTodayButton: index.$2,
          lessons: lessonsByIdSchool,
          status: TodayScheduleStatus.loaded,
          todayLessons: todayLessons));
    } on Failure catch (e) {
      emit(state.copyWith(status: TodayScheduleStatus.error, error: e.message));
    }
  }

  void _getLessonsByModeView(GetLessonsByModeViewEvent event, emit) async {
    try {
      emit(state.copyWith(
          status: TodayScheduleStatus.loading, error: ''));
      await Future.delayed(const Duration(milliseconds: 300));
      final idTeacher = _cubitTeacher.teacherEntity.id;
      final lessons = _cubitTeacher.teacherEntity.lessons
          .where((element) => element.idTeacher == idTeacher)
          .toList();
      final lessonsByIdSchool = getLessons(
          state.currentIdSchool, lessons);
      onlyWithLesson =  event.onlyWithLesson;
      final todayLessons = getDays(lessonsByIdSchool, event.onlyWithLesson);
      final index = indexByDateNow(todayLessons);
      pageControllerDatesSchedule.jumpToPage(index.$1);
      emit(state.copyWith(
          indexByDateNow: index.$1,
          visibleTodayButton: index.$2,
          lessons: lessonsByIdSchool,
          status: TodayScheduleStatus.loaded,
          todayLessons: todayLessons));
    } on Failure catch (e) {
      emit(state.copyWith(status: TodayScheduleStatus.error, error: e.message));
    }
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











