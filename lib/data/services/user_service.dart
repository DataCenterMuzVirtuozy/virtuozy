


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
     'balance': 0.0,
     'name': 'Хор',
     'lessons': [
      {
       'date': '2024-02-01',
       'timePeriod': '12:00-13:00',
       'idAuditory': 120,
       'nameTeacher': 'Данилина Д.Д.',
       'status': 7,
      },
      {
       'date': '2024-02-03',
       'timePeriod': '12:00-13:00',
       'idAuditory': 120,
       'nameTeacher': 'Данилина Д.Д.',
       'status': 6,
      },
      {
       'date': '2024-02-04',
       'timePeriod': '12:00-13:00',
       'idAuditory': 120,
       'nameTeacher': 'Данилина Д.Д.',
       'status': 4,
      },
      {
       'date': '2024-02-07',
       'timePeriod': '12:00-13:00',
       'idAuditory': 120,
       'nameTeacher': 'Данилина Д.Д.',
       'status': 5,
      },
      {
       'date': '2024-02-08',
       'timePeriod': '12:00-13:00',
       'idAuditory': 120,
       'nameTeacher': 'Данилина Д.Д.',
       'status': 2,
      },
      {
       'date': '2024-02-10',
       'timePeriod': '12:00-13:00',
       'idAuditory': 120,
       'nameTeacher': 'Данилина Д.Д.',
       'status': 3,
      },
      {
       'date': '2024-02-13',
       'timePeriod': '12:00-13:00',
       'idAuditory': 120,
       'nameTeacher': 'Данилина Д.Д.',
       'status': 1,
      },
      {
       'date': '2024-02-16',
       'timePeriod': '12:00-13:00',
       'idAuditory': 120,
       'nameTeacher': 'Данилина Д.Д.',
       'status': 1,
      },
      {
       'date': '2024-02-20',
       'timePeriod': '12:00-13:00',
       'idAuditory': 120,
       'nameTeacher': 'Данилина Д.Д.',
       'status': 1,
      },

     ],
    }
   ],
  };