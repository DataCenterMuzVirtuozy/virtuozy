


 import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:virtuozy/data/models/price_subscription_model.dart';
import 'package:virtuozy/data/models/subscription_model.dart';
import 'package:virtuozy/domain/entities/subscription_entity.dart';

class UserModel{
   final int id;
   final String lastName;
   final String firstName;
   final String branchName;
   final String phoneNumber;
   final int userStatus;
   final int userType;
   final List<DirectionModel> directions;

   const UserModel({
     required this.id,
    required this.lastName,
    required this.firstName,
    required this.branchName,
    required this.phoneNumber,
    required this.userStatus,
    required this.userType,
    required this.directions,
  });



  factory UserModel.fromMap({required Map<String, dynamic> mapUser,required List<dynamic> mapSubsAll}) {

    final directions = mapUser['directions'] as List<dynamic>;
    return UserModel(
      id: mapUser['id'] as int,
      lastName: mapUser['lastName'] as String,
      firstName: mapUser['firstName'] as String,
      branchName: mapUser['branchName'] as String,
      phoneNumber: mapUser['phoneNumber'] as String,
      userStatus: mapUser['userStatus'] as int,
      userType: mapUser['userType'] as int,
      directions: directions.map((e) => DirectionModel.fromMap(mapDirection: e,mapSubs: mapSubsAll)).toList(),
    );
  }
}



 class DirectionModel{
   final int id;
   final List<BonusModel> bonus;
   final List<SubscriptionModel> subscriptionsAll;
   final List<SubscriptionModel> lastSubscriptions;
   final String name;
   final List<LessonModel> lessons;

   const DirectionModel({
     required this.id,
    required this.bonus,
     required this.subscriptionsAll,
    required this.lastSubscriptions,
    required this.name,
    required this.lessons,
  });



  factory DirectionModel.fromMap({required Map<String, dynamic> mapDirection,required List<dynamic> mapSubs}) {

    final lessons =  mapDirection['lessons'] as List<dynamic>;
    final nameDirection = mapDirection['name'] as String;
    final subs = mapSubs.map((e) => SubscriptionModel.fromMap(e,nameDirection)).toList();
    final subsDir = subs.where((element) => element.idDir == (mapDirection['id'] as int)).toList();
    final lastSub = _getLastSub(subsDir);
    final bonus = mapDirection['bonus'] as List<dynamic>;
    return DirectionModel(
      id: mapDirection['id'],
      bonus: bonus.map((e) => BonusModel.fromMap(e,nameDirection)).toList(),
      subscriptionsAll: subsDir,
      name: nameDirection,
      lessons: lessons.map((e) => LessonModel.fromMap(e,nameDirection)).toList(),
      lastSubscriptions: lastSub,

    );
  }




   static List<SubscriptionModel> _getLastSub(List<SubscriptionModel> subs){
    final List<int> millisecondsSinceEpochList = [];
     SubscriptionModel? subAwait;
    List<SubscriptionModel> listSubs = [];
   if(subs.isEmpty){
     return [];
   }
    for(var element in subs){
      if(element.dateStart.isNotEmpty){
        millisecondsSinceEpochList.add(DateFormat('yyyy-MM-dd').parse(element.dateStart).millisecondsSinceEpoch);
      }

      if(element.status == 2){
        subAwait = element;
      }
    }
    final indexLast = millisecondsSinceEpochList.indexOf(millisecondsSinceEpochList.reduce(max));
    listSubs.add(subs[indexLast]);

    if(subAwait!=null){
      listSubs.add(subAwait);
    }
    return listSubs;
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
      quantity: (map['quantity'] as dynamic).toDouble()??0.0,
    );
  }
}



