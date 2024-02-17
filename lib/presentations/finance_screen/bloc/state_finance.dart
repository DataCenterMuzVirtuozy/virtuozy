

 import 'package:virtuozy/domain/entities/prices_direction_entity.dart';

import '../../../domain/entities/transaction_entity.dart';
import '../../../domain/entities/user_entity.dart';

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
   unknown
 }




 class StateFinance{


  final FinanceStatus status;
  final PaymentStatus paymentStatus;
  final ListTransactionStatus listTransactionStatus;
  final String error;
  final PricesDirectionEntity pricesDirectionEntity;
  final UserEntity user;
  final List<DirectionLesson> directions;
  final List<TransactionEntity> transactions;

  const StateFinance({
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
      listTransactionStatus: ListTransactionStatus.unknown,
      paymentStatus: PaymentStatus.unknown,
      transactions: [],
      directions: [],
      user: UserEntity.unknown(),
        status: FinanceStatus.unknown,
        error: '',
        pricesDirectionEntity: PricesDirectionEntity.unknown());
  }

  StateFinance copyWith({
    List<TransactionEntity>? transactions,
    List<DirectionLesson>? directions,
    FinanceStatus? status,
    PaymentStatus? paymentStatus,
    ListTransactionStatus? listTransactionStatus,
    String? error,
    PricesDirectionEntity? pricesDirectionEntity,
    UserEntity? user
  }) {
    return StateFinance(
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
}