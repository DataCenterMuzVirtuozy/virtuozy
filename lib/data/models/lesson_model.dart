import '../../utils/date_time_parser.dart';

class LessonModel{
  final String nameGroup;
  final int id;
  final int idStudent;
  final int idSub;
  final int idDir;
  final String idSchool;
  final String date; //2024-12-22
  final String timePeriod;
  final String idAuditory;
  final String nameTeacher;
  final String nameStudent;
  final int status;
  final int type;
  final String timeAccept;
  final String nameDirection;
  final bool bonus;
  final int idTeacher;
  final List<dynamic> contactValues;
  final String comments;
  final String nameSub;
  final bool online;
  final int duration;
  final bool isFirst;
  final bool isLast;
  final String nameAuditory;
  final String nameSchool;
  final int number;



  const LessonModel( {
    required this.number,
    required this.nameSchool,
    required this.nameAuditory,
    required this.isFirst,
    required this.isLast,
    required this.nameGroup,
    required this.idStudent,
    required this.nameSub,
    required this.comments,
    required this.duration,
    required this.online,
    required this.type,
    required this.idTeacher,
    required this.contactValues,
    required this.idDir,
    required this.idSchool,
    required this.nameStudent,
    required this.nameDirection,
    required this.id,
    required this.idSub,
    required this.timeAccept,
    required this.date,
    required this.timePeriod,
    required this.idAuditory,
    required this.nameTeacher,
    required this.status,
    required this.bonus
  });

  static Map<String,dynamic> toMap(LessonModel lessonModel){
    //todo add new field
    return {
      'nameGroup':lessonModel.nameGroup,
      'online':lessonModel.online,
      'comments':lessonModel.comments,
      'nameSub':lessonModel.nameSub,
      'duration':lessonModel.duration,
      'type':lessonModel.type,
      'contactValues': lessonModel.contactValues,
      'idDir':lessonModel.idDir,
      'idSchool':lessonModel.idSchool,
      'idSub':lessonModel.idSub,
      'timeAccept':lessonModel.timeAccept,
      'date':lessonModel.date,
      'timePeriod':lessonModel.timePeriod,
      'idTeacher':lessonModel.idTeacher,
      'idAuditory':lessonModel.idAuditory,
      'nameTeacher':lessonModel.nameTeacher,
      'nameDir':lessonModel.nameDirection,
      'nameStudent':lessonModel.nameStudent,
      'idStudent': lessonModel.idStudent,
      'status':lessonModel.status
    };
  }

  factory LessonModel.fromMap(Map<String, dynamic> map,String nameDirection) {
    final idStudent = map['idStudent'];
    final idSub = map['idSub'];
    final idTeacher = map['idTeacher'];
    final status = map['status'];
    final bonus =map['bonus']??false;
    final date = map['date'] as String;
    final dateStart = date.split(' ')[0];
    final idSchool =  map['idSchool'].toString();
    final type = map['type']??'10';
    final duration = map['timePeriod']??'0';
    final timePeriod = DateTimeParser.parseTimePeriod(period: duration, date: date);

    return LessonModel(
      number: map['number']??0,
      nameSchool: map['nameSchool']??'',
        nameAuditory: map['nameAuditory']??'',
        isFirst: map['isFirst']??false,
        isLast: map['isLast']??false,
        nameGroup: map['nameGroup']??'', //absent  from api
        idStudent: idStudent,
        online: map['online']??false, //absent from api
        comments: map['comments']??'...', //absent from api
        nameSub: map['nameSub']??'...', //absent from api
        duration: int.parse(duration), //['duration']??60, //absent from api
        type: int.parse(type),
        contactValues: map['contactValues']??[], //absent from api
        idDir: map['idDir']??1, //absent from api
        idSchool: idSchool,
        idSub: idSub,
        id: map['id']??0,
        timeAccept: map['timeAccept']??'',
        date: dateStart,
        timePeriod: timePeriod,
        idTeacher: idTeacher,
        idAuditory: map['idAuditory']??'',
        nameTeacher: map['nameTeacher']??'',
        status: status,
        nameDirection: map['nameDir']??'', //absent from api
        bonus: bonus,
        nameStudent: map['nameStudent']??''
    );
  }
}
