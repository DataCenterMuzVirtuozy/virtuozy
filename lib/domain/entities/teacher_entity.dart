



 class TeacherEntity{

   final int id;
   final String lastName;
   final String firstName;
   final String phoneNum;

   const TeacherEntity({
    required this.id,
    required this.lastName,
    required this.firstName,
    required this.phoneNum,
  });


   factory TeacherEntity.unknown(){
    return const TeacherEntity(id: 0, lastName: '', firstName: '', phoneNum: '');
   }


   TeacherEntity copyWith({
    int? id,
    String? lastName,
    String? firstName,
    String? phoneNum,
  }) {
    return TeacherEntity(
      id: id ?? this.id,
      lastName: lastName ?? this.lastName,
      firstName: firstName ?? this.firstName,
      phoneNum: phoneNum ?? this.phoneNum,
    );
  }
}