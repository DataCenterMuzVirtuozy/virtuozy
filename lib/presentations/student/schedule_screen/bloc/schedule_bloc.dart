


 import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtuozy/di/locator.dart';
import 'package:virtuozy/domain/entities/schedule_lessons.dart';
import 'package:virtuozy/domain/entities/user_entity.dart';
import 'package:virtuozy/domain/user_cubit.dart';
import 'package:virtuozy/presentations/student/schedule_screen/bloc/schedule_event.dart';
import 'package:virtuozy/presentations/student/schedule_screen/bloc/schedule_state.dart';
import 'package:virtuozy/utils/failure.dart';

import '../../../../domain/entities/lesson_entity.dart';
import '../../../../domain/repository/user_repository.dart';
import '../../../../utils/preferences_util.dart';

ValueNotifier<List<ScheduleLessons>> listScheduleNotifier = ValueNotifier<List<ScheduleLessons>>([]);

class ScheduleBloc extends Bloc<ScheduleEvent,ScheduleState>{
  ScheduleBloc():super(ScheduleState.unknown()){
   on<GetScheduleEvent>(_getSchedule);
   on<UpdateUserEvent>(_updateUser);
   on<GetDetailsScheduleEvent>(_getDetailsSchedule);
   on<RefreshDataEvent>(_refreshData,transformer: droppable());

  }

  final _userCubit = locator.get<UserCubit>();
  final _userRepository = locator.get<UserRepository>();




  void _getDetailsSchedule(GetDetailsScheduleEvent event,emit) async {
    try{
      if(event.refreshDirection){
        emit(state.copyWith(status: ScheduleStatus.loading));
        await Future.delayed(const Duration(milliseconds: 1000));
      }
      final user = _userCubit.userEntity;
      final  schedulesList = _getDetailsListSchedules(
          userEntity: user, indexSelDirection: event.currentDirIndex,
          allViewDir: event.allViewDir);
      emit(state.copyWith(
          status: ScheduleStatus.loaded,
          user: user,
          schedulesList: schedulesList));
    }on Failure catch(e){

    }
  }


  void _refreshData(RefreshDataEvent event,emit) async {
    try {
      emit(state.copyWith(status: ScheduleStatus.loading));
      final uid = PreferencesUtil.uid;
      final user = await _userRepository.getUser(uid: uid);
      _userCubit.setUser(user: user);
      if (user.userStatus.isNotAuth) {
        emit(state.copyWith(status: ScheduleStatus.loaded, user: user));
        return;
      }

      final schedulesList = _getListSchedules(
          currentMonth: event.month,
          userEntity: user, indexSelDirection: event.currentDirIndex,
          allViewDir: event.allViewDir);
      final schedulesLength = _getSchedulesLength(
          userEntity: user, indexSelDirection: event.currentDirIndex,
          allViewDir: event.allViewDir);
      final lessons = _getAllLessons(
          user, event.allViewDir, event.currentDirIndex);
      if (!event.refreshMonth) {
        emit(state.copyWith(
            status: ScheduleStatus.loaded,
            user: user,
            lessons: lessons,
            schedulesLength: schedulesLength));
        listScheduleNotifier.value = schedulesList;
      } else {
        listScheduleNotifier.value = schedulesList;
      }

      _listenUserFromRefresh(event);
    } on Failure catch (e) {
      emit(state.copyWith(status: ScheduleStatus.error, error: e.message));
    }
  }


  void _getSchedule(GetScheduleEvent event,emit) async {
     try{
       final user = _userCubit.userEntity;
       if(user.userStatus.isNotAuth){
         emit(state.copyWith(status: ScheduleStatus.loaded,user: user));
         return;
       }
       if(event.refreshDirection){
         emit(state.copyWith(status: ScheduleStatus.loading));
         await Future.delayed(const Duration(milliseconds: 1000));
       }
      final  schedulesList = _getListSchedules(
        currentMonth: event.month,
          userEntity: user, indexSelDirection: event.currentDirIndex,
      allViewDir: event.allViewDir);
      final schedulesLength = _getSchedulesLength(userEntity: user,indexSelDirection: event.currentDirIndex,
      allViewDir: event.allViewDir);
       final lessons = _getAllLessons(user, event.allViewDir, event.currentDirIndex);
       if(!event.refreshMonth){
         emit(state.copyWith(
             status: ScheduleStatus.loaded,
             user: user,
             lessons: lessons,
             schedulesLength: schedulesLength));
         listScheduleNotifier.value = schedulesList;
       }else {
         listScheduleNotifier.value = schedulesList;
       }

       _listenUser(event);


     }on Failure catch(e){
       emit(state.copyWith(status: ScheduleStatus.error, error: e.message));
     }



  }

  List<Lesson> _getAllLessons(UserEntity user,bool allViewLessons,int indexDir){
    List<Lesson> resLes = [];

    if(allViewLessons){
      for(var dir in user.directions){
        resLes.addAll(dir.lessons);
      }
    }else{
      resLes = user.directions[indexDir].lessons;
    }

    return resLes;
  }


  int _getSchedulesLength({ required UserEntity userEntity,required int indexSelDirection,required bool allViewDir}){
    if(allViewDir){
      return 2;
    }
   final lessons = userEntity.directions[indexSelDirection].lessons;
   final lesTS = lessons.map((e) => (DateFormat('yyyy-MM-dd').parse(e.date).millisecondsSinceEpoch)).toList();
   List<int> m = [];
   List<int> listResult = [];
   lesTS.sort();
   for(var a in lesTS){
     var b = DateTime.fromMillisecondsSinceEpoch(a).month;
     if(!m.contains(b)){
       m.add(b);
       listResult.add(a);

     }
   }

    return listResult.length;
  }






  List<ScheduleLessons> _getListSchedules({
    required int currentMonth,
    required UserEntity userEntity,required int indexSelDirection,
  required bool allViewDir}){
    List<Lesson> lessons = [];
     if(allViewDir){
       for(var dir in userEntity.directions){
         lessons.addAll(dir.lessons);
       }
     }else{
       lessons = userEntity.directions[indexSelDirection].lessons;
     }

    final lesTS = lessons.map((e) => (DateFormat('yyyy-MM-dd').parse(e.date).millisecondsSinceEpoch)).toList();
     final yearNow = DateTime.now().year;
     lesTS.removeWhere((ts)=>DateTime.fromMillisecondsSinceEpoch(ts).year < yearNow);
    List<ScheduleLessons> listResult = [];
    lesTS.sort();
    listResult.add(
        ScheduleLessons(month: _getMonthFromInt(currentMonth),
            lessons: _createListLessons(month: currentMonth, lesTS: lesTS, firstLessons: lessons))
    );

    return listResult;
  }

  List<ScheduleLessons> _getDetailsListSchedules({
    required UserEntity userEntity,required int indexSelDirection,
    required bool allViewDir}){
    List<Lesson> lessons = [];
    List<int> m = [];
    if(allViewDir){
      for(var dir in userEntity.directions){
        lessons.addAll(dir.lessons);
      }
    }else{
      lessons = userEntity.directions[indexSelDirection].lessons;
    }

    final lesTS = lessons.map((e) => (DateFormat('yyyy-MM-dd').parse(e.date).millisecondsSinceEpoch)).toList();
    final yearNow = DateTime.now().year;
    lesTS.removeWhere((ts)=>DateTime.fromMillisecondsSinceEpoch(ts).year < yearNow);
    List<ScheduleLessons> listResult = [];
    lesTS.sort();
    for(var a in lesTS){
      var b = DateTime.fromMillisecondsSinceEpoch(a).month;
      if(allViewDir){
        if(!m.contains(b)){
          m.add(b);
          listResult.add(
              ScheduleLessons(month: _getMonthFromInt(b),
                  lessons: _createListLessons(month: b, lesTS: lesTS, firstLessons: lessons))
          );

        }
      }else{
        if(!m.contains(b)){
          m.add(b);
          listResult.add(
              ScheduleLessons(month: _getMonthFromInt(b),
                  lessons: _createListLessons(month: b, lesTS: lesTS, firstLessons: lessons))
          );

        }
      }

    }


    return listResult;
  }



  List<Lesson> _createListLessons({required int month,required List<int> lesTS, required List<Lesson> firstLessons}){
    List<Lesson> listResult = [];
    List<int> ts = [];
    for(var lts in lesTS){
      if(!ts.contains(lts)&&month == DateTime.fromMillisecondsSinceEpoch(lts).month){
        ts.add(lts);
        listResult.addAll(firstLessons.where((element) =>
        DateFormat('yyyy-MM-dd').parse(element.date).millisecondsSinceEpoch == lts));
      }
    }

    return listResult;
  }



  ScheduleLessons _getScheduleMonth({required List<ScheduleLessons>  list, required int month}){
    // final lessons = userEntity.directions[indexSelDirection].lessons;
    // final lesTS = lessons.map((e) => (DateFormat('yyyy-MM-dd').parse(e.date).millisecondsSinceEpoch)).toList();
    // lesTS.sort();
    //List<Lesson> lessonsResult = [];
   // for (var lts in lesTS){
   //     if(month == DateTime.fromMillisecondsSinceEpoch(lts).month){
   //       lessonsResult.add(lessons.firstWhere((element) =>
   //       DateFormat('yyyy-MM-dd').parse(element.date).millisecondsSinceEpoch == lts));
   //     }
   //  }

   return list.firstWhere((element) => element.month.contains(_getMonthFromInt(month)));
  }

  //todo local
  String _getMonthFromInt(int month){
    switch(month){
      case 1 : return 'Январь';
      case 2 : return 'Февраль';
      case 3 : return 'Март';
      case 4 : return 'Апрель';
      case 5 : return 'Май';
      case 6 : return 'Июнь';
      case 7 : return 'Июль';
      case 8 : return 'Август';
      case 9 : return 'Сентябрь';
      case 10 : return 'Октябрь';
      case 11 : return 'Ноябрь';
      case 12 : return 'Декабрь';
    }
    return '';
  }


  void _listenUser(GetScheduleEvent event) {
    _userCubit.stream.listen((user) async {
      final  schedulesList = _getListSchedules(
         currentMonth: event.month,
          userEntity: user, indexSelDirection: event.currentDirIndex,
      allViewDir: event.allViewDir);
      final scheduleMonth = _getScheduleMonth(list:schedulesList, month: event.month);
      listScheduleNotifier.value = schedulesList;
      add(UpdateUserEvent(currentDirIndex: event.currentDirIndex, user: user,scheduleLessons: scheduleMonth));
    });
  }

  void _listenUserFromRefresh(RefreshDataEvent event) {
    _userCubit.stream.listen((user) async {
      final  schedulesList = _getListSchedules(
          currentMonth: event.month,
          userEntity: user, indexSelDirection: event.currentDirIndex,
          allViewDir: event.allViewDir);
      final scheduleMonth = _getScheduleMonth(list:schedulesList, month: event.month);
      listScheduleNotifier.value = schedulesList;
      add(UpdateUserEvent(currentDirIndex: event.currentDirIndex, user: user,scheduleLessons: scheduleMonth));
    });
  }


  void _updateUser(UpdateUserEvent event,emit) async {
    emit(state.copyWith(status: ScheduleStatus.loaded,user: event.user,scheduleLessons: event.scheduleLessons));
  }









}