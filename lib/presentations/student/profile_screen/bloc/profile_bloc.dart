


 import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtuozy/di/locator.dart';
import 'package:virtuozy/domain/entities/edit_profile_entity.dart';
import 'package:virtuozy/domain/entities/user_entity.dart';
import 'package:virtuozy/domain/repository/user_repository.dart';
import 'package:virtuozy/domain/user_cubit.dart';
import 'package:virtuozy/presentations/student/profile_screen/bloc/profile_event.dart';
import 'package:virtuozy/presentations/student/profile_screen/bloc/profile_state.dart';
import 'package:virtuozy/utils/failure.dart';

class ProfileBloc extends Bloc<ProfileEvent,ProfileState>{
  ProfileBloc():super(ProfileState.unknown()){
    on<GetDataUserEvent>(_getDataUser);
    on<SaveNewDataUserEvent>(_saveNewUserData);
    on<GetSubwaysEvent>(_getSubways);
    on<AddSubwayEvent>(_addSubway);
  }

  final _userCubit = locator.get<UserCubit>();
  final _userRepository = locator.get<UserRepository>();


  void _addSubway(AddSubwayEvent event,emit) async {
    try{
      emit(state.copyWith(addedSubway: event.subway));
    }on Failure catch(e){

    }
  }

  void _getSubways(GetSubwaysEvent event,emit) async {
    try{
      emit(state.copyWith(findSubwaysStatus: FindSubwaysStatus.loading));
      final subways = await _userRepository.subways(query: event.query);
      emit(state.copyWith(findSubwaysStatus: FindSubwaysStatus.loaded,subways: subways));
    }on Failure catch(e){
      emit(state.copyWith(findSubwaysStatus: FindSubwaysStatus.error,error: e.message));
    }
  }

  void _getDataUser(GetDataUserEvent event,emit) async {
    try{
      emit(state.copyWith(profileStatus: ProfileStatus.loading));
      await Future.delayed(const Duration(seconds: 1));
      UserEntity user = _userCubit.userEntity;
      emit(state.copyWith(profileStatus: ProfileStatus.loaded,userEntity: user));
    }on Failure catch(e){
     emit(state.copyWith(profileStatus: ProfileStatus.error,error: e.message));
    }
  }


  void _saveNewUserData(SaveNewDataUserEvent event,emit) async {
   try{
     print('dateBirth ${event.editProfileEntity.dateBirth}, hasKind ${event.editProfileEntity.hasKind}, sex ${event.editProfileEntity.sex}, ');
     EditProfileEntity profileEntity = event.editProfileEntity;
     UserEntity user = _userCubit.userEntity;
     emit(state.copyWith(profileStatus: ProfileStatus.saving));
    if(profileEntity.fileImageUrl != null){
      final url = await _userRepository.loadAvaProfile(uid: user.id, profileEntity: event.editProfileEntity);
      profileEntity = profileEntity.copyWith(urlAva: url);
    }
     user = user.copyWith(
       date_birth: profileEntity.dateBirth,
         avaUrl: profileEntity.urlAva,
         has_kids: profileEntity.hasKind,
         sex: profileEntity.sex);
     _userCubit.setUser(user: user);
     await _userRepository.saveSettingDataProfile(uid: user.id, profileEntity: profileEntity);
     emit(state.copyWith(profileStatus: ProfileStatus.saved,userEntity: user));
   }on Failure catch(e){
    emit(state.copyWith(profileStatus: ProfileStatus.error,error: e.message));
   }
  }

 }