

 import '../entities/prices_direction_entity.dart';

abstract class FinanceRepository{

  Future<PricesDirectionEntity> getSubscriptionsByDirection({required String nameDirection});

 }