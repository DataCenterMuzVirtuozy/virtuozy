

import 'package:equatable/equatable.dart';

import '../../../domain/entities/user_entity.dart';

enum SubStatus{
 loading,
 error,
 unknown,
 loaded
}

 class SubState extends Equatable{

  final SubStatus subStatus;
  final String error;
  final int lengthNotAcceptLesson;
  final UserEntity userEntity;


 factory SubState.unknown(){
  return SubState(
      subStatus: SubStatus.unknown,
      error: '',
      userEntity: UserEntity.unknown(),
      lengthNotAcceptLesson: 0);
 }

  const SubState({
    required this.lengthNotAcceptLesson,
    required this.subStatus,
    required this.error,
    required this.userEntity,
  });

  @override
  List<Object?> get props => [subStatus,error,userEntity];

  SubState copyWith({
    SubStatus? subStatus,
    String? error,
    UserEntity? userEntity,
    int? lengthNotAcceptLesson
  }) {
    return SubState(
      lengthNotAcceptLesson: lengthNotAcceptLesson??this.lengthNotAcceptLesson,
      subStatus: subStatus ?? this.subStatus,
      error: error ?? this.error,
      userEntity: userEntity ?? this.userEntity,
    );
  }
}