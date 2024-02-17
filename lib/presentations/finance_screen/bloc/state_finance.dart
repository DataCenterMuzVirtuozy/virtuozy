

 import 'package:virtuozy/domain/entities/prices_direction_entity.dart';

import '../../../domain/entities/user_entity.dart';

enum FinanceStatus{
   payment,
   paymentComplete,
    paymentError,
   loading,
   loaded,
   error,
   unknown
 }

 class StateFinance{


  final FinanceStatus status;
  final String error;
  final PricesDirectionEntity pricesDirectionEntity;
  final UserEntity user;
  final List<DirectionLesson> directions;

  const StateFinance({
    required this.directions,
    required this.user,
    required this.status,
    required this.error,
    required this.pricesDirectionEntity,
  });


  factory StateFinance.unknown(){
    return StateFinance(
      directions: [],
      user: UserEntity.unknown(),
        status: FinanceStatus.unknown,
        error: '',
        pricesDirectionEntity: PricesDirectionEntity.unknown());
  }

  StateFinance copyWith({
    List<DirectionLesson>? directions,
    FinanceStatus? status,
    String? error,
    PricesDirectionEntity? pricesDirectionEntity,
    UserEntity? user
  }) {
    return StateFinance(
      directions: directions??this.directions,
      user: user??this.user,
      status: status ?? this.status,
      error: error ?? this.error,
      pricesDirectionEntity:
          pricesDirectionEntity ?? this.pricesDirectionEntity,
    );
  }
}