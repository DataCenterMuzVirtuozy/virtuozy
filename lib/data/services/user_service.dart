


 import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:virtuozy/data/rest/dio_client.dart';
import 'package:virtuozy/data/rest/endpoints.dart';
import 'package:virtuozy/utils/failure.dart';

import '../../di/locator.dart';
import '../models/user_model.dart';

class UserService{


   final _dio = locator.get<DioClient>().init();


   Future<UserModel> getUser({required String uid}) async {
    try{
       await Future.delayed(const Duration(seconds: 1));
       final res = await _dio.get(Endpoints.user,
       queryParameters: {
          'phoneNumber': uid.replaceAll(' ', '')
       });
       final idUser = res.data[0]['id'] as int;
       final resSubs = await _dio.get(Endpoints.subsUser,
           queryParameters: {
            'idUser': idUser
           });

       if((res.data as List<dynamic>).isEmpty){
        return throw   Failure('Пользователь не найден'.tr());
       }
        return UserModel.fromMap(mapUser: res.data[0],mapSubsAll: resSubs.data );
    } on Failure catch(e){
       throw  Failure(e.message);
    } on DioException catch(e){
     throw  Failure(e.message!);
    }
   }

 }


  final Map<String,dynamic> _user = {
   "id": 1,
   "lastName": "Мананкова",
   "firstName": "Маргарита",
   "branchName": "Москва",
   "phoneNumber": "+(791)324-567-89",
   "userStatus": 1,
   "userType": 1,
   "directions": [
    {
     "name": "Скрипка",
     "nameTeacher":"Евженко Кристина",
     "idAuditory":"Свинг",
     "bonus": [
      {
       "id": 1,
       "active": false,
       "typeBonus": 1,
       "title": "Получи бонусный урок",
       "description": "20% групповые занятия, концерты, практика публичных выступлений и участие в музыкальных коллективах",
       "quantity": 1.0
      }
     ],
     "subscriptions": [

      {
       "id":1,
       "name": "Абонемент на 1 занятие",
       "dateStart":"2024-01-13",
       "dateEnd":"2024-01-13",
       "price": 1300.0,
       "priceOneLesson": 1300.0,
       "balanceSub": 0.0,
       "balanceLesson": 0,
        "status":0,
       "commentary":""


      },


      {
       "id": 2,
       "name": "Абонемент на 4 занятие",
       "dateStart":"2024-01-13",
       "dateEnd":"2024-02-13",
       "price": 4400.0,
       "priceOneLesson": 1100.0,
       "balanceSub": 0.0,
       "balanceLesson": 0,
       "status":0,
       "commentary":""
      },

      {
       "id": 3,
       "name": "Абонемент на 8 занятие",
       "dateStart":"2024-01-28",
       "dateEnd":"2024-03-07",
       "price": 8300.0,
       "priceOneLesson": 1037.5,
       "balanceSub": 4150.0,
       "balanceLesson": 4,
       "status":1,
       "commentary":"28.02.24 дата окончания абонемента по договору. В связи с болезнью продлили ДО до 07.03.24"

      },

     ],

     "lessons": [
      {
       "id": 1,
       "idSub":1,
       "date": "2024-01-13",
       "timePeriod": "12:00-13:00",
       "idAuditory": "Свинг",
       "nameTeacher":"Евженко Кристина.",
       "timeAccept": "2024-01-13",
       "bonus":false,
       "status": 2
      },

      {
       "id": 2,
       "idSub": 2,
       "date": "2024-01-15",
       "timePeriod": "12:00-13:00",
       "idAuditory": "Свинг",
       "nameTeacher":"Евженко Кристина.",
       "timeAccept": "2024-01-15",
       "bonus":false,
       "status": 2
      },

      {
       "id": 3,
       "idSub": 2,
       "date": "2024-01-18",
       "timePeriod": "12:00-13:00",
       "idAuditory": "Свинг",
       "nameTeacher":"Евженко Кристина.",
       "timeAccept": "2024-01-18",
       "bonus":false,
       "status": 2
      },

      {
       "id": 5,
       "idSub":2,
       "date": "2024-01-21",
       "timePeriod": "12:00-13:00",
       "idAuditory": "Свинг",
       "nameTeacher":"Евженко Кристина.",
       "timeAccept": "2024-01-21",
       "bonus":false,
       "status": 2
      },

      {
       "id": 6,
       "idSub":3,
       "date": "2024-01-24",
       "timePeriod": "12:00-13:00",
       "idAuditory": "Свинг",
       "nameTeacher":"Евженко Кристина.",
       "timeAccept": "2024-01-24",
       "bonus":false,
       "status": 2
      },

      {
       "id": 7,
       "idSub":3,
       "date": "2024-01-28",
       "timePeriod": "12:00-13:00",
       "idAuditory": "Свинг",
       "nameTeacher":"Евженко Кристина.",
       "timeAccept": "2024-01-28",
       "bonus":false,
       "status": 2
      },

      {
       "id": 8,
       "idSub":3,
       "date": "2024-01-31",
       "timePeriod": "12:00-13:00",
       "idAuditory": "Свинг",
       "nameTeacher":"Евженко Кристина.",
       "timeAccept": "2024-01-31",
       "bonus":false,
       "status": 2
      },

      {
       "id": 9,
       "idSub":3,
       "date": "2024-02-04",
       "timePeriod": "12:00-13:00",
       "idAuditory": "Свинг",
       "nameTeacher":"Евженко Кристина.",
       "timeAccept": "2024-02-04",
       "bonus":false,
       "status": 2
      },

      {
       "id": 10,
       "idSub":3,
       "date": "2024-02-07",
       "timePeriod": "12:00-13:00",
       "idAuditory": "Свинг",
       "nameTeacher":"Евженко Кристина.",
       "timeAccept": "",
       "bonus":false,
       "status": 4
      },


      {
       "id": 10,
       "idSub":3,
       "date": "2024-02-11",
       "timePeriod": "12:00-13:00",
       "idAuditory": "Свинг",
       "nameTeacher":"Евженко Кристина.",
       "timeAccept": "2024-02-11",
       "bonus":false,
       "status": 2
      },


      {
       "id": 11,
       "idSub":3,
       "date": "2024-02-14",
       "timePeriod": "12:00-13:00",
       "idAuditory": "Свинг",
       "nameTeacher":"Евженко Кристина.",
       "timeAccept": "2024-02-14",
       "bonus":false,
       "status": 2
      },

      {
       "id": 12,
       "idSub":3,
       "date": "2024-03-03",
       "timePeriod": "12:00-13:00",
       "idAuditory": "Свинг",
       "nameTeacher":"Евженко Кристина.",
       "timeAccept": "",
       "bonus":false,
       "status": 1
      },

      {
       "id": 13,
       "idSub":3,
       "date": "2024-03-06",
       "timePeriod": "12:00-13:00",
       "idAuditory": "Свинг",
       "nameTeacher":"Евженко Кристина.",
       "timeAccept": "",
       "bonus":false,
       "status": 1
      },

      {
       "id": 14,
       "idSub":3,
       "date": "2024-03-10",
       "timePeriod": "12:00-13:00",
       "idAuditory": "Свинг",
       "nameTeacher":"Евженко Кристина.",
       "timeAccept": "",
       "bonus":false,
       "status": 5
      },



     ]


    },


    {
     "name": "Вокал",
     "nameTeacher":"Перова Анастасия",
     "idAuditory":"Авангард",
     "bonus": [
      {
       "id": 1,
       "active": false,
       "typeBonus": 1,
       "title": "Получи бонусный урок",
       "description": "20% групповые занятия, концерты, практика публичных выступлений и участие в музыкальных коллективах",
       "quantity": 1.0
      }
     ],

     "subscriptions":[

      {
        "id":1,
         "name": "Абонемент на 8 занятий Свобода",
          "dateStart":"2023-12-23",
           "dateEnd":"2024-02-01",
            "price": 8300.0,
          "priceOneLesson": 1037.5,
          "balanceSub": 0.0,
          "balanceLesson": 0,
       "status":0,
           "commentary":"",
      },
      {
       "id":1,
       "name": "Абонемент на 8 занятий Свобода",
       "dateStart":"2023-12-23",
       "dateEnd":"2024-02-01",
       "price": 8300.0,
       "priceOneLesson": 1037.5,
       "balanceSub": 0.0,
       "balanceLesson": 0,
       "status":0,
       "commentary":""


      },


      {
       "id":2,
       "name": "Абонемент на 12 занятий Свобода",
       "dateStart":"2024-02-01",
       "dateEnd":"2024-05-01",
       "price": 12150.0,
       "priceOneLesson": 1012.5,
       "balanceSub": 8100.0,
       "balanceLesson": 9,
       "status":1,
       "commentary":"1 бонусный урок за отзывы"


      },


     ],

     "lessons":[

      {
       "id": 1,
       "idSub":1,
       "date": "2023-11-01",
       "timePeriod": "12:00-13:00",
       "idAuditory": "Авангард",
       "nameTeacher":"Перова Анастасия",
       "timeAccept": "",
       "bonus":false,
       "status": 7
      },

      {
       "id": 2,
       "idSub":1,
       "date": "2023-12-01",
       "timePeriod": "12:00-13:00",
       "idAuditory": "Авангард",
       "nameTeacher":"Перова Анастасия",
       "timeAccept": "2023-12-01",
       "bonus":false,
       "status": 2
      },

      {
       "id": 3,
       "idSub":1,
       "date": "2023-12-08",
       "timePeriod": "12:00-13:00",
       "idAuditory": "Авангард",
       "nameTeacher":"Перова Анастасия",
       "timeAccept": "2023-12-08",
       "bonus":false,
       "status": 2
      },

      {
       "id": 4,
       "idSub":1,
       "date": "2023-12-15",
       "timePeriod": "12:00-13:00",
       "idAuditory": "Авангард",
       "nameTeacher":"Перова Анастасия",
       "timeAccept": "",
       "bonus":false,
       "status": 3
      },
      {
       "id": 5,
       "idSub":1,
       "date": "2023-12-21",
       "timePeriod": "12:00-13:00",
       "idAuditory": "Опера",
       "nameTeacher":"Базарова Анна",
       "timeAccept": "2023-12-21",
       "bonus":false,
       "status": 2
      },

      {
       "id": 6,
       "idSub":1,
       "date": "2024-12-28",
       "timePeriod": "12:00-13:00",
       "idAuditory": "Авангард",
       "nameTeacher":"Перова Анастасия",
       "timeAccept": "2024-12-28",
       "bonus":false,
       "status": 2
      },


      {
       "id": 7,
       "idSub":2,
       "date": "2024-01-04",
       "timePeriod": "12:00-13:00",
       "idAuditory": "Авангард",
       "nameTeacher":"Перова Анастасия",
       "timeAccept": "2024-01-04",
       "bonus":false,
       "status": 2
      },

      {
       "id": 8,
       "idSub":2,
       "date": "2024-01-11",
       "timePeriod": "12:00-13:00",
       "idAuditory": "Авангард",
       "nameTeacher":"Перова Анастасия",
       "timeAccept": "2024-01-11",
       "bonus":false,
       "status": 2
      },

      {
       "id": 9,
       "idSub":2,
       "date": "2024-01-25",
       "timePeriod": "12:00-13:00",
       "idAuditory": "Авангард",
       "nameTeacher":"Перова Анастасия",
       "timeAccept": "2024-01-25",
       "bonus":false,
       "status": 2
      },


      {
       "id": 10,
       "idSub":2,
       "date": "2024-02-01",
       "timePeriod": "12:00-13:00",
       "idAuditory": "Авангард",
       "nameTeacher":"Перова Анастасия",
       "timeAccept": "2024-02-01",
       "bonus":false,
       "status": 2
      },

      {
       "id": 11,
       "idSub":2,
       "date": "2024-02-08",
       "timePeriod": "12:00-13:00",
       "idAuditory": "Авангард",
       "nameTeacher":"Перова Анастасия",
       "timeAccept": "2024-02-0",
       "bonus":false,
       "status": 2
      },


      {
       "id": 12,
       "idSub":2,
       "date": "2024-02-16",
       "timePeriod": "12:00-13:00",
       "idAuditory": "Авангард",
       "nameTeacher":"Перова Анастасия",
       "timeAccept": "",
       "bonus":false,
       "status": 4
      },

      {
       "id": 13,
       "idSub":2,
       "date": "2024-02-23",
       "timePeriod": "12:00-13:00",
       "idAuditory": "Авангард",
       "nameTeacher":"Перова Анастасия",
       "timeAccept": "",
       "bonus":false,
       "status": 4
      },


      {
       "id": 14,
       "idSub":2,
       "date": "2024-03-01",
       "timePeriod": "12:00-13:00",
       "idAuditory": "Авангард",
       "nameTeacher":"Перова Анастасия",
       "timeAccept": "",
       "bonus":false,
       "status": 1
      },

      {
       "id": 15,
       "idSub":2,
       "date": "2024-03-05",
       "timePeriod": "12:00-13:00",
       "idAuditory": "Авангард",
       "nameTeacher":"Перова Анастасия",
       "timeAccept": "",
       "bonus":false,
       "status": 1
      },


      {
       "id": 16,
       "idSub":2,
       "date": "2024-03-08",
       "timePeriod": "12:00-13:00",
       "idAuditory": "Авангард",
       "nameTeacher":"Перова Анастасия",
       "timeAccept": "",
       "bonus":false,
       "status": 1
      },


      {
       "id": 17,
       "idSub":2,
       "date": "2024-03-11",
       "timePeriod": "12:00-13:00",
       "idAuditory": "Авангард",
       "nameTeacher":"Перова Анастасия",
       "timeAccept": "",
       "bonus":false,
       "status": 1
      },


      {
       "id": 18,
       "idSub":2,
       "date": "2024-03-14",
       "timePeriod": "12:00-13:00",
       "idAuditory": "Авангард",
       "nameTeacher":"Перова Анастасия",
       "timeAccept": "",
       "bonus":false,
       "status": 1
      },
      {
       "id": 19,
       "idSub":2,
       "date": "2024-04-19",
       "timePeriod": "12:00-13:00",
       "idAuditory": "Авангард",
       "nameTeacher":"Перова Анастасия",
       "timeAccept": "",
       "bonus":false,
       "status": 1
      },
      {
       "id": 20,
       "idSub":2,
       "date": "2024-03-23",
       "timePeriod": "12:00-13:00",
       "idAuditory": "Авангард",
       "nameTeacher":"Перова Анастасия",
       "timeAccept": "",
       "bonus":false,
       "status": 1
      },

      {
       "id": 21,
       "idSub":2,
       "date": "2024-03-27",
       "timePeriod": "12:00-13:00",
       "idAuditory": "Авангард",
       "nameTeacher":"Перова Анастасия",
       "timeAccept": "",
       "bonus":false,
       "status": 1
      },

      {
       "id": 22,
       "idSub":2,
       "date": "2024-04-01",
       "timePeriod": "12:00-13:00",
       "idAuditory": "Авангард",
       "nameTeacher":"Перова Анастасия",
       "timeAccept": "",
       "bonus":true,
       "status": 1
      },




     ]




    }

   ]
  };