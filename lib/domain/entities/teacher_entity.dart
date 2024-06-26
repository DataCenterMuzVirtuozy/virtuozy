



 import 'package:virtuozy/domain/entities/user_entity.dart';

import 'lesson_entity.dart';

class TeacherEntity{

   final int id;
   final String lastName;
   final String firstName;
   final String phoneNum;
   final List<Lesson> lessons;
   final String urlAva;
   final UserStatus userStatus;
   final List<dynamic> directions;

   const TeacherEntity( {
     required this.directions,
     required this.userStatus,
     required this.urlAva,
    required this.id,
    required this.lastName,
    required this.firstName,
    required this.phoneNum,
     required this.lessons
  });


   factory TeacherEntity.unknown(){
    return const TeacherEntity(
      directions: [],
        urlAva:'',id: 0, lastName: '', firstName: '', phoneNum: '',lessons: [],userStatus: UserStatus.notAuth);
   }


   TeacherEntity copyWith({
    int? id,
    String? lastName,
    String? firstName,
    String? phoneNum,
     List<Lesson>? lessons,
     String? urlAva,
     UserStatus? userStatus,
     List<String>? directions
  }) {
    return TeacherEntity(
      directions: directions??this.directions,
      userStatus: userStatus??this.userStatus,
      urlAva: urlAva??this.urlAva,
      lessons: lessons??this.lessons,
      id: id ?? this.id,
      lastName: lastName ?? this.lastName,
      firstName: firstName ?? this.firstName,
      phoneNum: phoneNum ?? this.phoneNum,
    );
  }
}