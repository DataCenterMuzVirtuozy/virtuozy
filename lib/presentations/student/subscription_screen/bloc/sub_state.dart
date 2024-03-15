

import 'package:equatable/equatable.dart';

import '../../../../domain/entities/lesson_entity.dart';
import '../../../../domain/entities/user_entity.dart';


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
  final List<BonusEntity> bonuses;
  final List<String> titlesDrawingMenu;
  final Lesson lessonConfirm;


 factory SubState.unknown(){
  return SubState(
    lessonConfirm: Lesson.unknown(),
    titlesDrawingMenu: const [],
    bonuses: const [],
    directions: const [],
      lessons: const [],
    bonusStatus: BonusStatus.unknown,
    listNotAcceptLesson: const [],
      subStatus: SubStatus.unknown,
      error: '',
      userEntity: UserEntity.unknown(),
      firstNotAcceptLesson: Lesson.unknown());
 }

  const SubState({
    required this.lessonConfirm,
    required this.titlesDrawingMenu,
    required this.bonuses,
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
  List<Object?> get props => [lessonConfirm,lessons,bonusStatus,subStatus,error,userEntity,firstNotAcceptLesson,listNotAcceptLesson,directions,titlesDrawingMenu];

  SubState copyWith({
    BonusStatus? bonusStatus,
    SubStatus? subStatus,
    String? error,
    UserEntity? userEntity,
    Lesson? firstNotAcceptLesson,
     List<Lesson>? listNotAcceptLesson,
    List<Lesson>? lessons,
    List<DirectionLesson>? directions,
    List<BonusEntity>? bonuses,
    List<String>? titlesDrawingMenu,
    Lesson? lessonConfirm
  }) {
    return SubState(
      lessonConfirm: lessonConfirm??this.lessonConfirm,
      titlesDrawingMenu:titlesDrawingMenu??this.titlesDrawingMenu,
      bonuses: bonuses??this.bonuses,
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