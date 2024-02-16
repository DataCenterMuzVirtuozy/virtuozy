

 import 'package:virtuozy/data/models/price_subscription_model.dart';
import 'package:virtuozy/domain/entities/price_subscription_entity.dart';
import 'package:virtuozy/domain/entities/prices_direction_entity.dart';

import '../models/prices_direction_model.dart';

class PricesDirectionMapper{


   static PricesDirectionEntity fromApi({required PricesDirectionModel model}){
     return PricesDirectionEntity(
         nameDirection: model.nameDirection,
         subscriptions: fromApiPricesSubscription(subscriptions: model.subscriptions));
   }



   static List<PriceSubscriptionEntity> fromApiPricesSubscription({required List<PriceSubscriptionModel> subscriptions}){
     return subscriptions.map((e) => PriceSubscriptionEntity(
         name: e.name,
         price: e.price,
         priceOneLesson: e.priceOneLesson,
         quantityLesson: e.quantityLesson)).toList();
   }


 }