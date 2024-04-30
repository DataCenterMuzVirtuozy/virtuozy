


 import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtuozy/di/locator.dart';
import 'package:virtuozy/domain/entities/edit_profile_entity.dart';
import 'package:virtuozy/domain/entities/subway_entity.dart';
import 'package:virtuozy/domain/entities/user_entity.dart';
import 'package:virtuozy/domain/repository/user_repository.dart';
import 'package:virtuozy/domain/user_cubit.dart';
import 'package:virtuozy/presentations/student/profile_screen/bloc/profile_event.dart';
import 'package:virtuozy/presentations/student/profile_screen/bloc/profile_state.dart';
import 'package:virtuozy/utils/failure.dart';

class ProfileBloc extends Bloc<ProfileEvent,ProfileState>{
  ProfileBloc():super(ProfileState.unknown()){
    on<GetDataUserProfileEvent>(_getDataUser);
    on<SaveNewDataUserEvent>(_saveNewUserData);
    on<GetSubwaysEvent>(_getSubways);
    on<AddSubwayEvent>(_addSubway);
  }

  final _userCubit = locator.get<UserCubit>();
  final _userRepository = locator.get<UserRepository>();


  void _addSubway(AddSubwayEvent event,emit) async {
    try{
      emit(state.copyWith(findSubwaysStatus: FindSubwaysStatus.adding,addedSubway: SubwayEntity.unknown()));
      await Future.delayed(const Duration(milliseconds: 300));
      emit(state.copyWith(addedSubway: event.subway,findSubwaysStatus: FindSubwaysStatus.added));
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

  void _getDataUser(GetDataUserProfileEvent event,emit) async {
    try{
      emit(state.copyWith(profileStatus: ProfileStatus.loading,
          findSubwaysStatus: FindSubwaysStatus.unknown,subways: [],
          addedSubway: SubwayEntity.unknown()));
      await Future.delayed(const Duration(seconds: 1));
      UserEntity user = _userCubit.userEntity;
      emit(state.copyWith(profileStatus: ProfileStatus.loaded,userEntity: user));
    }on Failure catch(e){
     emit(state.copyWith(profileStatus: ProfileStatus.error,error: e.message));
    }
  }


  void _saveNewUserData(SaveNewDataUserEvent event,emit) async {
   try{
     EditProfileEntity profileEdited = event.editProfileEntity;
     UserEntity user = _userCubit.userEntity;
     emit(state.copyWith(profileStatus: ProfileStatus.saving));
    if(profileEdited.fileImageUrl != null){
      final url = await _userRepository.loadAvaProfile(uid: user.id, profileEntity: event.editProfileEntity);
      profileEdited = profileEdited.copyWith(urlAva: url);
    }
     user = user.copyWith(
       about_me: profileEdited.aboutMe,
         subways:profileEdited.subways,
       date_birth: profileEdited.dateBirth,
         avaUrl: profileEdited.urlAva,
         has_kids: profileEdited.hasKind,
         who_find: profileEdited.whoFindTeem,
         sex: profileEdited.sex);
     _userCubit.setUser(user: user);
     await _userRepository.saveSettingDataProfile(uid: user.id, profileEntity: profileEdited);
     emit(state.copyWith(profileStatus: ProfileStatus.saved,userEntity: user));
   }on Failure catch(e){
    emit(state.copyWith(profileStatus: ProfileStatus.error,error: e.message));
   }
  }

 }