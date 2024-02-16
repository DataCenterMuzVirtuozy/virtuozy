


 import 'package:virtuozy/utils/failure.dart';

import '../models/user_model.dart';

class UserService{


   Future<UserModel> getUser() async {
    try{
       await Future.delayed(const Duration(seconds: 2));
        return UserModel.fromMap(_user);
    } on Failure catch(e){
       throw const Failure('Error get user');
    }
   }

 }


  final Map<String,dynamic> _user = {
   'lastName': 'Данилов',
   'firstName': 'Евгений',
   'branchName': 'Москва',
   'phoneNumber': '+1(111)111-11-11',
   'userStatus': 1,
   'userType': 1,
   'directions': [
    {
     'bonus': [],
     'balance': 10000.0,
     //todo добавить поле priceLesson and quantityLessonLeft
     'name': 'Бас-гитара',
     'lessons': [
      {
       'id':1,
       'date': '2024-02-01',
       'timePeriod': '12:00-13:00',
       'idAuditory': 120,
       'nameTeacher': 'Данилина Д.Д.',
        'timeAccept':'',
       'status': 7,
      },
      {
       'id':2,
       'date': '2024-02-03',
       'timePeriod': '12:00-13:00',
       'idAuditory': 120,
       'nameTeacher': 'Данилина Д.Д.',
       'timeAccept':'',
       'status': 6,
      },
      {
       'id':3,
       'date': '2024-02-04',
       'timePeriod': '12:00-13:00',
       'idAuditory': 120,
       'nameTeacher': 'Данилина Д.Д.',
       'timeAccept':'',
       'status': 4,
      },
      {
       'id':4,
       'date': '2024-02-07',
       'timePeriod': '12:00-13:00',
       'idAuditory': 120,
       'nameTeacher': 'Данилина Д.Д.',
       'timeAccept':'',
       'status': 5,
      },
      {
       'id':5,
       'date': '2024-02-08',
       'timePeriod': '12:00-13:00',
       'idAuditory': 120,
       'nameTeacher': 'Данилина Д.Д.',
       'timeAccept':'2024-02-08/12:50',
       'status': 2,
      },
      {
       'id':6,
       'date': '2024-02-10',
       'timePeriod': '12:00-13:00',
       'idAuditory': 120,
       'nameTeacher': 'Данилина Д.Д.',
       'timeAccept':'',
       'status': 3,
      },
      {
       'id':7,
       'date': '2024-02-13',
       'timePeriod': '12:00-13:00',
       'idAuditory': 120,
       'nameTeacher': 'Данилина Д.Д.',
       'timeAccept':'',
       'status': 1,
      },
      {
       'id':8,
       'date': '2024-02-16',
       'timePeriod': '12:00-13:00',
       'idAuditory': 120,
       'nameTeacher': 'Данилина Д.Д.',
       'timeAccept':'',
       'status': 1,
      },
      {
       'id':9,
       'date': '2024-02-22',
       'timePeriod': '12:00-13:00',
       'idAuditory': 120,
       'nameTeacher': 'Данилина Д.Д.',
       'timeAccept':'',
       'status': 8,
      },
      {
       'id':10,
       'date': '2024-02-25',
       'timePeriod': '12:00-13:00',
       'idAuditory': 120,
       'nameTeacher': 'Данилина Д.Д.',
       'timeAccept':'',
       'status': 1,
      },
      {
       'id':11,
       'date': '2024-02-28',
       'timePeriod': '12:00-13:00',
       'idAuditory': 120,
       'nameTeacher': 'Данилина Д.Д.',
       'timeAccept':'',
       'status': 8,
      },

     ],
    }
   ],
  };