

import 'package:equatable/equatable.dart';

import '../../../domain/entities/user_entity.dart';

enum SubStatus{
 loading,
 error,
 unknown,
  confirmation,
  confirm,
 loaded
}

enum BonusStatus{
  loading,
  loaded,
  activate,
  error,
  unknown
}

 class SubState extends Equatable{

  final SubStatus subStatus;
  final BonusStatus bonusStatus;
  final String error;
  final Lesson firstNotAcceptLesson;
  final List<Lesson> listNotAcceptLesson;
  final UserEntity userEntity;


 factory SubState.unknown(){
  return SubState(
    bonusStatus: BonusStatus.unknown,
    listNotAcceptLesson: const [],
      subStatus: SubStatus.unknown,
      error: '',
      userEntity: UserEntity.unknown(),
      firstNotAcceptLesson: Lesson.unknown());
 }

  const SubState({
    required  this.bonusStatus,
    required this.listNotAcceptLesson,
    required this.firstNotAcceptLesson,
    required this.subStatus,
    required this.error,
    required this.userEntity,
  });

  @override
  List<Object?> get props => [bonusStatus,subStatus,error,userEntity,firstNotAcceptLesson,listNotAcceptLesson];

  SubState copyWith({
    BonusStatus? bonusStatus,
    SubStatus? subStatus,
    String? error,
    UserEntity? userEntity,
    Lesson? firstNotAcceptLesson,
     List<Lesson>? listNotAcceptLesson
  }) {
    return SubState(
      listNotAcceptLesson: listNotAcceptLesson??this.listNotAcceptLesson,
      firstNotAcceptLesson: firstNotAcceptLesson??this.firstNotAcceptLesson,
      subStatus: subStatus ?? this.subStatus,
      error: error ?? this.error,
      userEntity: userEntity ?? this.userEntity,
      bonusStatus: bonusStatus??this.bonusStatus,
    );
  }
}