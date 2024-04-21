


 import 'package:equatable/equatable.dart';
import 'package:virtuozy/domain/entities/subway_entity.dart';
import 'package:virtuozy/domain/entities/user_entity.dart';

enum ProfileStatus{
   loading,loaded,
  error,
  saving,
  saved,
 unknown
 }

 enum FindSubwaysStatus{
  loading,
   loaded,
   error,
   unknown
 }

 class ProfileState extends Equatable{


  final ProfileStatus profileStatus;
  final FindSubwaysStatus findSubwaysStatus;
  final UserEntity userEntity;
  final List<SubwayEntity> subways;
  final SubwayEntity addedSubway;
  final String error;


  @override
  List<Object?> get props => [profileStatus,error,userEntity,findSubwaysStatus,subways,addedSubway];

  const ProfileState( {
    required this.addedSubway,
    required this.subways,
    required this.findSubwaysStatus,
    required this.profileStatus,
    required this.userEntity,
    required this.error,
  });


 factory ProfileState.unknown(){
  return ProfileState(

      profileStatus: ProfileStatus.unknown,
      userEntity: UserEntity.unknown(),
      error: '',findSubwaysStatus: FindSubwaysStatus.unknown,
      subways:  const [], addedSubway: SubwayEntity.unknown());
 }

  ProfileState copyWith({
    ProfileStatus? profileStatus,
    UserEntity? userEntity,
    String? error,
    List<SubwayEntity>? subways,
    FindSubwaysStatus? findSubwaysStatus,
    SubwayEntity? addedSubway,
  }) {
    return ProfileState(
      addedSubway: addedSubway??this.addedSubway,
      subways: subways??this.subways,
      profileStatus: profileStatus ?? this.profileStatus,
      userEntity: userEntity ?? this.userEntity,
      error: error ?? this.error,
      findSubwaysStatus: findSubwaysStatus??this.findSubwaysStatus,
    );
  }
}