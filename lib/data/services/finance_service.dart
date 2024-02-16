


 import 'package:virtuozy/data/models/prices_direction_model.dart';
import 'package:virtuozy/utils/failure.dart';

class FinanceService{




   Future<PricesDirectionModel> getSubscriptionsByDirection({required String nameDirection}) async {
     try{
       final listSub = _listPriceDirection.map((e) => PricesDirectionModel.fromMap(e)).toList();
       return listSub.firstWhere((element) => element.nameDirection == nameDirection);
     }on Failure catch(e){
        throw Failure(e.message);
     }
     }








  final List<Map<String,dynamic>> _listPriceDirection = [

  {
  'nameDirection': 'Бас-гитара',
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
      'nameDirection': 'Виолончель',
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


  ];



 }