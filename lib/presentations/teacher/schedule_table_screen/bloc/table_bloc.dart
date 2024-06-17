import 'dart:math';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_planner/time_planner.dart';
import 'package:virtuozy/domain/repository/teacher_repository.dart';
import 'package:virtuozy/presentations/teacher/schedule_table_screen/bloc/table_event.dart';
import 'package:virtuozy/presentations/teacher/schedule_table_screen/bloc/table_state.dart';
import 'package:virtuozy/utils/date_time_parser.dart';

import '../../../../components/date_page_table.dart';
import '../../../../di/locator.dart';
import '../../../../domain/entities/lesson_entity.dart';
import '../../../../domain/entities/table_task.dart';
import '../../../../domain/entities/titles_table.dart';
import '../../../../domain/entities/today_lessons.dart';
import '../../../../domain/teacher_cubit.dart';
import '../../../../utils/failure.dart';

class TableBloc extends Bloc<TableEvent, TableState> {
  TableBloc() : super(TableState.unknown()) {
    on<GetInitLessonsEvent>(getLessonsTable, transformer: droppable());
    on<GetLessonsTableByIdSchool>(getLessonsTableByIdSchool,
        transformer: droppable());
    on<GetLessonsTableByDate>(getLessonsTableByDate, transformer: droppable());
    on<GetLessonsTableWeek>(getLessonTableOnWeek, transformer: droppable());
    on<GetLessonsTableByCalendarDateEvent>(_getLessonsByCalendarDate,
        transformer: droppable());
    on<GetMyLessonEvent>(getMyLesson, transformer: droppable());
    on<EditStatusLessonEvent>(editLesson, transformer: droppable());
    on<AddLessonEvent>(addNewLesson, transformer: droppable());
  }

  final _cubitTeacher = locator.get<TeacherCubit>();
  final _teacherRepository = locator.get<TeacherRepository>();

  void addNewLesson(AddLessonEvent event, emit) async {
    try {
      emit(state.copyWith(
          status: TableStatus.loading,
          error: '',
          addLessonStatus: AddLessonStatus.unknown,
          editLessonStatus: EditLessonStatus.unknown));
      await _teacherRepository.addLesson(lesson: event.lesson);
      final phoneTeacher = _cubitTeacher.teacherEntity.phoneNum;
      final teacher = await _teacherRepository.getTeacher(uid: phoneTeacher);
      _cubitTeacher.setTeacher(teacher: teacher);
      List<TodayLessons> todayLessons = [];
      List<Lesson> lessons = [];
      if (state.modeTable == ViewModeTable.my) {
        lessons = teacher.lessons
            .where((element) => element.idTeacher == teacher.id)
            .toList();
      } else {
        lessons = teacher.lessons;
      }
      final lessonsByIdSchool = getLessons(state.currentIdSchool, lessons);

      if (state.modeTable == ViewModeTable.week) {
        todayLessons = getLessWeek(lessonsByIdSchool);
      } else {
        todayLessons = getDays(lessonsByIdSchool, false);
      }
      final lessonsById = getLessons(state.currentIdSchool, lessons);
      final index = indexByDateNow(todayLessons, state.modeTable == ViewModeTable.week,event.lesson.date);
      final tasks = getTasks(
          todayLesson: todayLessons, indexDate: index.$1, weekMode: state.modeTable == ViewModeTable.week);
      final headerTable = getHeaderTable(
          weekMode:  state.modeTable == ViewModeTable.week,
          todayLesson: todayLessons, indexDate: index.$1);

      emit(state.copyWith(
          titles: headerTable,
          indexByDateNow: index.$1,
          visibleTodayButton: index.$2,
          lessons: lessonsById,
          currentIdSchool: state.currentIdSchool,
          status: TableStatus.loaded,
          scheduleStatus: ScheduleStatus.loaded,
          addLessonStatus: AddLessonStatus.success,
          idsSchool: state.idsSchool,
          tasks: tasks,
          modeTable: state.modeTable,
          todayLessons: todayLessons));
    } on Failure catch (e) {
      emit(state.copyWith(
          status: TableStatus.loaded,
          addLessonStatus: AddLessonStatus.error,
          error: e.message));
    }
  }

  void editLesson(EditStatusLessonEvent event, emit) async {
    try {
      emit(state.copyWith(status: TableStatus.loading, error: '',
          addLessonStatus: AddLessonStatus.unknown,
          editLessonStatus: EditLessonStatus.unknown));
      await _teacherRepository.editLesson(lesson: event.lesson);
      final phoneTeacher = _cubitTeacher.teacherEntity.phoneNum;
      final teacher = await _teacherRepository.getTeacher(uid: phoneTeacher);
      _cubitTeacher.setTeacher(teacher: teacher);
      List<TodayLessons> todayLessons = [];
      List<Lesson> lessons = [];
      if (state.modeTable == ViewModeTable.my) {
        lessons = teacher.lessons
            .where((element) => element.idTeacher == teacher.id)
            .toList();
      } else {
        lessons = teacher.lessons;
      }
      final lessonsByIdSchool = getLessons(state.currentIdSchool, lessons);

      if (state.modeTable == ViewModeTable.week) {
        todayLessons = getLessWeek(lessonsByIdSchool);
      } else {
        todayLessons = getDays(lessonsByIdSchool, false);
      }
      final lessonsById = getLessons(state.currentIdSchool, lessons);
      final index = indexByDateNow(todayLessons,  state.modeTable == ViewModeTable.week,event.lesson.date);
      final tasks = getTasks(
          todayLesson: todayLessons, indexDate: index.$1, weekMode:  state.modeTable == ViewModeTable.week);
      final headerTable = getHeaderTable(
          weekMode:  state.modeTable == ViewModeTable.week, todayLesson: todayLessons, indexDate: index.$1);

      emit(state.copyWith(
          titles: headerTable,
          indexByDateNow: index.$1,
          visibleTodayButton: index.$2,
          lessons: lessonsById,
          editLessonStatus: EditLessonStatus.success,
          currentIdSchool: state.currentIdSchool,
          status: TableStatus.loaded,
          scheduleStatus: ScheduleStatus.loaded,
          idsSchool: state.idsSchool,
          tasks: tasks,
          modeTable: state.modeTable,
          todayLessons: todayLessons));
    } on Failure catch (e) {
      emit(state.copyWith(status: TableStatus.loaded,editLessonStatus: EditLessonStatus.error, error: e.message));
    }
  }


  void getLessonsTable(GetInitLessonsEvent event, emit) async {
    try {
      emit(state.copyWith(status: TableStatus.loading, error: '',
          addLessonStatus: AddLessonStatus.unknown,
          editLessonStatus: EditLessonStatus.unknown));
      await Future.delayed(const Duration(milliseconds: 300));
      final lessons = _cubitTeacher.teacherEntity.lessons;
      if (lessons.isEmpty) {
        emit(state.copyWith(
          scheduleStatus: ScheduleStatus.loaded,
          status: TableStatus.loaded,
          tasks: [],
        ));
        return;
      }
      final ids = getIds(lessons);
      final idSchool = ids.isEmpty ? '' : ids[0];
      final lessonsById = getLessons(idSchool, lessons);
      final todayLessons = getDays(lessonsById, false);
      final index = indexByDateSelect(todayLessons, event.date,false);
      final tasks = getTasks(
          todayLesson: todayLessons, indexDate: index, weekMode: false);
      final headerTable = getHeaderTable(
          weekMode: false, todayLesson: todayLessons, indexDate: index);
      if(event.scrollPage)pageControllerDates.jumpToPage(index);
      emit(state.copyWith(
          titles: headerTable,
          indexByDateNow: index,
          visibleTodayButton: false,
          lessons: lessonsById,
          currentIdSchool: idSchool,
          status: TableStatus.loaded,
          scheduleStatus: ScheduleStatus.loaded,
          idsSchool: ids,
          tasks: tasks,
          modeTable: ViewModeTable.day,
          todayLessons: todayLessons));
    } on Failure catch (e) {
      emit(state.copyWith(status: TableStatus.error, error: e.message));
    }
  }

  void _getLessonsByCalendarDate(
      GetLessonsTableByCalendarDateEvent event, emit) async {
    try {
      emit(state.copyWith(
          status: TableStatus.loading,
          scheduleStatus: ScheduleStatus.loading,
          addLessonStatus: AddLessonStatus.unknown,
          editLessonStatus: EditLessonStatus.unknown,
          error: ''));
      await Future.delayed(const Duration(milliseconds: 300));
      List<TodayLessons> todayLessons = [];
      List<Lesson> lessons = [];
      if (event.viewMode == ViewModeTable.my) {
        final idTeacher = _cubitTeacher.teacherEntity.id;
        lessons = _cubitTeacher.teacherEntity.lessons
            .where((element) => element.idTeacher == idTeacher)
            .toList();
      } else {
        lessons = _cubitTeacher.teacherEntity.lessons;
      }
      final lessonsByIdSchool = getLessons(state.currentIdSchool, lessons);

      if (state.modeTable == ViewModeTable.week) {
        todayLessons = getLessWeek(lessonsByIdSchool);
      } else {
        todayLessons = getDays(lessonsByIdSchool, false);
      }
      final index = indexByDateSelect(
          todayLessons, event.date, state.modeTable == ViewModeTable.week);
      pageControllerDates.jumpToPage(index);
      final tasks = getTasks(
          todayLesson: todayLessons,
          indexDate: index,
          weekMode: state.modeTable == ViewModeTable.week);
      final headerTable = getHeaderTable(
          weekMode: state.modeTable == ViewModeTable.week,
          todayLesson: todayLessons,
          indexDate: index);
      emit(state.copyWith(
          modeTable: state.modeTable,
          indexByDateNow: index,
          lessons: lessonsByIdSchool,
          tasks: tasks,
          titles: headerTable,
          status: TableStatus.loaded,
          scheduleStatus: ScheduleStatus.loaded,
          todayLessons: todayLessons));
    } on Failure catch (e) {
      emit(state.copyWith(
          scheduleStatus: ScheduleStatus.error, error: e.message));
    }
  }

  int indexByDateSelect(
      List<TodayLessons> todayLessons, String dateSelect, bool weekMode) {
    int index = 0;
    final dSel =
        DateFormat('yyyy-MM-dd').parse(dateSelect).millisecondsSinceEpoch;
    if (weekMode) {
      index = todayLessons.indexWhere((element) {
        return hasLessonInWeek(element.date, dSel);
      });
    } else {
      index = todayLessons.indexWhere((element) {
        return element.date == dateSelect;
      });
    }

    return index;
  }

  void getMyLesson(GetMyLessonEvent event, emit) async {
    try {
      emit(state.copyWith(status: TableStatus.loading, error: '',
          addLessonStatus: AddLessonStatus.unknown,
          editLessonStatus: EditLessonStatus.unknown));
      await Future.delayed(const Duration(milliseconds: 300));
      final idTeacher = _cubitTeacher.teacherEntity.id;
      final lessons = _cubitTeacher.teacherEntity.lessons
          .where((element) => element.idTeacher == idTeacher)
          .toList();
      final lessonsByIdSchool = getLessons(state.currentIdSchool, lessons);
      final weekLessons = getLessWeek(lessonsByIdSchool);
      final dateNow = DateTime.now().toString().split(' ')[0];
      final index = indexByDateSelect(weekLessons, dateNow, true);
      final tasks =
          getTasks(todayLesson: weekLessons, indexDate: index, weekMode: true);
      final headerTable = getHeaderTable(
          weekMode: true, todayLesson: weekLessons, indexDate: index);
      pageControllerDates.jumpToPage(index);
      emit(state.copyWith(
          titles: headerTable,
          indexByDateNow: index,
          visibleTodayButton: false,
          status: TableStatus.loaded,
          scheduleStatus: ScheduleStatus.loaded,
          tasks: tasks,
          modeTable: ViewModeTable.my,
          todayLessons: weekLessons));
    } on Failure catch (e) {
      emit(state.copyWith(
          scheduleStatus: ScheduleStatus.error, error: e.message));
    }
  }

  void getLessonTableOnWeek(GetLessonsTableWeek event, emit) async {
    try {
      emit(state.copyWith(status: TableStatus.loading, error: '',
          addLessonStatus: AddLessonStatus.unknown,
          editLessonStatus: EditLessonStatus.unknown));
      await Future.delayed(const Duration(milliseconds: 300));
      final idTeacher = _cubitTeacher.teacherEntity.id;
      final lessons = _cubitTeacher.teacherEntity.lessons
          .where((element) => element.idTeacher == idTeacher)
          .toList();
      final lessonsByIdSchool = getLessons(state.currentIdSchool, lessons);
      final weekLessons = getLessWeek(lessonsByIdSchool);
      final index = indexByDateSelect(weekLessons, event.date, true);
      final tasks = getTasks(todayLesson: weekLessons, indexDate: index, weekMode: true);
      final headerTable = getHeaderTable(
          weekMode: true, todayLesson: weekLessons, indexDate: index);
      emit(state.copyWith(
          titles: headerTable,
          indexByDateNow: index,
          visibleTodayButton: false,
          status: TableStatus.loaded,
          scheduleStatus: ScheduleStatus.loaded,
          tasks: tasks,
          modeTable: event.viewMode,
          todayLessons: weekLessons));
      pageControllerDates.jumpToPage(index);

    } on Failure catch (e) {
      emit(state.copyWith(
          scheduleStatus: ScheduleStatus.error, error: e.message));
    }
  }

  void getLessonsTableByIdSchool(GetLessonsTableByIdSchool event, emit) async {
    try {
      emit(state.copyWith(status: TableStatus.loading, error: '',
          addLessonStatus: AddLessonStatus.unknown,
          editLessonStatus: EditLessonStatus.unknown));
      await Future.delayed(const Duration(milliseconds: 300));
      List<TodayLessons> todayLessons = [];
      List<Lesson> lessons = [];
      if (state.modeTable == ViewModeTable.my) {
        final idTeacher = _cubitTeacher.teacherEntity.id;
        lessons = _cubitTeacher.teacherEntity.lessons
            .where((element) => element.idTeacher == idTeacher)
            .toList();
      } else {
        lessons = _cubitTeacher.teacherEntity.lessons;
      }
      final ids = getIds(lessons);
      final lessonsByIdSchool = getLessons(event.id, lessons);
      if (state.modeTable == ViewModeTable.week) {
        todayLessons = getLessWeek(lessonsByIdSchool);
      } else {
        todayLessons = getDays(lessonsByIdSchool, false);
      }
      final index =
          indexByDateNow(todayLessons, state.modeTable == ViewModeTable.week,todayLessons[0].date);

      final tasks = getTasks(
          todayLesson: todayLessons,
          indexDate: index.$1,
          weekMode: state.modeTable == ViewModeTable.week);
      final headerTable = getHeaderTable(
          weekMode: state.modeTable == ViewModeTable.week,
          todayLesson: todayLessons,
          indexDate: index.$1);
      emit(state.copyWith(
          titles: headerTable,
          indexByDateNow: index.$1,
          visibleTodayButton: index.$2,
          lessons: lessonsByIdSchool,
          currentIdSchool: event.id,
          status: TableStatus.loaded,
          scheduleStatus: ScheduleStatus.loaded,
          idsSchool: ids,
          tasks: tasks,
          todayLessons: todayLessons));
    } on Failure catch (e) {
      emit(state.copyWith(
          scheduleStatus: ScheduleStatus.error, error: e.message));
    }
  }

  void getLessonsTableByDate(GetLessonsTableByDate event, emit) async {
    try {
      emit(state.copyWith(
          status: TableStatus.loading, tasks: [], titles: [], error: '',
          addLessonStatus: AddLessonStatus.unknown,
          editLessonStatus: EditLessonStatus.unknown));
      await Future.delayed(const Duration(milliseconds: 300));
      List<TodayLessons> todayLessons = [];
      List<Lesson> lessons = [];
      if (event.viewMode == ViewModeTable.my) {
        final idTeacher = _cubitTeacher.teacherEntity.id;
        lessons = _cubitTeacher.teacherEntity.lessons
            .where((element) => element.idTeacher == idTeacher)
            .toList();
      } else {
        lessons = _cubitTeacher.teacherEntity.lessons;
      }

      final ids = getIds(lessons);
      final lessonsByIdSchool = getLessons(state.currentIdSchool, lessons);
      if (event.viewMode == ViewModeTable.week) {
        todayLessons = getLessWeek(lessonsByIdSchool);
      } else {
        todayLessons = getDays(lessonsByIdSchool, false);
      }
      final tasks = getTasks(
          todayLesson: todayLessons,
          indexDate: event.indexDate,
          weekMode: event.viewMode == ViewModeTable.week);
      final headerTable = getHeaderTable(
          weekMode: event.viewMode == ViewModeTable.week,
          todayLesson: todayLessons,
          indexDate: event.indexDate);
      emit(state.copyWith(
          titles: headerTable,
          indexByDateNow: event.indexDate,
          visibleTodayButton: false,
          lessons: lessonsByIdSchool,
          currentIdSchool: state.currentIdSchool,
          status: TableStatus.loaded,
          idsSchool: ids,
          tasks: tasks,
          modeTable: event.viewMode,
          todayLessons: todayLessons));
    } on Failure catch (e) {
      emit(state.copyWith(status: TableStatus.error, error: e.message));
    }
  }

  List<TitlesTable> getHeaderTable(
      {required bool weekMode,
      required List<TodayLessons> todayLesson,
      required int indexDate}) {
    const listAuditory = ['Свинг', 'Авангард', 'Опера', 'Блюз', 'Эстрада'];
    List<String> headers1 = [];
    List<String> headers2 = [];
    List<String> dateChoice = [];
    if (weekMode) {
      List<String> daysWeek = [];
      final fDay = DateFormat('yyyy-MM-dd')
          .parse(todayLesson[indexDate].date.split('/')[0]);
      final lDay = DateFormat('yyyy-MM-dd')
          .parse(todayLesson[indexDate].date.split('/')[1]);
      for (int i = 0; i <= lDay.difference(fDay).inDays-1; i++) {
        var d = fDay.add(Duration(days: i)).toString().split(' ')[0];
        daysWeek.add(d);
      }
      headers1 = daysWeek
          .map((e) => DateFormat('yyyy-MM-dd').parse(e).day.toString())
          .toList();
      headers2 = daysWeek
          .map((e) => DateTimeParser.getDayByNumber(
              DateFormat('yyyy-MM-dd').parse(e).weekday))
          .toList();
      dateChoice = daysWeek
          .map(
              (e) => DateFormat('yyyy-MM-dd').parse(e).toString().split(' ')[0])
          .toList();
    } else {
      headers1 = listAuditory;
      dateChoice = List.generate(headers1.length,
          (index) => todayLesson[indexDate].date.split('/')[0]);
    }
    List<TitlesTable> titles = [];
    for (var i = 0; headers1.length > i; i++) {
      titles.add(
        TitlesTable(
          dateChoice: dateChoice[i],
          date: weekMode ? headers1[i] : '',
          title: weekMode ? headers2[i] : headers1[i],
        ),
      );
    }

    return titles;
  }

  List<TableTask> getTasks(
      {required List<TodayLessons> todayLesson,
      required int indexDate,
      required bool weekMode}) {
    final lessons = todayLesson[indexDate].lessons;
    const listAuditory = ['Свинг', 'Авангард', 'Опера', 'Блюз', 'Эстрада'];
    List<String> daysWeek = [];
    if (weekMode) {
      final fDay = DateFormat('yyyy-MM-dd')
          .parse(todayLesson[indexDate].date.split('/')[0]);
      final lDay = DateFormat('yyyy-MM-dd')
          .parse(todayLesson[indexDate].date.split('/')[1]);
      for (int i = 0; i <= lDay.difference(fDay).inDays; i++) {
        var d = fDay.add(Duration(days: i)).toString().split(' ')[0];
        daysWeek.add(d);
      }
    }
    List<TableTask> tasks = [];
    int rowPosition = 0;
    for (var t in lessons) {
      final hour =
          int.parse(t.timePeriod.split('-')[0].split(':')[0].toString());
      if (weekMode) {
        rowPosition = daysWeek.indexWhere((element) => t.date == element);
      } else {
        rowPosition =
            listAuditory.indexWhere((element) => t.idAuditory == element);
      }
      tasks.add(TableTask(
          lesson: t,
          timePlannerDateTime:
              TimePlannerDateTime(day: rowPosition, hour: hour, minutes: 00)));
    }
    return tasks;
  }

  (int, bool) indexByDateNow(List<TodayLessons> todayLessons, bool weekView,[String dateAdded = '']) {
    final dateNow = DateTime.now().toString().split(' ')[0];
    final dateNowEpoch = DateTime.now().millisecondsSinceEpoch;
    print('Date ${dateAdded}');
    final dateAddedEpoch = DateFormat('yyyy-MM-dd')
        .parse(dateAdded)
        .millisecondsSinceEpoch;
    int index = 0;
    bool visibleButtonToday = false;
    int i = 0;

    if (!weekView) {
      if (dateAdded.isNotEmpty) {
        i = todayLessons.indexWhere((element) => element.date == dateAdded);
      } else {
        i = todayLessons.indexWhere((element) => element.date == dateNow);
      }
      if (i < 0) {
        visibleButtonToday = true;
        final i1 = todayLessons.indexWhere((element) =>
            DateFormat('yyyy-MM-dd')
                .parse(element.date)
                .millisecondsSinceEpoch >
            dateNowEpoch);
        if (i1 < 0) {
          index = todayLessons.length - 1;
        } else {
          index = i1;
        }
      } else {
        index = i;
      }
    } else {
      if (dateAdded.isNotEmpty) {
        i = todayLessons.indexWhere((element) => hasLessonInWeek(element.date, dateAddedEpoch));
      } else {
         i = todayLessons
            .indexWhere((element) => hasLessonInWeek(element.date, dateNowEpoch));
      }

      if (i < 0) {
        final i1 = todayLessons.indexWhere((element) =>
            DateFormat('yyyy-MM-dd')
                .parse(element.date.split('/')[1])
                .millisecondsSinceEpoch >
            dateNowEpoch);
        if (i1 < 0) {
          index = todayLessons.length - 1;
        } else {
          index = i1;
        }
      } else {
        index = i;
      }
    }

    return (index, visibleButtonToday);
  }

  bool hasLessonInWeek(String week, int dateNowEpoch) {
    final d1 = DateFormat('yyyy-MM-dd')
        .parse(week.split('/')[0])
        .millisecondsSinceEpoch;
    final d2 = DateFormat('yyyy-MM-dd')
        .parse(week.split('/')[1])
        .millisecondsSinceEpoch;
    return d1 <= dateNowEpoch && dateNowEpoch <= d2;
  }

  List<TodayLessons> getLessWeek(List<Lesson> lessons) {
    List<TodayLessons> less = [];
    lessons.sort((a, b) => DateFormat('yyyy-MM-dd')
        .parse(a.date)
        .millisecondsSinceEpoch
        .compareTo(
            DateFormat('yyyy-MM-dd').parse(b.date).millisecondsSinceEpoch));
    int weekCount = 0;
    final fDay = _getFirstDate(lessons: lessons);
    final lDay = _getLastDate(lessons: lessons);

    final daysCount = lDay.difference(fDay).inDays;
    if (daysCount <= 7) {
      weekCount = 1;
    } else {
      final i1 = (daysCount / 7).round();
      final i2 = daysCount / 7;
      if (i2 > i1) {
        weekCount = i1 + 1;
      } else {
        weekCount = i1;
      }
    }
    int initDay = fDay.millisecondsSinceEpoch;
    int weekMsEpoch = 604800000;
    for (var i = 0; weekCount > i; i++) {
      final d1 = DateTime.fromMillisecondsSinceEpoch(initDay);
      initDay += weekMsEpoch;
      final d2 = DateTime.fromMillisecondsSinceEpoch(initDay);
      less.add(TodayLessons(
          date: '${d1.toString().split(' ')[0]}/'
              '${d2.toString().split(' ')[0]}',
          lessons:
              lessons.where((element) => addLesson(element, d1, d2)).toList()));
    }

    return less;
  }

  bool addLesson(Lesson lesson, DateTime dt1, DateTime dt2) {
    final d3 =
        DateFormat('yyyy-MM-dd').parse(lesson.date).millisecondsSinceEpoch;
    final d1 = dt1.millisecondsSinceEpoch;
    final d2 = dt2.millisecondsSinceEpoch;
    return d1 <= d3 && d3 <= d2;
  }

  List<TodayLessons> getDays(List<Lesson> lessons, bool daysOnlyLesson) {
    List<TodayLessons> less = [];
    List<String> dates = [];
    lessons.sort((a, b) => DateFormat('yyyy-MM-dd')
        .parse(a.date)
        .millisecondsSinceEpoch
        .compareTo(
            DateFormat('yyyy-MM-dd').parse(b.date).millisecondsSinceEpoch));
    if (daysOnlyLesson) {
      for (var l in lessons) {
        if (!dates.contains(l.date)) {
          dates.add(l.date);
        }
      }
    } else {
      final fDay = _getFirstDate(lessons: lessons);
      final lDay = _getLastDate(lessons: lessons);
      for (int i = 0; i <= lDay.difference(fDay).inDays; i++) {
        var d = fDay.add(Duration(days: i)).toString().split(' ')[0];
        dates.add(d);
      }
    }

    for (var d in dates) {
      less.add(TodayLessons(
          date: d,
          lessons: lessons.where((element) => element.date == d).toList()));
    }

    return less;
  }

  DateTime _getLastDate({required List<Lesson> lessons}) {
    final monthLast = DateTime.now().month + 2;
    final yearLast = DateTime.now().year;
    final dayLast = DateTime.now().day;
    final lastDay = DateTime.utc(yearLast, monthLast, dayLast);
    return lastDay;
  }

  DateTime _getFirstDate({required List<Lesson> lessons}) {
    final List<int> millisecondsSinceEpochList = [];
    late DateTime  dateFirst;
    for (var element in lessons) {
      millisecondsSinceEpochList.add(
          DateFormat('yyyy-MM-dd').parse(element.date).millisecondsSinceEpoch);
    }

    final indexFirst = millisecondsSinceEpochList
        .indexOf(millisecondsSinceEpochList.reduce(min));
    final monthFirst = DateTime.fromMillisecondsSinceEpoch(
            millisecondsSinceEpochList[indexFirst])
        .month;
    final yearFirst = DateTime.fromMillisecondsSinceEpoch(
            millisecondsSinceEpochList[indexFirst])
        .year;
    // final dayFirst = DateTime
    //     .fromMillisecondsSinceEpoch(millisecondsSinceEpochList[indexFirst])
    //     .day;
    dateFirst = DateTime.utc(yearFirst, monthFirst, 1);
    if(dateFirst.weekday>1){
      final dt = dateFirst.weekday-1;
      final dt1 = dt*86400000;
      final d1 = dateFirst.millisecondsSinceEpoch - dt1;
     dateFirst = DateTime.fromMillisecondsSinceEpoch(d1);
      return dateFirst;
    }
    return dateFirst;
  }

  List<Lesson> getLessons(String idSchool, List<Lesson> lessons) {
    if (idSchool.isEmpty) return lessons;
    return lessons.where((element) => element.idSchool == idSchool).toList();
  }

  List<String> getIds(List<Lesson> lessons) {
    List<String> ids = [];
    for (var l in lessons) {
      if (!ids.contains(l.idSchool)) {
        ids.add(l.idSchool);
      }
    }
    return ids;
  }
}
