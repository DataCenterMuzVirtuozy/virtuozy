


 import 'package:virtuozy/data/models/user_model.dart';
import 'package:virtuozy/domain/entities/lesson_entity.dart';

class TeacherModel{

   final int id;
   final String lastName;
   final String firstName;
   final String phoneNum;
   final List<LessonModel> lessons;

   const TeacherModel({
    required this.id,
    required this.lastName,
    required this.firstName,
    required this.phoneNum,
     required this.lessons
  });

   Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'lastName': this.lastName,
      'firstName': this.firstName,
      'phoneNum': this.phoneNum,
    };
  }

  factory TeacherModel.fromMap({required Map<String, dynamic> mapTeacher,required List<dynamic> mapLessons}) {

     //final lessons = mapLessons.map((e) => LessonModel.fromMap(e,'')).toList();


    return TeacherModel(
      lessons: l,
      id: 0,
      lastName: 'Go',
        firstName: 'ff',
      phoneNum: '9009'
      // id: mapTeacher['id'] as int,
      // lastName: mapTeacher['lastName'] as String,
      // firstName: mapTeacher['firstName'] as String,
      // phoneNum: mapTeacher['phoneNum'] as String,
    );
  }

  static final l = [
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