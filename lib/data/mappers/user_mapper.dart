

 import 'package:virtuozy/data/mappers/document_mapper.dart';
import 'package:virtuozy/data/mappers/notifi_setting_mapper.dart';
import 'package:virtuozy/data/models/price_subscription_model.dart';
import 'package:virtuozy/data/models/subway_model.dart';
import 'package:virtuozy/data/models/user_model.dart';
import 'package:virtuozy/domain/entities/price_subscription_entity.dart';
import 'package:virtuozy/domain/entities/subway_entity.dart';
import 'package:virtuozy/domain/entities/user_entity.dart';

import '../../domain/entities/lesson_entity.dart';
import '../../domain/entities/subscription_entity.dart';
import '../models/subscription_model.dart';

class UserMapper{



  static UserEntity fromApi({required UserModel userModel}){
    return UserEntity(
        documents: userModel.documents
            .map((e) => DocumentMapper.fromApi(documentModel: e))
            .toList(),
        id: userModel.id,
        lastName: userModel.lastName,
        firstName: userModel.firstName,
        branchName: userModel.branchName,
        phoneNumber: userModel.phoneNumber,
        userStatus: _userStatus(userModel.userStatus),
        userType: _userType(userModel.userType),
        directions:
            userModel.directions.map((e) => _fromDirectionModel(e)).toList(),
        notifiSttings: userModel.notifiSttings
            .map((e) => NotifiSettingMapper.fromApi(notifiSettingModel: e))
            .toList(),
        sex: userModel.sex,
        about_me: userModel.about_me,
        date_birth: userModel.date_birth,
        registration_date: userModel.registration_date,
        has_kids: userModel.has_kids,
        subways: userModel.subways.map((e) => fromApiSubway(model: e)).toList(),
        who_find: userModel.who_find,
        avaUrl: userModel.avaUrl);
  }

  static Option fromOptionApi({required OptionModel optionModel}){
    return Option(status: optionModel.status.isEmpty?OptionStatus.unknown:
    optionModel.status == 'freezing'?
    OptionStatus.freezing:optionModel.status == 'prolongation'?
    OptionStatus.prolongation:optionModel.status == 'vacation'?OptionStatus.vacation:OptionStatus.holiday,
        dateEnd: optionModel.dateEnd);
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
      case 9: return LessonStatus.firstLesson;
      case 10: return LessonStatus.lastLesson;
      case 11: return LessonStatus.reschedule;
    }
    return LessonStatus.unknown;
  }

  static DirectionLesson _fromDirectionModel(DirectionModel directionModel){
    return DirectionLesson(
      id: directionModel.id,
        bonus: directionModel.bonus.map((e) => _fromApiBonus(bonusModel: e)).toList(),
        subscriptionsAll: fromApiPriceSubAll(directionModel.subscriptionsAll),
        name: directionModel.name,
        lessons: directionModel.lessons.map((e) => _fromLessonModel(e)).toList(),
        lastSubscriptions: fromApiPriceSub(directionModel.lastSubscriptions));
  }

  static List<SubscriptionEntity> fromApiPriceSub(List<SubscriptionModel> subscriptionModels){

    return subscriptionModels.map((e) => SubscriptionEntity(
      contactValues: e.contactValues,
      option: fromOptionApi(
          optionModel: e.options.isEmpty?const OptionModel(status: '', dateEnd: ''):e.options[0]), //todo work with list
        idUser: e.idUser,
        idDir: e.idDir,
        nameDir: e.nameDir,
        status: e.status == 1?StatusSub.active:
        e.status == 0?StatusSub.inactive:StatusSub.planned,
        name: e.name,
        price: e.price,
        priceOneLesson: e.priceOneLesson,
        balanceLesson: e.balanceLesson,
        balanceSub: e.balanceSub,
        id: e.id,
        dateStart: e.dateStart,
        dateEnd: e.dateEnd,
        commentary: e.commentary,
        dateBay: e.dateBay,
        nameTeacher: e.nameTeacher
    )).toList();



  }

  static List<SubscriptionEntity> fromApiPriceSubAll(List<SubscriptionModel> subscriptionModelAll){
     return subscriptionModelAll.map((e) =>  SubscriptionEntity(
       contactValues: e.contactValues,
       option: fromOptionApi(optionModel: e.options.isEmpty?const OptionModel(status: '', dateEnd: ''):e.options[0]), // todo work in list,
       idDir: e.idDir,
       idUser: e.idUser,
       nameDir: e.nameDir,
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
         e.status == 0?StatusSub.inactive:StatusSub.planned,
         dateBay: e.dateBay,
       nameTeacher: e.nameTeacher
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
      nameGroup: lessonModel.nameGroup,
      idStudent: lessonModel.idStudent,
      idDir: lessonModel.idDir,
      idTeacher: lessonModel.idTeacher,
      type: _lessonType(lessonModel.type),
      alien: true,
      comments: lessonModel.comments,
      nameSub: lessonModel.nameSub,
      duration: lessonModel.duration,
      online: lessonModel.online,
      contactValues: lessonModel.contactValues,
      idSub: lessonModel.idSub,
      bonus: lessonModel.bonus,
      nameDirection: lessonModel.nameDirection,
        id: lessonModel.id,
        date: lessonModel.date,
        timePeriod: lessonModel.timePeriod,
        idAuditory: lessonModel.idAuditory,
        nameTeacher: lessonModel.nameTeacher,
        timeAccept: lessonModel.timeAccept,
        status: _lessonStatus(lessonModel.status),
        nameStudent: lessonModel.nameStudent,
        idSchool: lessonModel.idSchool);
  }

  static SubwayEntity fromApiSubway({required SubwayModel model}){
    return SubwayEntity(name: model.name,color: model.color);
  }

  static LessonType _lessonType(int status){
    switch(status){
      case 1: return LessonType.trial;
      case 2: return LessonType.group;
      case 3: return LessonType.singly;
    }

    return LessonType.unknown;
  }


 }