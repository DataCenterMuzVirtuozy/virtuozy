

 import 'package:equatable/equatable.dart';
import 'package:virtuozy/domain/entities/prices_direction_entity.dart';

import '../../../../domain/entities/price_subscription_entity.dart';
import '../../../../domain/entities/subscription_entity.dart';
import '../../../../domain/entities/transaction_entity.dart';
import '../../../../domain/entities/user_entity.dart';


enum FinanceStatus{

   loading,
   loaded,
   error,
   unknown
 }


 enum PaymentStatus{
   payment,
   paymentComplete,
   paymentError,
   loading,
   loaded,
   unknown
 }


 enum ListTransactionStatus{
  loading,
   loaded,
   error,
   refresh,
   unknown
 }

 enum ApplyBonusStatus{
   loading,
   loaded,
   error,
   unknown
 }




 class StateFinance extends Equatable{


  final FinanceStatus status;
  final PaymentStatus paymentStatus;
  final ApplyBonusStatus applyBonusStatus;
  final ListTransactionStatus listTransactionStatus;
  final String error;
  final PricesDirectionEntity pricesDirectionEntity;
  final UserEntity user;
  final List<DirectionLesson> directions;
  final List<TransactionEntity> transactions;
  final List<SubscriptionEntity> expiredSubscriptions;
  final List<PriceSubscriptionEntity> pricesSubscriptionsAll;
  final List<SubscriptionEntity> subscriptionHistory;
  final List<String> titlesDrawingMenu;

  const StateFinance({
    required this.subscriptionHistory,
    required this.pricesSubscriptionsAll,
    required this.expiredSubscriptions,
    required this.titlesDrawingMenu,
    required this.applyBonusStatus,
    required this.listTransactionStatus,
    required this.paymentStatus,
    required this.transactions,
    required this.directions,
    required this.user,
    required this.status,
    required this.error,
    required this.pricesDirectionEntity,
  });


  factory StateFinance.unknown(){
    return StateFinance(
        subscriptionHistory : const [],
      pricesSubscriptionsAll: const [],
      expiredSubscriptions: const [],
      titlesDrawingMenu: const [],
      applyBonusStatus: ApplyBonusStatus.unknown,
      listTransactionStatus: ListTransactionStatus.unknown,
      paymentStatus: PaymentStatus.unknown,
      transactions: const [],
      directions: const [],
      user: UserEntity.unknown(),
        status: FinanceStatus.unknown,
        error: '',
        pricesDirectionEntity: PricesDirectionEntity.unknown());
  }

  StateFinance copyWith({
    List<SubscriptionEntity>? expiredSubscriptions,
    List<TransactionEntity>? transactions,
    List<DirectionLesson>? directions,
    FinanceStatus? status,
    PaymentStatus? paymentStatus,
    ListTransactionStatus? listTransactionStatus,
    String? error,
    PricesDirectionEntity? pricesDirectionEntity,
    UserEntity? user,
    ApplyBonusStatus? applyBonusStatus,
    List<String>? titlesDrawingMenu,
    List<PriceSubscriptionEntity>? pricesSubscriptionsAll,
    List<SubscriptionEntity>? subscriptionHistory
  }) {
    return StateFinance(
      subscriptionHistory: subscriptionHistory??this.subscriptionHistory,
      pricesSubscriptionsAll: pricesSubscriptionsAll??this.pricesSubscriptionsAll,
      expiredSubscriptions: expiredSubscriptions??this.expiredSubscriptions,
      titlesDrawingMenu: titlesDrawingMenu??this.titlesDrawingMenu,
      applyBonusStatus: applyBonusStatus??this.applyBonusStatus,
      listTransactionStatus: listTransactionStatus??this.listTransactionStatus,
      paymentStatus: paymentStatus??this.paymentStatus,
      transactions: transactions??this.transactions,
      directions: directions??this.directions,
      user: user??this.user,
      status: status ?? this.status,
      error: error ?? this.error,
      pricesDirectionEntity:
          pricesDirectionEntity ?? this.pricesDirectionEntity,
    );
  }

  @override
  List<Object?> get props => [
    applyBonusStatus,
    expiredSubscriptions,
    listTransactionStatus,
    paymentStatus,
    transactions,
    directions,
    user,
    status,
    error,
    titlesDrawingMenu,
    pricesDirectionEntity];
}