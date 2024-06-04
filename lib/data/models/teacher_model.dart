import 'package:virtuozy/data/models/user_model.dart';

class TeacherModel {
  final int id;
  final String lastName;
  final String firstName;
  final String phoneNum;
  final List<LessonModel> lessons;
  final String urlAva;

  const TeacherModel(
      {required this.urlAva,
      required this.id,
      required this.lastName,
      required this.firstName,
      required this.phoneNum,
      required this.lessons});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'lastName': lastName,
      'firstName': firstName,
      'phoneNum': phoneNum,
    };
  }

  factory TeacherModel.fromMap(
      {required Map<String, dynamic> mapTeacher,
      required List<dynamic> mapLessons}) {
    final lessons = mapLessons.map((e) => LessonModel.fromMap(e, '')).toList();

    return TeacherModel(
      // lessons: l,
      // id: 0,
      // lastName: 'Go',
      //   firstName: 'ff',
      // phoneNum: '9009'
      lessons: lessons,
      urlAva: mapTeacher['urlAva'] as String,
      id: mapTeacher['id'] as int,
      lastName: mapTeacher['lastName'] as String,
      firstName: mapTeacher['firstName'] as String,
      phoneNum: mapTeacher['phoneNum'] as String,
    );
  }

  static final l = [
    const LessonModel(
        contactValues: ['', ''],
        id: 33,
        idSub: 33,
        idSchool: 'мш2',
        bonus: false,
        timeAccept: '',
        date: '2024-05-16',
        timePeriod: '15:00-16:00',
        idAuditory: 'Свинг',
        nameTeacher: 'Bob',
        nameStudent: 'Dan',
        status: 6,
        nameDirection: 'Bass',
        idDir: 0),
    const LessonModel(
        contactValues: [],
        idDir: 0,
        idSchool: 'мш1',
        nameStudent: 'Петя Тяпкин',
        nameDirection: '',
        id: 0,
        idSub: 0,
        timeAccept: '',
        date: '2024-05-21',
        timePeriod: '12:00-13:00',
        idAuditory: 'Свинг',
        nameTeacher: "Мария Белова",
        status: 2,
        bonus: false),
    const LessonModel(
        contactValues: [],
        idDir: 0,
        idSchool: 'мш1',
        nameStudent: 'Петя Тяпкин',
        nameDirection: '',
        id: 0,
        idSub: 0,
        timeAccept: '',
        date: '2024-05-23',
        timePeriod: '14:00-15:00',
        idAuditory: 'Опера',
        nameTeacher: "Мария Белова",
        status: 4,
        bonus: false)
  ];
}
