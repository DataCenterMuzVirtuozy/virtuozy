

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
  final List<Lesson> lessons;
  final UserEntity userEntity;
  final List<DirectionLesson> directions;


 factory SubState.unknown(){
  return SubState(
    directions: [],
      lessons: [],
    bonusStatus: BonusStatus.unknown,
    listNotAcceptLesson: const [],
      subStatus: SubStatus.unknown,
      error: '',
      userEntity: UserEntity.unknown(),
      firstNotAcceptLesson: Lesson.unknown());
 }

  const SubState({
    required this.directions,
    required this.lessons,
    required  this.bonusStatus,
    required this.listNotAcceptLesson,
    required this.firstNotAcceptLesson,
    required this.subStatus,
    required this.error,
    required this.userEntity,
  });

  @override
  List<Object?> get props => [lessons,bonusStatus,subStatus,error,userEntity,firstNotAcceptLesson,listNotAcceptLesson,directions];

  SubState copyWith({
    BonusStatus? bonusStatus,
    SubStatus? subStatus,
    String? error,
    UserEntity? userEntity,
    Lesson? firstNotAcceptLesson,
     List<Lesson>? listNotAcceptLesson,
    List<Lesson>? lessons,
    List<DirectionLesson>? directions
  }) {
    return SubState(
      directions: directions??this.directions,
      lessons: lessons??this.lessons,
      listNotAcceptLesson: listNotAcceptLesson??this.listNotAcceptLesson,
      firstNotAcceptLesson: firstNotAcceptLesson??this.firstNotAcceptLesson,
      subStatus: subStatus ?? this.subStatus,
      error: error ?? this.error,
      userEntity: userEntity ?? this.userEntity,
      bonusStatus: bonusStatus??this.bonusStatus,
    );
  }
}