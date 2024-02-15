

 import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtuozy/di/locator.dart';
import 'package:virtuozy/domain/user_cubit.dart';
import 'package:virtuozy/presentations/subscription_screen/bloc/sub_event.dart';
import 'package:virtuozy/presentations/subscription_screen/bloc/sub_state.dart';
import 'package:virtuozy/utils/failure.dart';
import 'package:virtuozy/utils/update_list_ext.dart';

import '../../../domain/entities/user_entity.dart';

class SubBloc extends Bloc<SubEvent,SubState>{
  SubBloc():super(SubState.unknown()){
    on<GetUserEvent>(_getUser);
    on<AcceptLessonEvent>(_acceptLesson);
    on<UpdateUserEvent>(_updateUser);
  }


  final _userCubit = locator.get<UserCubit>();


  void _getUser(GetUserEvent event,emit) async {
     try{
      // emit(state.copyWith(subStatus: SubStatus.loading));
      // await Future.delayed(const Duration(milliseconds: 1500));
       final user = _userCubit.userEntity;
       final firstNotAcceptLesson = _firstNotAcceptLesson(lessons: user.directions[event.currentDirIndex].lessons);
       final listNotAcceptLesson = _getListNotAcceptLesson(lessons: user.directions[event.currentDirIndex].lessons);
       emit(state.copyWith(
           userEntity: user,
           subStatus: SubStatus.loaded,
           firstNotAcceptLesson: firstNotAcceptLesson,
           listNotAcceptLesson: listNotAcceptLesson));
       _listenUser(event);



    }on Failure catch(e){
      throw Failure(e.message);
     }
  }

  void _listenUser(GetUserEvent event) {
     _userCubit.stream.listen((user) async {
       add(UpdateUserEvent(currentDirIndex: event.currentDirIndex, user: user));
     });
  }


  void _updateUser(UpdateUserEvent event,emit) async {
    final firstNotAcceptLesson = _firstNotAcceptLesson(lessons: event.user.directions[event.currentDirIndex].lessons);
    final listNotAcceptLesson = _getListNotAcceptLesson(lessons: event.user.directions[event.currentDirIndex].lessons);
    emit(state.copyWith(
        userEntity: event.user,
        subStatus: SubStatus.loaded,
        firstNotAcceptLesson: firstNotAcceptLesson,
        listNotAcceptLesson: listNotAcceptLesson));
  }


  Lesson _firstNotAcceptLesson({required List<Lesson> lessons}){
    final list = lessons.where((element) => element.status == LessonStatus.awaitAccept).toList();
    if(list.isNotEmpty){
      final listDateEpoch = list.map((e) => DateFormat('yyyy-MM-dd').parse(e.date).millisecondsSinceEpoch).toList();
      final indexLessonFirst = listDateEpoch.indexOf(listDateEpoch.reduce(min));
      return list[indexLessonFirst];
    }

    return Lesson.unknown();

  }

  List<Lesson> _getListNotAcceptLesson({required List<Lesson> lessons}){
    return lessons.where((element) => element.status == LessonStatus.awaitAccept).toList();
  }

  void _acceptLesson(AcceptLessonEvent event,emit) async {
    try{
      emit(state.copyWith(subStatus: SubStatus.confirmation));
      await Future.delayed(const Duration(seconds: 2));
      final dateNow = DateTime.now().toUtc().toString();
      List<Lesson> lessons = event.direction.lessons;
      UserEntity user = _userCubit.userEntity;
      final indexLesson = lessons.indexOf(event.lesson);
      final updatedLesson = event.lesson.copyWith(status: LessonStatus.complete,
          timeAccept: dateNow);
      lessons.update(indexLesson, updatedLesson);
      final updatedDirection = event.direction.copyWith(lessons: lessons);
      List<DirectionLesson> directions = user.directions;
      final indexDirection = directions.indexOf(event.direction);
      directions.update(indexDirection<0?0:indexDirection, updatedDirection);
      final newUser = user.copyWith(directions: directions);
      _userCubit.updateUser(newUser: newUser);
      emit(state.copyWith(subStatus: SubStatus.confirm));
      //todo отнять с баланса сумму за урок

    }on Failure catch(e){

    }
  }




 }


