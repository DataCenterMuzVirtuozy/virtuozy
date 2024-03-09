

 import '../entities/price_subscription_entity.dart';
import '../entities/prices_direction_entity.dart';
import '../entities/subscription_entity.dart';
import '../entities/transaction_entity.dart';

abstract class FinanceRepository{

  Future<PricesDirectionEntity> getSubscriptionsByDirection({required String nameDirection});
  Future<List<PriceSubscriptionEntity>> getSubscriptionsAll();
  Future<int> baySubscription({required SubscriptionEntity subscriptionEntity});
  Future<List<TransactionEntity>> getTransactions({required int idUser,required int idDirections});
  Future<void> addTransaction({required TransactionEntity transactionEntity});
 }