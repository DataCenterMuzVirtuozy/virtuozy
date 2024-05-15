


 import 'package:virtuozy/data/models/user_model.dart';

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

     final lessons = mapLessons.map((e) => LessonModel.fromMap(e,'')).toList();


    return TeacherModel(
      lessons: lessons,
      id: mapTeacher['id'] as int,
      lastName: mapTeacher['lastName'] as String,
      firstName: mapTeacher['firstName'] as String,
      phoneNum: mapTeacher['phoneNum'] as String,
    );
  }
}