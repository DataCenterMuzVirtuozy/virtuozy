

 import '../entities/price_subscription_entity.dart';
import '../entities/prices_direction_entity.dart';
import '../entities/subscription_entity.dart';

abstract class FinanceRepository{

  Future<PricesDirectionEntity> getSubscriptionsByDirection({required String nameDirection});
  Future<List<PriceSubscriptionEntity>> getSubscriptionsAll();
  Future<int> baySubscription({required SubscriptionEntity subscriptionEntity});
 }