

 import 'package:virtuozy/data/models/user_model.dart';
import 'package:virtuozy/domain/entities/user_entity.dart';

class UserMapper{



  static UserEntity fromApi({required UserModel userModel}){
    return UserEntity(lastName: userModel.lastName,
        firstName: userModel.firstName,
        branchName: userModel.branchName,
        phoneNumber: userModel.phoneNumber,
        userStatus: _userStatus(userModel.userStatus),
        userType: _userType( userModel.userType),
        directions: userModel.directions.map((e) => _fromDirectionModel(e)).toList());
  }


  static UserStatus _userStatus(int status){
    return status == 0?UserStatus.notAuth:
        status == 1?UserStatus.auth:UserStatus.moderation;
  }

  static UserType _userType(int type){
    return type == 1?UserType.student:UserType.teacher;
  }

  static LessonStatus _lessonStatus(int status){
    switch(status){
      case 1: return LessonStatus.planned;
      case 2: return LessonStatus.complete;
      case 3: return LessonStatus.cancel;
      case 4: return LessonStatus.out;
      case 5: return LessonStatus.reservation;
      case 6: return LessonStatus.singly;
      case 7: return LessonStatus.trial;
      case 8:return LessonStatus.awaitAccept;
    }
    return LessonStatus.unknown;
  }

  static Direction _fromDirectionModel(DirectionModel directionModel){
    return Direction(bonus: directionModel.bonus,
        balance: directionModel.balance,
        name: directionModel.name,
        lessons: directionModel.lessons.map((e) => _fromLessonModel(e)).toList());
  }


  static Lesson _fromLessonModel(LessonModel lessonModel){
    return Lesson(
        id: lessonModel.id,
        date: lessonModel.date,
        timePeriod: lessonModel.timePeriod,
        idAuditory: lessonModel.idAuditory,
        nameTeacher: lessonModel.nameTeacher,
        timeAccept: lessonModel.timeAccept,
        status: _lessonStatus(lessonModel.status));
  }

 }