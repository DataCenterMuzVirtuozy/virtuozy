


  import 'package:equatable/equatable.dart';
import 'package:virtuozy/domain/entities/lesson_entity.dart';

class TodayScheduleEvent extends Equatable{
  @override
  List<Object?> get props => [];

  const TodayScheduleEvent();
}

class GetTodayLessonsEvent extends TodayScheduleEvent{
  const GetTodayLessonsEvent();
}

class AddLessonFromScheduleEvent extends TodayScheduleEvent{
  final Lesson lesson;
  const AddLessonFromScheduleEvent({required this.lesson});
}


  class GetLessonsByIdSchoolEvent extends TodayScheduleEvent{
  final String id;

  const GetLessonsByIdSchoolEvent(this.id);
}

 class GetLessonsBySelDateEvent extends TodayScheduleEvent{
   final String date;
   const GetLessonsBySelDateEvent({required this.date});
 }

 class GetLessonsByModeViewEvent extends TodayScheduleEvent{
  final bool onlyWithLesson;
  const GetLessonsByModeViewEvent({required this.onlyWithLesson});
 }