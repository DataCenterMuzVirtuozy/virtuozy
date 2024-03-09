


  import 'package:virtuozy/data/mappers/prices_direction_mapper.dart';
import 'package:virtuozy/data/mappers/transaction_mapper.dart';
import 'package:virtuozy/data/models/subscription_model.dart';
import 'package:virtuozy/data/models/transaction_model.dart';
import 'package:virtuozy/data/services/finance_service.dart';
import 'package:virtuozy/domain/entities/price_subscription_entity.dart';
import 'package:virtuozy/domain/entities/prices_direction_entity.dart';
import 'package:virtuozy/domain/entities/transaction_entity.dart';

import '../../di/locator.dart';
import '../../domain/entities/subscription_entity.dart';

class FinanceUtil{

   final _service = locator.get<FinanceService>();


   Future<PricesDirectionEntity> getSubscriptionsByDirection({required String nameDirection}) async {
     final result = await _service.getSubscriptionsByDirection(nameDirection: nameDirection);
     return PricesDirectionMapper.fromApi(model: result);
   }

   Future<List<PriceSubscriptionEntity>> getSubscriptionsAll() async {
      final res = await _service.getSubscriptionsAll();
      return PricesDirectionMapper.fromApiPricesSubscription(subscriptions: res);
   }


   Future<int> baySubscription({required SubscriptionEntity subscriptionEntity}) async {
     return await _service.baySubscription(subscriptionModelApi: SubscriptionModel.toMap(subscriptionEntity: subscriptionEntity));
   }


   Future<List<TransactionEntity>> getTransactions({required int idUser,required int idDirections}) async{
     final res = await _service.getTransactions(idUser: idUser, idDirections: idDirections);
     return res.map((e) => TransactionMapper.fromApi(transactionModel: e)).toList();
   }

   Future<void> addTransaction({required TransactionEntity transactionEntity}) async {
      await _service.addTransaction(transactionModelApi: TransactionModel.toMap(transactionEntity: transactionEntity));
   }

  }