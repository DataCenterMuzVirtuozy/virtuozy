


 import 'package:virtuozy/data/models/price_subscription_model.dart';
import 'package:virtuozy/data/models/subscription_model.dart';

class PricesDirectionModel{

  final String nameDirection;
  final List<PriceSubscriptionModel> subscriptions;

  const PricesDirectionModel({
    required this.nameDirection,
    required this.subscriptions,
  });



  factory PricesDirectionModel.fromMap(Map<String, dynamic> map) {

    final list = (map['subscriptions'] as List<Map<String,dynamic>>).map((e) => PriceSubscriptionModel.fromMap(e)).toList();
    return PricesDirectionModel(
      nameDirection: map['nameDirection'] as String,
      subscriptions: list,
    );
  }
}