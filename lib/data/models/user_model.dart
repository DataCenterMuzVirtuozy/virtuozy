


 import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:virtuozy/data/mappers/notifi_setting_mapper.dart';
import 'package:virtuozy/data/models/document_model.dart';
import 'package:virtuozy/data/models/notifi_setting_model.dart';
import 'package:virtuozy/data/models/price_subscription_model.dart';
import 'package:virtuozy/data/models/subscription_model.dart';
import 'package:virtuozy/data/models/subway_model.dart';
import 'package:virtuozy/domain/entities/subscription_entity.dart';
import 'package:virtuozy/utils/date_time_parser.dart';
import 'package:virtuozy/utils/preferences_util.dart';

import '../../domain/entities/notifi_setting_entity.dart';
import '../../utils/contact_school_by_location.dart';
import 'lesson_model.dart';

class UserModel{
   final int id;
   final String lastName;
   final String firstName;
   final String branchName;
   final String phoneNumber;
   final int userStatus;
   final int userType;
   final List<DocumentModel> documents;
   final List<DirectionModel> directions;
   final List<NotifiSettingModel> notifiSttings;
   final String sex;
   final String about_me;
   final String date_birth;
   final String registration_date;
   final bool has_kids;
   final List<SubwayModel> subways;
   final String who_find;
   final String avaUrl;

   const UserModel({
     required this.avaUrl,
     required this.sex,
     required this.about_me,
     required this.date_birth,
     required this.registration_date,
     required this.has_kids,
     required this.subways,
     required this.who_find,
     required this.notifiSttings,
     required this.id,
    required this.lastName,
    required this.firstName,
    required this.branchName,
    required this.phoneNumber,
    required this.userStatus,
    required this.userType,
     required this.documents,
    required this.directions,
  });



  factory UserModel.fromMap({required Map<String, dynamic> mapUser,required List<dynamic> mapSubsAll,required List<dynamic> lessons}) {

    final directions = (mapUser['directions'] as List<dynamic>);
    //if(directions.length>5)directions.removeAt(9); //todo index 9 from crm - {id: null, name: Не выбрано, nameTeacher:  Не выбрано }
   //final settingsMap = mapUser['settingNotifi'] as List<dynamic>; //todo type 'String' is not a subtype of type 'List<dynamic>' in type cast
    //final docs =  mapUser['documents'] as List<dynamic>;//todo type 'String' is not a subtype of type 'List<dynamic>' in type cast
    final List<dynamic> subways  = mapUser['subways']??[];
   // final List<SubwayModel> listSubway = subway.color.isEmpty?[]:[subway];
    final branchName = ContactSchoolByLocation.getIdLocation();
    return UserModel(
      //notifiSttings: settingsMap.map((e) => NotifiSettingModel.fromMap(e)).toList(),
      notifiSttings: [],
      //documents: docs.map((e) => DocumentModel.fromMap(e)).toList(),
      documents: [],
      id: mapUser['id']??1,
      lastName: mapUser['lastName']??'',
      firstName: mapUser['firstName']??'',
      branchName: branchName,    //mapUser['branchName']??'',
      phoneNumber: mapUser['phoneNumber']??'',
      userStatus: mapUser['userStatus'] as int, //todo from crm null 1- auth 2 - mod 0 - not auth
      userType: mapUser['userType'] as int,
      directions: directions
          .map((e) =>
              DirectionModel.fromMap(mapDirection: e, mapSubs: mapSubsAll,lessons:lessons))
          .toList(),
      sex: mapUser['sex'] as String,
      about_me: mapUser['about_me']??'',
      date_birth: mapUser['date_birth']??'',
      registration_date: mapUser['registration_date']??'',
      has_kids: mapUser['has_kids'] == '1'?true:false,
      subways: subways.isEmpty?[]:subways.map((e)=>SubwayModel.fromMap(e)).toList(),
      who_find: mapUser['who_find']??'',
      avaUrl: mapUser['avaUrl']??'',
    );
  }
}





 class DirectionModel{
   final int id;
   final String nameTeacher;
   final List<BonusModel> bonus;
   final List<SubscriptionModel> subscriptionsAll;
   final List<SubscriptionModel> lastSubscriptions;
   final String name;
   final List<LessonModel> lessons;

   const DirectionModel({
     required this.nameTeacher,
     required this.id,
    required this.bonus,
     required this.subscriptionsAll,
    required this.lastSubscriptions,
    required this.name,
    required this.lessons,
  });



  factory DirectionModel.fromMap({required Map<String, dynamic> mapDirection,required List<dynamic> mapSubs,required List<dynamic> lessons}) {
     int index = 0;
    //final lessons =  mapDirection['lessons'] as List<dynamic>;
    final nameDirection = mapDirection['name'] as String;
    final nameTeacherDir = mapDirection['nameTeacher']??'';
    final subs = mapSubs.map((e) => SubscriptionModel.fromMap(e,nameDirection)).toList();
    final subsDir = subs.where((element) =>element.idDir == (mapDirection['customerId'] as int)).toList();
    final lastSub = _getLastSub(subsDir);
    final int idDir = mapDirection['customerId'];
   // final bonus = mapDirection['bonus'] as List<dynamic>;

    return DirectionModel(
      nameTeacher: nameTeacherDir,
      id: idDir,
     // bonus: bonus.map((e) => BonusModel.fromMap(e,nameDirection)).toList(),
      bonus: [],
      subscriptionsAll: subsDir,
      name: nameDirection,
      lessons: _getLessons(lessons: lessons.map((e) => LessonModel.fromMap(e,nameDirection)).toList(),idDir: idDir),
      lastSubscriptions: lastSub,

    );
  }






    static List<LessonModel> _getLessons({required List<LessonModel> lessons,required int idDir}){
    List<LessonModel> lessonsResult = [];
    //List<int> ids = subsDir.map((e) => e.id).toList();

    for(var l in lessons){
      if(idDir == l.idStudent&&l.status!=4){
        lessonsResult.add(l);
      }
    }
    return lessonsResult;
    }




   static List<SubscriptionModel> _getLastSub(List<SubscriptionModel> subs){
    final List<int> millisecondsSinceEpochListActiveSub = [];
    final List<int> millisecondsSinceEpochListPlanedSub = [];
    List<SubscriptionModel> listSubsAllActive = [];
    List<SubscriptionModel> listSubsAllPlaned = [];
     SubscriptionModel? subAwait;
    List<SubscriptionModel> listSubs = [];

   if(subs.isEmpty){
     return [];
   }

   for(var element in subs){

      if(element.dateStart.isNotEmpty&&element.status == 1){
          listSubsAllActive.add(element);
        millisecondsSinceEpochListActiveSub.add(DateFormat('yyyy-MM-dd').parse(element.dateStart).millisecondsSinceEpoch);
      }

      if(element.status == 2&&element.dateStart.isNotEmpty){
        // print('Dir ${element.name} ${element.dateStart} - ${element.dateEnd} Status ${element.status}');
        // millisecondsSinceEpochListPlanedSub.add(DateFormat('yyyy-MM-dd').parse(element.dateStart).millisecondsSinceEpoch);
        subAwait = element;
      }


    }

    if(millisecondsSinceEpochListActiveSub.isNotEmpty){
      final indexLastActiveSub = millisecondsSinceEpochListActiveSub.indexOf(millisecondsSinceEpochListActiveSub.reduce(max));
      listSubs.add(listSubsAllActive[indexLastActiveSub]);
    }

    //final indexLastPlanedSub = millisecondsSinceEpochListPlanedSub.indexOf(millisecondsSinceEpochListPlanedSub.reduce(max));
    if(subAwait!=null){
      listSubs.add(subAwait);
    }

    return listSubs;
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



