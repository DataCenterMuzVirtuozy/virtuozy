


  import 'package:equatable/equatable.dart';

class TodayScheduleEvent extends Equatable{
  @override
  List<Object?> get props => [];

  const TodayScheduleEvent();
}

class GetIdsSchoolEvent extends TodayScheduleEvent{}
  class GetLessonsByIdSchoolEvent extends TodayScheduleEvent{
  final String id;

  const GetLessonsByIdSchoolEvent(this.id);
}