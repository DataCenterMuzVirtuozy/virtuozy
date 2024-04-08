

 import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtuozy/di/locator.dart';
import 'package:virtuozy/domain/entities/user_entity.dart';
import 'package:virtuozy/domain/user_cubit.dart';
import 'package:virtuozy/presentations/student/subscription_screen/bloc/sub_event.dart';
import 'package:virtuozy/presentations/student/subscription_screen/bloc/sub_state.dart';

import 'package:virtuozy/utils/failure.dart';
import 'package:virtuozy/utils/update_list_ext.dart';

import '../../../../domain/entities/lesson_entity.dart';


class SubBloc extends Bloc<SubEvent,SubState>{
  SubBloc():super(SubState.unknown()){
    on<GetUserEvent>(_getUser);
    on<AcceptLessonEvent>(_acceptLesson);
    on<NotAcceptLessonEvent>(_notAcceptLesson);
    on<UpdateUserEvent>(_updateUser);
    on<ActivateBonusEvent>(_activateBonus);
  }


  final _userCubit = locator.get<UserCubit>();


  void _getUser(GetUserEvent event,emit) async {
     try{
       if(event.refreshDirection){
         emit(state.copyWith(subStatus: SubStatus.loading));
         await Future.delayed(const Duration(milliseconds: 1500));
       }

       final user = _userCubit.userEntity;
       if(user.userStatus.isAuth){
         print('U1');
         final firstNotAcceptLesson = _firstNotAcceptLesson(user: user,indexDir: event.currentDirIndex,allViewDir: event.allViewDir);
         final listNotAcceptLesson = _getListNotAcceptLesson(user: user,indexDir: event.currentDirIndex,allViewDir: event.allViewDir);
         final lessons = _getAllLessons(user, event.allViewDir, event.currentDirIndex);
         final directions = _getDirections(user: user,indexDir: event.currentDirIndex,allViewDir: event.allViewDir);
         final bonuses = _getBonuses(user: user,indexDir: event.currentDirIndex,allViewDir: event.allViewDir);
         final titlesDrawingMenu = _getTitlesDrawingMenu(directions: user.directions);
         emit(state.copyWith(
             titlesDrawingMenu: titlesDrawingMenu,
             bonuses: bonuses,
             userEntity: user,
             lessons: lessons,
             directions: directions,
             subStatus: SubStatus.loaded,
             firstNotAcceptLesson: firstNotAcceptLesson,
             listNotAcceptLesson: listNotAcceptLesson));
         _listenUser(event);
       }else{
         print('U2');
         emit(state.copyWith( subStatus: SubStatus.loaded));
       }




    }on Failure catch(e){
      throw Failure(e.message);
     }
  }

  void _listenUser(GetUserEvent event) {
     _userCubit.stream.listen((user) async {
       add(UpdateUserEvent(currentDirIndex: event.currentDirIndex, user: user,allViewDir: event.allViewDir));
     });
  }

  List<String> _getTitlesDrawingMenu({required List<DirectionLesson> directions}){
    List<String> resultList = [];
    //directions.sort((a,b)=>b.lastSubscription.balanceSub.compareTo(a.lastSubscription.balanceSub));
    resultList = directions.map((e) => e.name).toList();
    int length = resultList.length;
    if(length>1){
      resultList.insert(length, 'Все направления'.tr());
    }
    return resultList;
  }


  List<BonusEntity> _getBonuses({required UserEntity user, required indexDir,required bool allViewDir}){
    List<BonusEntity> resultList = [];
    if(allViewDir){
      for(var dir in user.directions){
        resultList.addAll(dir.bonus);
      }
    }else{
      if(user.directions[indexDir].bonus.isEmpty){
        resultList = [BonusEntity.unknown()];
      }else{
        resultList = user.directions[indexDir].bonus;
      }

    }

    return resultList;
  }

  List<DirectionLesson> _getDirections({required UserEntity user, required indexDir,required bool allViewDir}){
    if(allViewDir){
      return user.directions;
    }
    return [user.directions[indexDir]];
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


  void _updateUser(UpdateUserEvent event,emit) async {
    final firstNotAcceptLesson = _firstNotAcceptLesson(user: event.user,allViewDir: event.allViewDir,indexDir: event.currentDirIndex);
    final listNotAcceptLesson = _getListNotAcceptLesson(user: event.user,allViewDir: event.allViewDir,indexDir: event.currentDirIndex);
    final lessons = _getAllLessons(event.user, event.allViewDir, event.currentDirIndex);
    final directions = _getDirections(user: event.user,indexDir: event.currentDirIndex,allViewDir: event.allViewDir);
    final bonuses = _getBonuses(user: event.user,indexDir: event.currentDirIndex,allViewDir: event.allViewDir);
    final titlesDrawingMenu = _getTitlesDrawingMenu(directions: event.user.directions);
    emit(state.copyWith(
        titlesDrawingMenu: titlesDrawingMenu,
        bonuses: bonuses,
        userEntity: event.user,
        lessons: lessons,
        directions: directions,
        subStatus: SubStatus.loaded,
        firstNotAcceptLesson: firstNotAcceptLesson,
        listNotAcceptLesson: listNotAcceptLesson));
  }


  Lesson _firstNotAcceptLesson({required UserEntity user, required indexDir,required bool allViewDir}){
    if(!allViewDir){
      final list = user.directions[indexDir].lessons.where((element) => element.status == LessonStatus.awaitAccept).toList();
      if(list.isNotEmpty){
        final listDateEpoch = list.map((e) => DateFormat('yyyy-MM-dd').parse(e.date).millisecondsSinceEpoch).toList();
        final indexLessonFirst = listDateEpoch.indexOf(listDateEpoch.reduce(min));
        return list[indexLessonFirst];
      }
    }else{
      List<Lesson> allLes =[];
      for(var dir in user.directions){
        allLes.addAll(dir.lessons);
      }
      final list = allLes.where((element) => element.status == LessonStatus.awaitAccept).toList();
      if(list.isNotEmpty){
        final listDateEpoch = list.map((e) => DateFormat('yyyy-MM-dd').parse(e.date).millisecondsSinceEpoch).toList();
        final indexLessonFirst = listDateEpoch.indexOf(listDateEpoch.reduce(min));
        return list[indexLessonFirst];
      }
    }

    return Lesson.unknown();

  }

  List<Lesson> _getListNotAcceptLesson({required UserEntity user, required indexDir,required bool allViewDir}){
    if(allViewDir){
      List<Lesson> allLes = [];
      for(var dir in user.directions){
        allLes.addAll(dir.lessons);
     }
     return allLes.where((element) => element.status == LessonStatus.awaitAccept).toList();
  }

    return user.directions[indexDir].lessons.where((element) => element.status == LessonStatus.awaitAccept).toList();
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
      emit(state.copyWith(subStatus: SubStatus.confirm,lessonConfirm:event.lesson));

    }on Failure catch(e){

    }
  }

  void _notAcceptLesson(NotAcceptLessonEvent event,emit) async {
    try{
      // emit(state.copyWith(subStatus: SubStatus.confirmation));
      // await Future.delayed(const Duration(seconds: 2));
      final dateNow = DateTime.now().toUtc().toString();
      List<Lesson> lessons = event.direction.lessons;
      UserEntity user = _userCubit.userEntity;
      final indexLesson = lessons.indexOf(event.lesson);
      final updatedLesson = event.lesson.copyWith(status: LessonStatus.cancel,
          timeAccept: dateNow);
      lessons.update(indexLesson, updatedLesson);
      final updatedDirection = event.direction.copyWith(lessons: lessons);
      List<DirectionLesson> directions = user.directions;
      final indexDirection = directions.indexOf(event.direction);
      directions.update(indexDirection<0?0:indexDirection, updatedDirection);
      final newUser = user.copyWith(directions: directions);
      _userCubit.updateUser(newUser: newUser);
      //emit(state.copyWith(subStatus: SubStatus.confirm));

    }on Failure catch(e){

    }
  }



  void _activateBonus(ActivateBonusEvent event,emit) async {
    try{
      emit(state.copyWith(bonusStatus: BonusStatus.loading));
      await Future.delayed(const Duration(seconds: 2));
      List<BonusEntity> listBonusNew = [];
      UserEntity user = _userCubit.userEntity;
      final listBonus = event.direction.bonus;
      final bonus =  event.direction.bonus.firstWhere((element) => element.id == event.idBonus);
      final indexBonus = listBonus.indexOf(bonus);
      if(event.activate){
         listBonusNew = listBonus.update(indexBonus, bonus.copyWith(active: true));
      }else{
        listBonus.removeAt(indexBonus);
        listBonusNew = listBonus;
      }
      final updatedDirection = event.direction.copyWith(bonus: listBonusNew);
      List<DirectionLesson> directions = user.directions;
      final indexDirection = directions.indexOf(event.direction);
      directions.update(indexDirection<0?0:indexDirection, updatedDirection);
      final newUser = user.copyWith(directions: directions);
      _userCubit.updateUser(newUser: newUser);
      emit(state.copyWith(bonusStatus: BonusStatus.activate));
    } on Failure catch(e){
      emit(state.copyWith(bonusStatus: BonusStatus.error,error: e.message));
    }

  }




 }


