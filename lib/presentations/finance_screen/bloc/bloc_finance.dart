


 import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtuozy/di/locator.dart';
import 'package:virtuozy/domain/repository/finance_repository.dart';
import 'package:virtuozy/presentations/finance_screen/bloc/event_finance.dart';
import 'package:virtuozy/presentations/finance_screen/bloc/state_finance.dart';
import 'package:virtuozy/utils/failure.dart';

class BlocFinance extends Bloc<EventFinance,StateFinance>{
  BlocFinance():super(StateFinance.unknown()){
    on<GetListSubscriptionsEvent>(_getPriceSubscription);
  }

  final _financeRepository = locator.get<FinanceRepository>();


  void _getPriceSubscription(GetListSubscriptionsEvent event,emit) async {
    try{
      emit(state.copyWith(status: FinanceStatus.loading));
      await Future.delayed(const Duration(seconds: 2));
      final prices = await _financeRepository.getSubscriptionsByDirection(nameDirection: event.nameDirection);
      emit(state.copyWith(status: FinanceStatus.loaded,pricesDirectionEntity: prices));
    }on Failure catch(e){
      emit(state.copyWith(status: FinanceStatus.error,error: e.message));
    }
  }

 }