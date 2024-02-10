


 class UserModel{
   final String lastName;
   final String firstName;
   final String branchName;
   final String phoneNumber;
   final int userStatus;
   final int userType;
   final List<DirectionModel> directions;

   const UserModel({
    required this.lastName,
    required this.firstName,
    required this.branchName,
    required this.phoneNumber,
    required this.userStatus,
    required this.userType,
    required this.directions,
  });



  factory UserModel.fromMap(Map<String, dynamic> map) {

    final directions = map['directions'] as List<dynamic>;
    return UserModel(
      lastName: map['lastName'] as String,
      firstName: map['firstName'] as String,
      branchName: map['branchName'] as String,
      phoneNumber: map['phoneNumber'] as String,
      userStatus: map['userStatus'] as int,
      userType: map['userType'] as int,
      directions: directions.map((e) => DirectionModel.fromMap(e)).toList(),
    );
  }
}



 class DirectionModel{
   final List<dynamic> bonus;
   final double balance;
   final String name;
   final List<LessonModel> lessons;

   const DirectionModel({
    required this.bonus,
    required this.balance,
    required this.name,
    required this.lessons,
  });



  factory DirectionModel.fromMap(Map<String, dynamic> map) {

    final lessons =  map['lessons'] as List<dynamic>;
    return DirectionModel(
      bonus: map['bonus'] as List<dynamic>,
      balance: map['balance'] as double,
      name: map['name'] as String,
      lessons: lessons.map((e) => LessonModel.fromMap(e)).toList(),
    );
  }
}




 class LessonModel{
   final String date; //2024-12-22
   final String timePeriod;
   final int idAuditory;
   final String nameTeacher;
   final int status;

   const LessonModel({
    required this.date,
    required this.timePeriod,
    required this.idAuditory,
    required this.nameTeacher,
    required this.status,
  });



  factory LessonModel.fromMap(Map<String, dynamic> map) {
    return LessonModel(
      date: map['date'] as String,
      timePeriod: map['timePeriod'] as String,
      idAuditory: map['idAuditory'] as int,
      nameTeacher: map['nameTeacher'] as String,
      status: map['status'] as int,
    );
  }
}



