


 import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtuozy/di/locator.dart';
import 'package:virtuozy/domain/entities/schedule_lessons.dart';
import 'package:virtuozy/domain/entities/user_entity.dart';
import 'package:virtuozy/domain/user_cubit.dart';
import 'package:virtuozy/presentations/schedule_screen/bloc/schedule_event.dart';
import 'package:virtuozy/presentations/schedule_screen/bloc/schedule_state.dart';
import 'package:virtuozy/utils/failure.dart';

class ScheduleBloc extends Bloc<ScheduleEvent,ScheduleState>{
  ScheduleBloc():super(ScheduleState.unknown()){
   on<GetScheduleEvent>(_getSchedule);
   on<UpdateUserEvent>(_updateUser);
  }

  final _userCubit = locator.get<UserCubit>();


  void _getSchedule(GetScheduleEvent event,emit) async {
     try{
      //emit(state.copyWith(status: ScheduleStatus.loading));
      final user = _userCubit.userEntity;
      final  schedulesList = _getListSchedules(userEntity: user, indexSelDirection: event.currentDirIndex);
      final scheduleMonth = _getScheduleMonth(list: schedulesList,month: event.month);

      emit(state.copyWith(status: ScheduleStatus.loaded,user: user,
          scheduleLessons: scheduleMonth,schedulesList: schedulesList));
     _listenUser(event);

     }on Failure catch(e){

     }



  }

  List<ScheduleLessons> _getListSchedules({required UserEntity userEntity,required int indexSelDirection}){
    final lessons = userEntity.directions[indexSelDirection].lessons;
    final lesTS = lessons.map((e) => (DateFormat('yyyy-MM-dd').parse(e.date).millisecondsSinceEpoch)).toList();
    List<int> m = [];
    List<ScheduleLessons> listResult = [];
    lesTS.sort();
    for(var a in lesTS){
      var b = DateTime.fromMillisecondsSinceEpoch(a).month;
      if(!m.contains(b)){
          m.add(b);
          listResult.add(
              ScheduleLessons(month: _getMonthFromInt(b),
                  lessons: _createListLessons(month: b, lesTS: lesTS, firstLessons: lessons))
          );

      }
    }


    return listResult;
  }


  List<Lesson> _createListLessons({required int month,required List<int> lesTS, required List<Lesson> firstLessons}){
    List<Lesson> listResult = [];
    for(var lts in lesTS){
      if(month == DateTime.fromMillisecondsSinceEpoch(lts).month){
        listResult.add(firstLessons.firstWhere((element) => DateFormat('yyyy-MM-dd').parse(element.date).millisecondsSinceEpoch == lts));
      }
    }

    return firstLessons;
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
      final  schedulesList = _getListSchedules(userEntity: user, indexSelDirection: event.currentDirIndex);
      final scheduleMonth = _getScheduleMonth(list:schedulesList, month: event.month);
      add(UpdateUserEvent(currentDirIndex: 0, user: user,scheduleLessons: scheduleMonth));
    });
  }


  void _updateUser(UpdateUserEvent event,emit) async {
    emit(state.copyWith(status: ScheduleStatus.loaded,user: event.user,scheduleLessons: event.scheduleLessons));
  }









}