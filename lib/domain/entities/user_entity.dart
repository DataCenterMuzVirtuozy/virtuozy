
 enum UserStatus{
  notAuth,
   auth,
   moderation
 }

 enum UserType{
   teacher,
   student,
   unknown
 }

 extension UserTypeExt on UserType{
   bool get isTeacher => this == UserType.teacher;
   bool get isStudent => this == UserType.student;
 }


 extension UserStatusExt on UserStatus{
  bool get isModeration => this==UserStatus.moderation;
  bool get isAuth => this == UserStatus.auth;
  bool get isNotAuth => this == UserStatus.notAuth;
 }

 class UserEntity{

   final String lastName;
   final String firstName;
   final String branchName;
   final String phoneNumber;
   final UserStatus userStatus;
   final UserType userType;
   final List<Direction> directions;

   const UserEntity({
     required this.userType,
     required this.userStatus,
     required this.lastName,
    required this.firstName,
    required this.branchName,
    required this.phoneNumber,
     required this.directions
  });


   factory UserEntity.unknown() {
    return const UserEntity(
        directions: [],
        userType: UserType.unknown,
        userStatus: UserStatus.notAuth,
        lastName: '', firstName: '', branchName: '', phoneNumber: '');
  }

  UserEntity copyWith({
    String? lastName,
    String? firstName,
    String? branchName,
    String? phoneNumber,
    UserStatus? userStatus,
    UserType? userType,
    List<Direction>? directions
  }) {
    return UserEntity(
      userType: userType??this.userType,
      lastName: lastName ?? this.lastName,
      firstName: firstName ?? this.firstName,
      branchName: branchName ?? this.branchName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      userStatus: userStatus??this.userStatus,
      directions: directions??this.directions
    );
  }
}


class Direction{

  final List<dynamic> bonus;
  final double balance;
  final String name;
  final List<Lesson> lessons;

  const Direction({
    required this.bonus,
    required this.balance,
    required this.name,
    required this.lessons,
  });




  Direction copyWith({
    List<String>? bonus,
    double? balance,
    String? name,
    List<Lesson>? lessons,
  }) {
    return Direction(
      bonus: bonus ?? this.bonus,
      balance: balance ?? this.balance,
      name: name ?? this.name,
      lessons: lessons ?? this.lessons,
    );
  }
}

 enum LessonStatus{
   planned,
   complete,
   out,
   cancel,
   trial,
   reservation,
   singly,
   awaitAccept,
   unknown
 }

class Lesson{
  final String date; //2024-12-22
   final String timePeriod;
   final int idAuditory;
   final String nameTeacher;
   final LessonStatus status;

  const Lesson({
    required this.date,
    required this.timePeriod,
    required this.idAuditory,
    required this.nameTeacher,
    required this.status,
  });

  Lesson copyWith({
    String? date,
    String? timePeriod,
    int? idAuditory,
    String? nameTeacher,
    LessonStatus? status,
  }) {
    return Lesson(
      date: date ?? this.date,
      timePeriod: timePeriod ?? this.timePeriod,
      idAuditory: idAuditory ?? this.idAuditory,
      nameTeacher: nameTeacher ?? this.nameTeacher,
      status: status ?? this.status,
    );
  }
}