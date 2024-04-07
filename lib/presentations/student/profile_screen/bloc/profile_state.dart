


 import 'package:equatable/equatable.dart';
import 'package:virtuozy/domain/entities/user_entity.dart';

enum ProfileStatus{
   loading,loaded,
  error,
  saving,
  saved,
 unknown
 }

 class ProfileState extends Equatable{


  final ProfileStatus profileStatus;
  final UserEntity userEntity;
  final String error;


  @override
  List<Object?> get props => [profileStatus,error,userEntity];

  const ProfileState({
    required this.profileStatus,
    required this.userEntity,
    required this.error,
  });


 factory ProfileState.unknown(){
  return ProfileState(profileStatus: ProfileStatus.unknown, userEntity: UserEntity.unknown(), error: '');
 }

  ProfileState copyWith({
    ProfileStatus? profileStatus,
    UserEntity? userEntity,
    String? error,
  }) {
    return ProfileState(
      profileStatus: profileStatus ?? this.profileStatus,
      userEntity: userEntity ?? this.userEntity,
      error: error ?? this.error,
    );
  }
}