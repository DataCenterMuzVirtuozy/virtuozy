
 enum UserStatus{
  notAuth,
   auth,
   moderation
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

   const UserEntity({
     required this.userStatus,
     required this.lastName,
    required this.firstName,
    required this.branchName,
    required this.phoneNumber,
  });


   factory UserEntity.unknown() {
    return const UserEntity(
        userStatus: UserStatus.notAuth,
        lastName: '', firstName: '', branchName: '', phoneNumber: '');
  }

  UserEntity copyWith({
    String? lastName,
    String? firstName,
    String? branchName,
    String? phoneNumber,
    UserStatus? userStatus
  }) {
    return UserEntity(
      lastName: lastName ?? this.lastName,
      firstName: firstName ?? this.firstName,
      branchName: branchName ?? this.branchName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      userStatus: userStatus??this.userStatus,
    );
  }
}