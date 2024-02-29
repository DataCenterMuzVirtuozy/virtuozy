

 import 'package:virtuozy/data/models/price_subscription_model.dart';
import 'package:virtuozy/data/models/user_model.dart';
import 'package:virtuozy/domain/entities/price_subscription_entity.dart';
import 'package:virtuozy/domain/entities/user_entity.dart';

import '../../domain/entities/subscription_entity.dart';
import '../models/subscription_model.dart';

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

  static DirectionLesson _fromDirectionModel(DirectionModel directionModel){
    return DirectionLesson(
        bonus: directionModel.bonus.map((e) => _fromApiBonus(bonusModel: e)).toList(),
        subscriptionsAll: fromApiPriceSubAll(directionModel.subscriptionsAll),
        name: directionModel.name,
        lessons: directionModel.lessons.map((e) => _fromLessonModel(e)).toList(),
        lastSubscription: fromApiPriceSub(directionModel.lastSubscription));
  }

  static SubscriptionEntity fromApiPriceSub(SubscriptionModel subscriptionModel){
    return SubscriptionEntity(
      status: subscriptionModel.status == 1?StatusSub.active:
      subscriptionModel.status == 0?StatusSub.inactive:StatusSub.planned,
        name: subscriptionModel.name,
        price: subscriptionModel.price,
        priceOneLesson: subscriptionModel.priceOneLesson,
        balanceLesson: subscriptionModel.balanceLesson,
        balanceSub: subscriptionModel.balanceSub,
        id: subscriptionModel.id,
        dateStart: subscriptionModel.dateStart,
      dateEnd: subscriptionModel.dateEnd,
      commentary: subscriptionModel.commentary
    );
  }

  static List<SubscriptionEntity> fromApiPriceSubAll(List<SubscriptionModel> subscriptionModelAll){
     return subscriptionModelAll.map((e) =>  SubscriptionEntity(
         name: e.name,
         price: e.price,
         priceOneLesson: e.priceOneLesson,
         balanceLesson: e.balanceLesson,
         balanceSub: e.balanceSub,
         id: e.id,
         dateStart: e.dateStart,
         dateEnd: e.dateEnd,
         commentary: e.commentary,
         status: e.status == 1?StatusSub.active:
         e.status == 0?StatusSub.inactive:StatusSub.planned
     )).toList();
  }

  static BonusEntity _fromApiBonus({required BonusModel bonusModel}){
    return BonusEntity(
      nameDirection: bonusModel.nameDirection,
      active: bonusModel.active,
        id: bonusModel.id,
        typeBonus: bonusModel.typeBonus == 1?TypeBonus.subscription:
        bonusModel.typeBonus == 2?TypeBonus.lesson: bonusModel.typeBonus == 3?
        TypeBonus.money:TypeBonus.unknown,
        title: bonusModel.title,
        description: bonusModel.description,
        quantity: bonusModel.quantity);
  }

  static Lesson _fromLessonModel(LessonModel lessonModel){
    return Lesson(
      idSub: lessonModel.idSub,
      bonus: lessonModel.bonus,
      nameDirection: lessonModel.nameDirection,
        id: lessonModel.id,
        date: lessonModel.date,
        timePeriod: lessonModel.timePeriod,
        idAuditory: lessonModel.idAuditory,
        nameTeacher: lessonModel.nameTeacher,
        timeAccept: lessonModel.timeAccept,
        status: _lessonStatus(lessonModel.status));
  }

 }