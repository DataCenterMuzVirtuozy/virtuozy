
 import 'package:virtuozy/domain/entities/price_subscription_entity.dart';
import 'package:virtuozy/domain/entities/subscription_entity.dart';

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
   final List<DirectionLesson> directions;

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
    List<DirectionLesson>? directions
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


class DirectionLesson{

  final List<BonusEntity> bonus;
  final SubscriptionEntity subscription;
  final String name;
  final List<Lesson> lessons;

  const DirectionLesson({
    required this.bonus,
    required this.subscription,
    required this.name,
    required this.lessons,
  });




  DirectionLesson copyWith({
    List<BonusEntity>? bonus,
    SubscriptionEntity? subscription,
    String? name,
    List<Lesson>? lessons,
  }) {
    return DirectionLesson(
      bonus: bonus ?? this.bonus,
      subscription: subscription ?? this.subscription,
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
   layering,
   unknown
 }

class Lesson{
  final int id;
  final String date; //2024-12-22
   final String timePeriod;
   final String timeAccept;
   final int idAuditory;
   final String nameTeacher;
   final LessonStatus status;
   final String nameDirection;

  const Lesson({
    required this.id,
    required this.timeAccept,
    required this.date,
    required this.timePeriod,
    required this.idAuditory,
    required this.nameTeacher,
    required this.status,
    required this.nameDirection
  });


  factory Lesson.unknown(){
    return const Lesson(
      nameDirection: '',
        timeAccept: '',
        date: '',
        timePeriod: '',
        idAuditory: 0,
        nameTeacher: '',
        status: LessonStatus.unknown,
        id: 0);
  }

  Lesson copyWith({
    String? date,
    String? timePeriod,
    int? idAuditory,
    String? nameTeacher,
    LessonStatus? status,
    String? timeAccept,
    String? nameDirection
  }) {
    return Lesson(
      nameDirection: nameDirection??this.nameDirection,
      timeAccept: timeAccept??this.timeAccept,
      date: date ?? this.date,
      timePeriod: timePeriod ?? this.timePeriod,
      idAuditory: idAuditory ?? this.idAuditory,
      nameTeacher: nameTeacher ?? this.nameTeacher,
      status: status ?? this.status,
      id: id,
    );
  }
}

   enum TypeBonus{
     money,
     subscription,
     lesson,
     unknown
   }

  class BonusEntity{

    final TypeBonus typeBonus;
    final String title;
    final String description;
    final double quantity;
    final int id;
    final bool active;

    const BonusEntity({
      required this.active,
      required this.id,
    required this.typeBonus,
    required this.title,
    required this.description,
    required this.quantity,
  });


   factory BonusEntity.unknown(){
     return const BonusEntity(
         active: true,
         id: 0,
         typeBonus: TypeBonus.unknown,
         title: '',
         description: '',
         quantity: 0.0);
   }

  BonusEntity copyWith({
    TypeBonus? typeBonus,
    String? title,
    String? description,
    double? quantity,
    int? id,
    bool? active,
  }) {
    return BonusEntity(
      typeBonus: typeBonus ?? this.typeBonus,
      title: title ?? this.title,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      id: id ?? this.id,
      active: active ?? this.active,
    );
  }
}