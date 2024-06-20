
 import 'package:virtuozy/domain/entities/lesson_entity.dart';




class LidsEntity{

  final String name;
  final String dateCreated;
  final String nameDir;
  final String dateTrial;
  final String dateLastLesson;
  final LessonStatus lessonLastStatus;
  final String idSchool;

  LidsEntity(
      {required this.name,
      required this.dateCreated,
      required this.nameDir,
      required this.dateTrial,
      required this.dateLastLesson,
      required this.lessonLastStatus,
      required this.idSchool});


}