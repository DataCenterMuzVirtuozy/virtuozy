


 import 'package:virtuozy/di/locator.dart';
import 'package:virtuozy/domain/entities/price_subscription_entity.dart';
import 'package:virtuozy/domain/entities/prices_direction_entity.dart';
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

}