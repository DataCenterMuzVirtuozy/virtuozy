

 import 'package:equatable/equatable.dart';
import 'package:virtuozy/domain/entities/price_subscription_entity.dart';

class EventFinance extends Equatable{
  @override
  List<Object?> get props => [];

  const EventFinance();
}


class GetListSubscriptionsEvent extends EventFinance{
  final String nameDirection;

  const GetListSubscriptionsEvent({
    required this.nameDirection,
  });
}

class GetBalanceSubscriptionEvent extends EventFinance{
  final int indexDirection;

  const GetBalanceSubscriptionEvent({required this.indexDirection});
}

class PaySubscriptionEvent extends EventFinance{
  final PriceSubscriptionEntity priceSubscriptionEntity;

  const PaySubscriptionEvent({required this.priceSubscriptionEntity});
}