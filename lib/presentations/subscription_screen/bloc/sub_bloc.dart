

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
  }


  final _userCubit = locator.get<UserCubit>();


  void _getUser(GetUserEvent event,emit) async {
     try{
      emit(state.copyWith(subStatus: SubStatus.loading));
       final user = _userCubit.userEntity;
       final firstNotAcceptLesson = _firstNotAcceptLesson(lessons: user.directions[event.currentDirIndex].lessons);
       final listNotAcceptLesson = _getListNotAcceptLesson(lessons: user.directions[event.currentDirIndex].lessons);
      emit(state.copyWith(
          userEntity: user,
          subStatus: SubStatus.loaded,
          firstNotAcceptLesson: firstNotAcceptLesson,
          listNotAcceptLesson: listNotAcceptLesson));
    }on Failure catch(e){
      throw Failure(e.message);
     }
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
      List<Lesson> lessons = event.direction.lessons;
      UserEntity user = _userCubit.userEntity;
      final indexLesson = lessons.indexOf(event.lesson);
      final updatedLesson = event.lesson.copyWith(status: LessonStatus.complete,
          timeAccept: '${event.lesson.date}/12:30');
      lessons.update(indexLesson, updatedLesson);
      final updatedDirection = event.direction.copyWith(lessons: lessons);
      List<Direction> directions = user.directions;
      final indexDirection = directions.indexOf(event.direction);
      directions.update(indexDirection<0?0:indexDirection, updatedDirection);
      final newUser = user.copyWith(directions: directions);
      _userCubit.updateUser(newUser: newUser);

      //todo отнять с баланса сумму за урок

      add(GetUserEvent(currentDirIndex: indexDirection<0?0:indexDirection));
    }on Failure catch(e){

    }
  }




 }


