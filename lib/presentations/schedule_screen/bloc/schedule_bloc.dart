


 import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtuozy/di/locator.dart';
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
      // emit(state.copyWith(status: ScheduleStatus.loading));
      // await Future.delayed(const Duration(milliseconds: 1500));
      final user = _userCubit.userEntity;
      emit(state.copyWith(status: ScheduleStatus.loaded,user: user));
     _listenUser();

     }on Failure catch(e){

     }



  }


  void _listenUser() {
    _userCubit.stream.listen((user) async {
      add(UpdateUserEvent(currentDirIndex: 0, user: user));
    });
  }


  void _updateUser(UpdateUserEvent event,emit) async {
    emit(state.copyWith(status: ScheduleStatus.loaded,user: event.user));
  }









}