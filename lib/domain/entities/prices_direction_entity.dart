


 import 'package:virtuozy/domain/entities/price_subscription_entity.dart';

class PricesDirectionEntity{

  final String nameDirection;
  final List<PriceSubscriptionEntity> subscriptions;

  const PricesDirectionEntity({
    required this.nameDirection,
    required this.subscriptions,
  });


  factory PricesDirectionEntity.unknown(){
   return const PricesDirectionEntity(nameDirection: '',subscriptions: []);
  }

  PricesDirectionEntity copyWith({
    String? nameDirection,
    List<PriceSubscriptionEntity>? subscriptions,
  }) {
    return PricesDirectionEntity(
      nameDirection: nameDirection ?? this.nameDirection,
      subscriptions: subscriptions ?? this.subscriptions,
    );
  }
}