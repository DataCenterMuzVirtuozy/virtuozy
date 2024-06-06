
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
  reschedule,
  unknown,

}

enum LessonType{
  trial,
  group,
  singly,
  unknown

}


class Lesson{
  final int id;
  final int idTeacher;
  final String idSchool;
  final String date; //2024-12-22
  final String timePeriod;
  final String timeAccept;
  final String idAuditory;
  final String nameTeacher;
  final String nameStudent;
  final LessonStatus status;
  final LessonType type;
  final String nameDirection;
  final int idSub;
  final bool bonus;
  final bool online;
  final int duration;
  final bool alien;  //чужой урок
  final List<dynamic> contactValues;
  final String comments;
  final String nameSub;

  const Lesson({
    required this.nameSub,
    required this.comments,
    required this.duration,
    required this.online,
    required this.idTeacher,
    required this.type,
    required this.alien,
    required this.contactValues,
    required this.id,
    required this.idSub,
    required this.idSchool,
    required this.bonus,
    required this.timeAccept,
    required this.date,
    required this.timePeriod,
    required this.idAuditory,
    required this.nameTeacher,
    required this.nameStudent,
    required this.status,
    required this.nameDirection
  });


  factory Lesson.unknown(){
    return const Lesson(
      duration: 0,
      nameSub: '',
      comments: '',
      online: false,
      idTeacher: 0,
      type: LessonType.unknown,
      alien: false,
      contactValues: [],
        idSub:0,
        bonus:false,
        nameDirection: '',
        timeAccept: '',
        date: '',
        timePeriod: '',
        idAuditory: '',
        nameTeacher: '',
        status: LessonStatus.unknown,
        id: 0,
        nameStudent: '',
        idSchool: '');
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
    String? nameStudent,
    String? idSchool,
    List<String>? contactValues,
    bool? alien,
    LessonType? type,
    int? idTeacher,
    bool? online,
    String? nameSub,
    String? comments,
    int? duration
  }) {
    return Lesson(
      duration: duration??this.duration,
      nameSub: nameSub??this.nameSub,
      comments: comments??this.comments,
      online: online??this.online,
      idTeacher: idTeacher??this.idTeacher,
      type: type??this.type,
      alien: alien??this.alien,
      contactValues: contactValues??this.contactValues,
      idSchool: idSchool??this.idSchool,
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
      nameStudent: nameStudent??this.nameStudent,
    );
  }
}
