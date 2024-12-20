


 import 'package:dio/dio.dart';
import 'package:virtuozy/data/models/price_subscription_model.dart';
import 'package:virtuozy/data/models/prices_direction_model.dart';
import 'package:virtuozy/data/models/subscription_model.dart';
import 'package:virtuozy/data/models/transaction_model.dart';
import 'package:virtuozy/domain/entities/subscription_entity.dart';
import 'package:virtuozy/domain/entities/user_entity.dart';
import 'package:virtuozy/utils/date_time_parser.dart';
import 'package:virtuozy/utils/failure.dart';

import '../../di/locator.dart';
import '../../utils/preferences_util.dart';
import '../rest/dio_client.dart';
import '../rest/endpoints.dart';

class FinanceService{


   Future<PricesDirectionModel> getSubscriptionsByDirection({required String nameDirection}) async {
     try{
       final listSub = _listPriceDirection.map((e) => PricesDirectionModel.fromMap(e)).toList();
       return listSub.firstWhere((element) => element.nameDirection == nameDirection);
     }on Failure catch(e){
        throw Failure(e.message);
     }
     }

   Future<List<PriceSubscriptionModel>> getSubscriptionsAll() async {
     try{
       final dioTest = locator.get<DioClient>().init(); //test
       //final dioApi = locator.get<DioClient>().initApi();
       await Future.delayed(const Duration(seconds: 1));
       final res = await dioTest.get(Endpoints.subscriptions);
       final subs = (res.data as List<dynamic>).map((e)=> PriceSubscriptionModel.fromMap(e)).toList();
        return subs;
     }on Failure catch(e){
       throw Failure(e.message);
     }
   }



   Future<int> baySubscription({required Map<String,dynamic> subscriptionModelApi}) async {
     try{
       //final dioTest = locator.get<DioClient>().init(); //test
       final dioApi = locator.get<DioClient>().initApi();
       final res = await dioApi.post(Endpoints.subsUser,data: subscriptionModelApi);
       return res.data['id'] as int;
     }on Failure catch(e){
       throw Failure(e.message);
     }on DioException catch(e){
       throw Failure(e.toString());
     }
   }

   Future<List<TransactionModel>> getTransactions({required int idUser,required int idDirections}) async {
     try{

         final dioApi = locator.get<DioClient>().initApi();
         final token =  PreferencesUtil.token;
         List<TransactionModel> transactions = [];
         final res = await dioApi.get(Endpoints.transactions,options: Options(
             headers: {'Authorization':'Bearer $token'}
         ),);
         transactions = (res.data['data'] as List<dynamic>).map((e)=> TransactionModel.fromMap(e)).toList();
         return transactions;
       }on Failure catch(e){
         throw Failure(e.message);
       }on DioException catch(e){
         throw Failure(e.toString());
       }

   }

  Future<void> addTransaction({required Map<String,dynamic> transactionModelApi}) async {
     try{
       //final dioInit = locator.get<DioClient>().init(); //test
       final dioApi = locator.get<DioClient>().initApi();
        await dioApi.post(Endpoints.transactions,data: transactionModelApi);
      }on Failure catch(e){
        throw Failure(e.message);
      }on DioException catch(e){
        throw Failure(e.toString());
      }

  }










  final List<Map<String,dynamic>> _listPriceDirection = [

  {
  'nameDirection': 'Бас-гитара',
  'subscriptions': [
    {
      'name': 'Абонемент “Утренний” 10 уроков',
      'price':  10000.0,
      'priceOneLesson':  1000.0,
      'quantityLesson':10,


    },
    {
      'name': 'Абонемент “Утренний” 20 уроков',
      'price':  20000.0,
      'priceOneLesson':  1000.0,
      'quantityLesson': 20 ,
    },
    {
      'name': 'Абонемент “Утренний” 30 уроков',
      'price':  30000.0,
      'priceOneLesson': 1000.0 ,
      'quantityLesson' : 30,


    },

  ],
 },

    {
      'nameDirection': 'Скрипка',
      'subscriptions': [
        {
          'name': 'Абонемент 1',
          'price':  10000.0,
          'priceOneLesson':  1000.0,
          'quantityLesson':10,


        },
        {
          'name': 'Абонемент 2',
          'price':  20000.0,
          'priceOneLesson':  1000.0,
          'quantityLesson': 20 ,
        },
        {
          'name': 'Абонемент 3',
          'price':  30000.0,
          'priceOneLesson': 1000.0 ,
          'quantityLesson' : 30,


        },

      ],
    },

    {
      'nameDirection': 'Балалайка',
      'subscriptions': [
        {
          'name': 'Абонемент 1',
          'price':  10000.0,
          'priceOneLesson':  1000.0,
          'quantityLesson':10,


        },
        {
          'name': 'Абонемент 2',
          'price':  20000.0,
          'priceOneLesson':  1000.0,
          'quantityLesson': 20 ,
        },
        {
          'name': 'Абонемент 3',
          'price':  30000.0,
          'priceOneLesson': 1000.0 ,
          'quantityLesson' : 30,


        },

      ],
    },


    {
      'nameDirection': 'Вокал',
      'subscriptions': [
        {
          'name': 'Абонемент 1',
          'price':  10000.0,
          'priceOneLesson':  1000.0,
          'quantityLesson':10,


        },
        {
          'name': 'Абонемент 2',
          'price':  20000.0,
          'priceOneLesson':  1000.0,
          'quantityLesson': 20 ,
        },
        {
          'name': 'Абонемент 3',
          'price':  30000.0,
          'priceOneLesson': 1000.0 ,
          'quantityLesson' : 30,


        },

      ],
    },

    {
      'nameDirection': 'Саксофон',
      'subscriptions': [
        {
          'name': 'Абонемент 1',
          'price':  10000.0,
          'priceOneLesson':  1000.0,
          'quantityLesson':10,


        },
        {
          'name': 'Абонемент 2',
          'price':  20000.0,
          'priceOneLesson':  1000.0,
          'quantityLesson': 20 ,
        },
        {
          'name': 'Абонемент 3',
          'price':  30000.0,
          'priceOneLesson': 1000.0 ,
          'quantityLesson' : 30,


        },

      ],
    },

    {
      'nameDirection': 'Фортепиано',
      'subscriptions': [
        {
          'name': 'Абонемент 1',
          'price':  10000.0,
          'priceOneLesson':  1000.0,
          'quantityLesson':10,


        },
        {
          'name': 'Абонемент 2',
          'price':  20000.0,
          'priceOneLesson':  1000.0,
          'quantityLesson': 20 ,
        },
        {
          'name': 'Абонемент 3',
          'price':  30000.0,
          'priceOneLesson': 1000.0 ,
          'quantityLesson' : 30,


        },

      ],
    },


    {
      'nameDirection': 'Классическая гитара',
      'subscriptions': [
        {
          'name': 'Абонемент 1',
          'price':  10000.0,
          'priceOneLesson':  1000.0,
          'quantityLesson':10,


        },
        {
          'name': 'Абонемент 2',
          'price':  20000.0,
          'priceOneLesson':  1000.0,
          'quantityLesson': 20 ,
        },
        {
          'name': 'Абонемент 3',
          'price':  30000.0,
          'priceOneLesson': 1000.0 ,
          'quantityLesson' : 30,


        },

      ],
    },
    {
      'nameDirection': 'Ударные',
      'subscriptions': [
        {
          'name': 'Абонемент 1',
          'price':  10000.0,
          'priceOneLesson':  1000.0,
          'quantityLesson':10,


        },
        {
          'name': 'Абонемент 2',
          'price':  20000.0,
          'priceOneLesson':  1000.0,
          'quantityLesson': 20 ,
        },
        {
          'name': 'Абонемент 3',
          'price':  30000.0,
          'priceOneLesson': 1000.0 ,
          'quantityLesson' : 30,


        },

      ],
    },

    {
      'nameDirection': 'Аккордеон',
      'subscriptions': [
        {
          'name': 'Абонемент 1',
          'price':  10000.0,
          'priceOneLesson':  1000.0,
          'quantityLesson':10,


        },
        {
          'name': 'Абонемент 2',
          'price':  20000.0,
          'priceOneLesson':  1000.0,
          'quantityLesson': 20 ,
        },
        {
          'name': 'Абонемент 3',
          'price':  30000.0,
          'priceOneLesson': 1000.0 ,
          'quantityLesson' : 30,


        },

      ],
    },

    {
      'nameDirection': 'Баян',
      'subscriptions': [
        {
          'name': 'Абонемент “Утренний” 10 уроков',
          'price':  10000.0,
          'priceOneLesson':  1000.0,
          'quantityLesson':10,


        },
        {
          'name': 'Абонемент “Утренний” 20 уроков',
          'price':  20000.0,
          'priceOneLesson':  1000.0,
          'quantityLesson': 20 ,
        },
        {
          'name': 'Абонемент “Утренний” 30 уроков',
          'price':  30000.0,
          'priceOneLesson': 1000.0 ,
          'quantityLesson' : 30,


        },

      ],
    },

    {
      'nameDirection': 'Виолончель',
      'subscriptions': [
        {
          'name': 'Абонемент “Утренний” 10 уроков',
          'price':  10000.0,
          'priceOneLesson':  1000.0,
          'quantityLesson':10,


        },
        {
          'name': 'Абонемент “Утренний” 20 уроков',
          'price':  20000.0,
          'priceOneLesson':  1000.0,
          'quantityLesson': 20 ,
        },
        {
          'name': 'Абонемент “Утренний” 30 уроков',
          'price':  30000.0,
          'priceOneLesson': 1000.0 ,
          'quantityLesson' : 30,


        },

      ],
    },


  ];



 }