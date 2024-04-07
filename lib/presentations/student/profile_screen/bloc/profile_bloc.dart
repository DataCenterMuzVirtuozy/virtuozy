


 import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtuozy/di/locator.dart';
import 'package:virtuozy/domain/repository/user_repository.dart';
import 'package:virtuozy/domain/user_cubit.dart';
import 'package:virtuozy/presentations/student/profile_screen/bloc/profile_event.dart';
import 'package:virtuozy/presentations/student/profile_screen/bloc/profile_state.dart';
import 'package:virtuozy/utils/failure.dart';

class ProfileBloc extends Bloc<ProfileEvent,ProfileState>{
  ProfileBloc():super(ProfileState.unknown()){
    on<GetDataUserEvent>(_getDataUser);
    on<SaveNewDataUserEvent>(_saveNewUserData);
  }

  final _user = locator.get<UserCubit>();
  final _userRepository = locator.get<UserRepository>();

  void _getDataUser(GetDataUserEvent event,emit) async {
    try{
      emit(state.copyWith(profileStatus: ProfileStatus.loading));
      await Future.delayed(const Duration(seconds: 1));
      emit(state.copyWith(profileStatus: ProfileStatus.loaded,userEntity: _user.userEntity));
    }on Failure catch(e){
     emit(state.copyWith(profileStatus: ProfileStatus.error,error: e.message));
    }
  }


  void _saveNewUserData(SaveNewDataUserEvent event,emit) async {
   try{
    emit(state.copyWith(profileStatus: ProfileStatus.saving));
    await Future.delayed(const Duration(seconds: 1));
    emit(state.copyWith(profileStatus: ProfileStatus.saved,userEntity: _user.userEntity));
   }on Failure catch(e){
    emit(state.copyWith(profileStatus: ProfileStatus.error,error: e.message));
   }
  }

 }