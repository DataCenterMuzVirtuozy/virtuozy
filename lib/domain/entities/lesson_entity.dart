
enum LessonStatus{
  planned,
  complete,
  out,
  cancel,
  trial,
  reservation,
  singly,
  awaitAccept,
  layering,
  firstLesson,
  lastLesson,
  unknown
}


class Lesson{
  final int id;
  final String date; //2024-12-22
  final String timePeriod;
  final String timeAccept;
  final String idAuditory;
  final String nameTeacher;
  final LessonStatus status;
  final String nameDirection;
  final int idSub;
  final bool bonus;

  const Lesson({
    required this.id,
    required this.idSub,
    required this.bonus,
    required this.timeAccept,
    required this.date,
    required this.timePeriod,
    required this.idAuditory,
    required this.nameTeacher,
    required this.status,
    required this.nameDirection
  });


  factory Lesson.unknown(){
    return const Lesson(
        idSub:0,
        bonus:false,
        nameDirection: '',
        timeAccept: '',
        date: '',
        timePeriod: '',
        idAuditory: '',
        nameTeacher: '',
        status: LessonStatus.unknown,
        id: 0);
  }

  Lesson copyWith({
    String? date,
    String? timePeriod,
    String? idAuditory,
    String? nameTeacher,
    LessonStatus? status,
    String? timeAccept,
    String? nameDirection,
    int? idSub,
    bool? bonus,
  }) {
    return Lesson(
      idSub: idSub??this.idSub,
      bonus: bonus??this.bonus,
      nameDirection: nameDirection??this.nameDirection,
      timeAccept: timeAccept??this.timeAccept,
      date: date ?? this.date,
      timePeriod: timePeriod ?? this.timePeriod,
      idAuditory: idAuditory ?? this.idAuditory,
      nameTeacher: nameTeacher ?? this.nameTeacher,
      status: status ?? this.status,
      id: id,
    );
  }
}
