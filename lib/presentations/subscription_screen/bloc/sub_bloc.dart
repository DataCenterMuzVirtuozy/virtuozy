

 import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtuozy/di/locator.dart';
import 'package:virtuozy/domain/user_cubit.dart';
import 'package:virtuozy/presentations/subscription_screen/bloc/sub_event.dart';
import 'package:virtuozy/presentations/subscription_screen/bloc/sub_state.dart';
import 'package:virtuozy/utils/failure.dart';

import '../../../domain/entities/user_entity.dart';

class SubBloc extends Bloc<SubEvent,SubState>{
  SubBloc():super(SubState.unknown()){
    on<GetUserEvent>(_getUser);
  }


  final _userCubit = locator.get<UserCubit>();


  void _getUser(GetUserEvent event,emit) async {
     try{
      emit(state.copyWith(subStatus: SubStatus.loading));
       final user = _userCubit.userEntity;
       final lengthNotAcceptLesson = _lengthNotAcceptLesson(lessons: user.directions[event.currentDirIndex].lessons);
       emit(state.copyWith(userEntity: user,subStatus: SubStatus.loaded,lengthNotAcceptLesson: lengthNotAcceptLesson));
     }on Failure catch(e){
      throw Failure(e.message);
     }
  }


  int _lengthNotAcceptLesson({required List<Lesson> lessons}){
    return lessons.where((element) => element.status == LessonStatus.awaitAccept).length;
  }

 }