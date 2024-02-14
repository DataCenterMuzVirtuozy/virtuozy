


 import 'package:virtuozy/domain/entities/user_entity.dart';

class ScheduleLessons{
  final String month;
  final List<Lesson> lessons;

  const ScheduleLessons({
    required this.month,
    required this.lessons,
  });

  factory ScheduleLessons.unknown(){
    return const ScheduleLessons(month: '', lessons: []);
  }
}