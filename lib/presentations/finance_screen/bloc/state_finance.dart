

 import 'package:virtuozy/domain/entities/prices_direction_entity.dart';

enum FinanceStatus{
   loading,
   loaded,
   error,
   unknown
 }

 class StateFinance{


  final FinanceStatus status;
  final String error;
  final PricesDirectionEntity pricesDirectionEntity;

  const StateFinance({
    required this.status,
    required this.error,
    required this.pricesDirectionEntity,
  });


  factory StateFinance.unknown(){
    return StateFinance(
        status: FinanceStatus.unknown,
        error: '',
        pricesDirectionEntity: PricesDirectionEntity.unknown());
  }

  StateFinance copyWith({
    FinanceStatus? status,
    String? error,
    PricesDirectionEntity? pricesDirectionEntity,
  }) {
    return StateFinance(
      status: status ?? this.status,
      error: error ?? this.error,
      pricesDirectionEntity:
          pricesDirectionEntity ?? this.pricesDirectionEntity,
    );
  }
}