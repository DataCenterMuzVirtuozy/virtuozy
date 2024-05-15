



 import 'lesson_entity.dart';

class TeacherEntity{

   final int id;
   final String lastName;
   final String firstName;
   final String phoneNum;
   final List<Lesson> lessons;

   const TeacherEntity({
    required this.id,
    required this.lastName,
    required this.firstName,
    required this.phoneNum,
     required this.lessons
  });


   factory TeacherEntity.unknown(){
    return const TeacherEntity(id: 0, lastName: '', firstName: '', phoneNum: '',lessons: []);
   }


   TeacherEntity copyWith({
    int? id,
    String? lastName,
    String? firstName,
    String? phoneNum,
     List<Lesson>? lessons
  }) {
    return TeacherEntity(
      lessons: lessons??this.lessons,
      id: id ?? this.id,
      lastName: lastName ?? this.lastName,
      firstName: firstName ?? this.firstName,
      phoneNum: phoneNum ?? this.phoneNum,
    );
  }
}