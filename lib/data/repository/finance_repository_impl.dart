


 import 'package:virtuozy/di/locator.dart';
import 'package:virtuozy/domain/entities/price_subscription_entity.dart';
import 'package:virtuozy/domain/entities/prices_direction_entity.dart';
import 'package:virtuozy/domain/entities/subscription_entity.dart';
import 'package:virtuozy/domain/entities/transaction_entity.dart';
import 'package:virtuozy/domain/repository/finance_repository.dart';

import '../utils/finance_util.dart';

class FinanceRepositoryImpl extends FinanceRepository{

 final _util = locator.get<FinanceUtil>();

  @override
  Future<PricesDirectionEntity> getSubscriptionsByDirection({required String nameDirection}) async {
   return _util.getSubscriptionsByDirection(nameDirection: nameDirection);
  }

  @override
  Future<List<PriceSubscriptionEntity>> getSubscriptionsAll() async {
    return _util.getSubscriptionsAll();
  }

  @override
  Future<int> baySubscription({required SubscriptionEntity subscriptionEntity}) async {
    return await _util.baySubscription(subscriptionEntity: subscriptionEntity);
  }

  @override
  Future<List<TransactionEntity>> getTransactions({required int idUser, required int idDirections}) async {
    return await _util.getTransactions(idUser: idUser, idDirections: idDirections);
  }

  @override
  Future<void> addTransaction({required TransactionEntity transactionEntity})  async {
    await _util.addTransaction(transactionEntity: transactionEntity);
  }

}