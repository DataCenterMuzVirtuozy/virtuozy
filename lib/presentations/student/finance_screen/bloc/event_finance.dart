

 import 'package:equatable/equatable.dart';
import 'package:virtuozy/domain/entities/price_subscription_entity.dart';
import 'package:virtuozy/domain/entities/user_entity.dart';

import '../../../../domain/entities/lesson_entity.dart';

class EventFinance extends Equatable{
  @override
  List<Object?> get props => [];

  const EventFinance();
}


class GetListSubscriptionsEvent extends EventFinance{
  final String nameDirection;
  final bool refreshDirection;

  const GetListSubscriptionsEvent({
    required this.refreshDirection,
    required this.nameDirection,
  });
}

class GetBalanceSubscriptionEvent extends EventFinance{
  final int indexDirection;
  final bool allViewDir;
  final bool refreshDirection;
  const GetBalanceSubscriptionEvent( {
    required this.refreshDirection,
    required this.allViewDir,required this.indexDirection});
}


 class ApplyBonusEvent extends EventFinance{
   final int idBonus;
   final DirectionLesson currentDirection;
   const ApplyBonusEvent({required this.idBonus, required this.currentDirection});
 }

class PaySubscriptionEvent extends EventFinance{
  final DirectionLesson currentDirection;
  final PriceSubscriptionEntity priceSubscriptionEntity;

  const PaySubscriptionEvent({
    required this.priceSubscriptionEntity,required this.currentDirection});
}
class GetListTransactionsEvent extends EventFinance{
  final List<DirectionLesson> directions;

  const GetListTransactionsEvent({
    required this.directions,
  });
}

 class WritingOfMoneyEvent extends EventFinance{
   final DirectionLesson currentDirection;
   final Lesson lessonConfirm;


  const WritingOfMoneyEvent({required this.currentDirection,required this.lessonConfirm});
 }