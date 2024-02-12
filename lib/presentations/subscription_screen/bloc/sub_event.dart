


 import 'package:equatable/equatable.dart';
import 'package:virtuozy/domain/entities/user_entity.dart';




class SubEvent extends Equatable{
  @override

  List<Object?> get props => [];
  const SubEvent();

}

class GetUserEvent extends SubEvent{
  final int currentDirIndex;

  const GetUserEvent({required this.currentDirIndex});
}

class AcceptLessonEvent extends SubEvent{
  final Lesson lesson;
  final Direction direction;

  const AcceptLessonEvent({
    required this.direction,
    required this.lesson});

}

class UpdateUserEvent extends SubEvent{
  final int currentDirIndex;
  final UserEntity user;

  const UpdateUserEvent({
    required this.currentDirIndex,
    required this.user,
  });
}