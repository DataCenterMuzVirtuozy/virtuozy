


 import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:virtuozy/data/models/price_subscription_model.dart';
import 'package:virtuozy/data/models/subscription_model.dart';

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
   final List<BonusModel> bonus;
   final List<SubscriptionModel> subscriptionsAll;
   final SubscriptionModel lastSubscription;
   final String name;
   final List<LessonModel> lessons;

   const DirectionModel({
    required this.bonus,
     required this.subscriptionsAll,
    required this.lastSubscription,
    required this.name,
    required this.lessons,
  });



  factory DirectionModel.fromMap(Map<String, dynamic> map) {

    final lessons =  map['lessons'] as List<dynamic>;
    final nameDirection = map['name'] as String;
    final subsMap = map['subscriptions'] as List<dynamic>;
    final subs = subsMap.map((e) => SubscriptionModel.fromMap(e)).toList();
    final lastSub = _getLastSub(subs);
    final bonus = map['bonus'] as List<dynamic>;
    return DirectionModel(
      bonus: bonus.map((e) => BonusModel.fromMap(e,nameDirection)).toList(),
      subscriptionsAll: subs,
      name: nameDirection,
      lessons: lessons.map((e) => LessonModel.fromMap(e,nameDirection)).toList(),
      lastSubscription: lastSub,

    );
  }

   static SubscriptionModel _getLastSub(List<SubscriptionModel> subs){
    final List<int> millisecondsSinceEpochList = [];

    for(var element in subs){
      millisecondsSinceEpochList.add(DateFormat('yyyy-MM-dd').parse(element.dateStart).millisecondsSinceEpoch);

    }
    final indexLast = millisecondsSinceEpochList.indexOf(millisecondsSinceEpochList.reduce(max));
    return subs[indexLast];
  }
}




 class LessonModel{
  final int id;
  final int idSub;
   final String date; //2024-12-22
   final String timePeriod;
   final String idAuditory;
   final String nameTeacher;
   final int status;
   final String timeAccept;
   final String nameDirection;
   final bool bonus;

   const LessonModel( {
     required this.nameDirection,
     required this.id,
     required this.idSub,
     required this.timeAccept,
    required this.date,
    required this.timePeriod,
    required this.idAuditory,
    required this.nameTeacher,
    required this.status,
     required this.bonus
  });



  factory LessonModel.fromMap(Map<String, dynamic> map,String nameDirection) {

    return LessonModel(
      idSub: map['idSub'] as int,
      id: map['id'] as int,
      timeAccept: map['timeAccept'] as String,
      date: map['date'] as String,
      timePeriod: map['timePeriod'] as String,
      idAuditory: map['idAuditory'] as String,
      nameTeacher: map['nameTeacher'] as String,
      status: map['status'] as int,
      nameDirection: nameDirection,
      bonus: map['bonus'] as bool
    );
  }
}


  class BonusModel{
    final int typeBonus;
    final String title;
    final String description;
    final double quantity;
    final int id;
    final bool active;
    final String nameDirection;

    const BonusModel({
      required this.nameDirection,
      required this.id,
      required this.active,
    required this.typeBonus,
    required this.title,
    required this.description,
    required this.quantity,
  });



  factory BonusModel.fromMap(Map<String, dynamic> map, String nameDirection) {
    return BonusModel(
      nameDirection: nameDirection,
      id: map['id'] as int,
      active: map['active'] as bool,
      typeBonus: map['typeBonus'] as int,
      title: map['title'] as String,
      description: map['description'] as String,
      quantity: (map['quantity'] as dynamic).toDouble(),
    );
  }
}



