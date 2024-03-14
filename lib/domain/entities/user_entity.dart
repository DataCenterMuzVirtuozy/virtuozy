
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
   bool get isUnknown => this == UserType.unknown;
 }


 extension UserStatusExt on UserStatus{
  bool get isModeration => this==UserStatus.moderation;
  bool get isAuth => this == UserStatus.auth;
  bool get isNotAuth => this == UserStatus.notAuth;
 }

 class UserEntity{
   final int id;
   final String lastName;
   final String firstName;
   final String branchName;
   final String phoneNumber;
   final UserStatus userStatus;
   final UserType userType;
   final List<DirectionLesson> directions;

   const UserEntity({
     required this.id,
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
        id: 0,
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
    List<DirectionLesson>? directions,
    int? id
  }) {
    return UserEntity(
      id:id??this.id,
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
  final int id;
  final List<BonusEntity> bonus;
  final List<SubscriptionEntity> subscriptionsAll;
  final List<SubscriptionEntity> lastSubscriptions;
  final String name;
  final List<Lesson> lessons;

  const DirectionLesson({
    required this.id,
    required this.lastSubscriptions,
    required this.bonus,
    required this.subscriptionsAll,
    required this.name,
    required this.lessons,
  });




  DirectionLesson copyWith({
    List<BonusEntity>? bonus,
    List<SubscriptionEntity>? subscriptionsAll,
    List<SubscriptionEntity>? lastSubscriptions,
    String? name,
    List<Lesson>? lessons,
    int? id
  }) {
    return DirectionLesson(
      id: id??this.id,
      lastSubscriptions: lastSubscriptions??this.lastSubscriptions,
      bonus: bonus ?? this.bonus,
      subscriptionsAll: subscriptionsAll ?? this.subscriptionsAll,
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
   firstLesson,
   lastLesson,
   unknown
 }

class Lesson{
  final int id;
  final String date; //2024-12-22
   final String timePeriod;
   final String timeAccept;
   final String idAuditory;
   final String nameTeacher;
   final LessonStatus status;
   final String nameDirection;
  final int idSub;
  final bool bonus;

  const Lesson({
    required this.id,
    required this.idSub,
    required this.bonus,
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
      idSub:0,
      bonus:false,
      nameDirection: '',
        timeAccept: '',
        date: '',
        timePeriod: '',
        idAuditory: '',
        nameTeacher: '',
        status: LessonStatus.unknown,
        id: 0);
  }

  Lesson copyWith({
    String? date,
    String? timePeriod,
    String? idAuditory,
    String? nameTeacher,
    LessonStatus? status,
    String? timeAccept,
    String? nameDirection,
     int? idSub,
     bool? bonus,
  }) {
    return Lesson(
      idSub: idSub??this.idSub,
      bonus: bonus??this.bonus,
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
    final String nameDirection;

    const BonusEntity({
      required this.active,
      required this.id,
    required this.typeBonus,
    required this.title,
    required this.description,
    required this.quantity,
      required this.nameDirection
  });


   factory BonusEntity.unknown(){
     return const BonusEntity(
         active: true,
         id: 0,
         typeBonus: TypeBonus.unknown,
         title: '',
         description: '',
         nameDirection: '',
         quantity: 0.0);
   }

  BonusEntity copyWith({
    TypeBonus? typeBonus,
    String? title,
    String? description,
    double? quantity,
    int? id,
    bool? active,
    String? nameDirection
  }) {
    return BonusEntity(
      nameDirection: nameDirection??this.nameDirection,
      typeBonus: typeBonus ?? this.typeBonus,
      title: title ?? this.title,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      id: id ?? this.id,
      active: active ?? this.active,
    );
  }
}