


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

import '../../domain/entities/notifi_setting_entity.dart';

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

    final directions = mapUser['directions'] as List<dynamic>;
    final settingsMap = mapUser['settingNotifi'] as List<dynamic>;
    final docs =  mapUser['documents'] as List<dynamic>;
    final subways  = (mapUser['subways'] as List<dynamic>).map((e) =>SubwayModel.fromMap(e)).toList();
    return UserModel(
      notifiSttings:
          settingsMap.map((e) => NotifiSettingModel.fromMap(e)).toList(),
      documents: docs.map((e) => DocumentModel.fromMap(e)).toList(),
      id: mapUser['id'] as int,
      lastName: mapUser['lastName'] as String,
      firstName: mapUser['firstName'] as String,
      branchName: mapUser['branchName'] as String,
      phoneNumber: mapUser['phoneNumber'] as String,
      userStatus: mapUser['userStatus'] as int,
      userType: mapUser['userType'] as int,
      directions: directions
          .map((e) =>
              DirectionModel.fromMap(mapDirection: e, mapSubs: mapSubsAll,lessons:lessons))
          .toList(),
      sex: mapUser['sex'] as String,
      about_me: mapUser['about_me'] as String,
      date_birth: mapUser['date_birth'] as String,
      registration_date: mapUser['registration_date'] as String,
      has_kids: mapUser['has_kids'] as bool,
      subways: subways,
      who_find: mapUser['who_find'] as String,
      avaUrl: mapUser['avaUrl'] as String,
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



  factory DirectionModel.fromMap({required Map<String, dynamic> mapDirection,required List<dynamic> mapSubs,required List<dynamic> lessons}) {

    //final lessons =  mapDirection['lessons'] as List<dynamic>;
    final nameDirection = mapDirection['name'] as String;
    final subs = mapSubs.map((e) => SubscriptionModel.fromMap(e,nameDirection)).toList();
    final subsDir = subs.where((element) => element.idDir == (mapDirection['id'] as int)).toList();
    final lastSub = _getLastSub(subsDir);
    final int idDir = mapDirection['id'];
    final bonus = mapDirection['bonus'] as List<dynamic>;
    return DirectionModel(
      id: idDir,
      bonus: bonus.map((e) => BonusModel.fromMap(e,nameDirection)).toList(),
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
      if(idDir == l.idDir){
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
         //millisecondsSinceEpochListPlanedSub.add(DateFormat('yyyy-MM-dd').parse(element.dateStart).millisecondsSinceEpoch);
        subAwait = element;
      }
    }

    final indexLastActiveSub = millisecondsSinceEpochListActiveSub.indexOf(millisecondsSinceEpochListActiveSub.reduce(max));
    listSubs.add(listSubsAllActive[indexLastActiveSub]);
    //final indexLastPlanedSub = millisecondsSinceEpochListPlanedSub.indexOf(millisecondsSinceEpochListPlanedSub.reduce(max));
    if(subAwait!=null){
      listSubs.add(subAwait);
    }

    return listSubs;
  }
}




 class LessonModel{
  final String nameGroup;
  final int id;
  final int idStudent;
  final int idSub;
  final int idDir;
  final String idSchool;
   final String date; //2024-12-22
   final String timePeriod;
   final String idAuditory;
   final String nameTeacher;
  final String nameStudent;
   final int status;
   final int type;
   final String timeAccept;
   final String nameDirection;
   final bool bonus;
   final int idTeacher;
   final List<dynamic> contactValues;
  final String comments;
  final String nameSub;
  final bool online;
  final int duration;



   const LessonModel( {
     required this.nameGroup,
     required this.idStudent,
     required this.nameSub,
     required this.comments,
     required this.duration,
     required this.online,
     required this.type,
     required this.idTeacher,
     required this.contactValues,
     required this.idDir,
     required this.idSchool,
     required this.nameStudent,
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

 static Map<String,dynamic> toMap(LessonModel lessonModel){
    return {
      'nameGroup':lessonModel.nameGroup,
      'online':lessonModel.online,
      'comments':lessonModel.comments,
      'nameSub':lessonModel.nameSub,
      'duration':lessonModel.duration,
      'type':lessonModel.type,
      'contactValues': lessonModel.contactValues,
      'idDir':lessonModel.idDir,
      'idSchool':lessonModel.idSchool,
      'idSub':lessonModel.idSub,
      'timeAccept':lessonModel.timeAccept,
      'date':lessonModel.date,
      'timePeriod':lessonModel.timePeriod,
    'idTeacher':lessonModel.idTeacher,
    'idAuditory':lessonModel.idAuditory,
      'nameTeacher':lessonModel.nameTeacher,
      'nameDir':lessonModel.nameDirection,
      'nameStudent':lessonModel.nameStudent,
       'idStudent': lessonModel.idStudent,
      'status':lessonModel.status
    };
  }

  factory LessonModel.fromMap(Map<String, dynamic> map,String nameDirection) {


    //final date  = DateTimeParser.date();
    //final time = DateTimeParser.time();
    return LessonModel(
      nameGroup: map['nameGroup']??'',
      idStudent: map['idStudent']??0,
      online: map['online']??false,
      comments: map['comments']??'...',
      nameSub: map['nameSub']??'...',
      duration: map['duration']??60,
      type: map['type']??10,
      contactValues: map['contactValues']??['8 (499) 322-71-04','https://wa.clck.bar/79231114616','https://t.me/@VirtuozyNskMs2'],
      idDir: map['idDir']??0,
      idSchool: map['idSchool']??'',
      idSub: map['idSub']??0,
      id: map['id']??0,
      timeAccept: map['timeAccept']??'',
      date: map['date']??'',
      timePeriod: map['timePeriod']??'',
       // timePeriod: time,
      idTeacher: map['idTeacher'],
      idAuditory: map['idAuditory']??'',
      nameTeacher: map['nameTeacher']??'',
      status: map['status']??0,
      nameDirection: map['nameDir']??'',
      bonus: map['bonus']??false,
        nameStudent: map['nameStudent']??''
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



