


  import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_planner/time_planner.dart';
import 'package:virtuozy/presentations/teacher/bloc/table_event.dart';
import 'package:virtuozy/presentations/teacher/bloc/table_state.dart';

import '../../../di/locator.dart';
import '../../../domain/entities/lesson_entity.dart';
import '../../../domain/entities/table_task.dart';
import '../../../domain/entities/titles_table.dart';
import '../../../domain/entities/today_lessons.dart';
import '../../../domain/teacher_cubit.dart';
import '../../../utils/failure.dart';
import '../../../utils/text_style.dart';

class TableBloc extends Bloc<TableEvent,TableState>{


  TableBloc():super(TableState.unknown()){
   on<GetInitLessonsEvent>(getLessonsTable);
  }

  final _cubitTeacher = locator.get<TeacherCubit>();

  void getLessonsTable(GetInitLessonsEvent event, emit) async {
    try {
      emit(state.copyWith(
          status: TableStatus.loading, error: ''));
      await Future.delayed(const Duration(seconds: 1));
      final lessons = _cubitTeacher.teacherEntity.lessons;
      final ids = getIds(lessons);
      final idSchool = ids.isEmpty ? '' : ids[0];
      final lessonsById = getLessons(
          idSchool, lessons);
      final todayLessons = getDays(lessonsById, false);
      final index = indexByDateNow(todayLessons);
      final tasks = getTasks(todayLesson: todayLessons,indexDate: index.$1);
      final headerTable = getHeaderTable(weekMode: false);
      emit(state.copyWith(
        titles: headerTable,
          indexByDateNow: index.$1,
          visibleTodayButton: index.$2,
          lessons: lessonsById,
          currentIdSchool: idSchool,
          status: TableStatus.loaded,
          idsSchool: ids,
          tasks: tasks,
          todayLessons: todayLessons));
    } on Failure catch (e) {
      emit(state.copyWith(status: TableStatus.error, error: e.message));
    }
  }


  List<TitlesTable> getHeaderTable({required bool weekMode}){
    const listAuditory = ['Свинг','Авангард','Опера','Блюз','Эстрада'];
    List<TitlesTable> titles = [];
    for(var h in listAuditory){
      titles.add( TitlesTable(
        date: "",
        title: h,
      ),);
    }

    return titles;
  }

  List<TableTask> getTasks({required List<TodayLessons> todayLesson, required int indexDate}){
    final lessons = [
      Lesson(
          contactValues: [],
          id: 0,
          idSub: 0,
          idSchool: 'mc',
          bonus: false,
          timeAccept: '',
          date: '',
          timePeriod: '12:00-13:00',
          idAuditory: 'Свинг',
          nameTeacher: '',
          nameStudent: 'Dad Petrov',
          status: LessonStatus.awaitAccept,
          nameDirection: 'HH'),
      Lesson(
          contactValues: [],
          id: 0,
          idSub: 0,
          idSchool: 'mc',
          bonus: false,
          timeAccept: '',
          date: '',
          timePeriod: '14:00-15:00',
          idAuditory: 'Эстрада',
          nameTeacher: '',
          nameStudent: 'Dad Petrov 1',
          status: LessonStatus.planned,
          nameDirection: 'HH'),
      Lesson(
          contactValues: [],
          id: 0,
          idSub: 0,
          idSchool: 'mc',
          bonus: false,
          timeAccept: '',
          date: '',
          timePeriod: '16:00-17:00',
          idAuditory: 'Блюз',
          nameTeacher: '',
          nameStudent: 'Dad Petrov 2',
          status: LessonStatus.firstLesson,
          nameDirection: 'HH'),
      Lesson(
          contactValues: [],
          id: 0,
          idSub: 0,
          idSchool: 'mc',
          bonus: false,
          timeAccept: '',
          date: '',
          timePeriod: '10:00-11:00',
          idAuditory: 'Опера',
          nameTeacher: '',
          nameStudent: 'Dad Petrov 3',
          status: LessonStatus.cancel,
          nameDirection: 'HH'),
      Lesson(
          contactValues: [],
          id: 0,
          idSub: 0,
          idSchool: 'mc',
          bonus: false,
          timeAccept: '',
          date: '',
          timePeriod: '18:00-19:00',
          idAuditory: 'Авангард',
          nameTeacher: '',
          nameStudent: 'Dad Petrov 4',
          status: LessonStatus.complete,
          nameDirection: 'HH')

    ];
    const listAuditory = ['Свинг','Авангард','Опера','Блюз','Эстрада'];
    List<TableTask> tasks = [];
    for(var t in lessons){
      final hour = int.parse(t.timePeriod.split('-')[0].split(':')[0].toString());
      final day = listAuditory.indexWhere((element) => t.idAuditory == element);
       tasks.add(TableTask(
          lesson: t,
          timePlannerDateTime:
              TimePlannerDateTime(day: day, hour: hour, minutes: 00)));
    }
    return tasks;
  }

  (int,bool) indexByDateNow(List<TodayLessons> todayLessons) {
    final dateNow = DateTime.now().toString().split(' ')[0];
    final dateNowEpoch = DateTime
        .now()
        .millisecondsSinceEpoch;
    int index = 0;
    bool visibleButtonToday = false;
    final i = todayLessons.indexWhere((element) => element.date == dateNow);
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

  DateTime _getLastDate({required List<Lesson> lessons}) {

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



  List<Lesson> getLessons(String idSchool, List<Lesson> lessons) {
    if (idSchool.isEmpty) return lessons;
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