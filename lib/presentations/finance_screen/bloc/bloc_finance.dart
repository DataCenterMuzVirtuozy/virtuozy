


 import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtuozy/di/locator.dart';
import 'package:virtuozy/domain/repository/finance_repository.dart';
import 'package:virtuozy/presentations/finance_screen/bloc/event_finance.dart';
import 'package:virtuozy/presentations/finance_screen/bloc/state_finance.dart';
import 'package:virtuozy/utils/failure.dart';

import '../../../domain/user_cubit.dart';

class BlocFinance extends Bloc<EventFinance,StateFinance>{
  BlocFinance():super(StateFinance.unknown()){
    on<GetListSubscriptionsEvent>(_getPriceSubscription);
    on<GetBalanceSubscriptionEvent>(_getBalanceSubscription);
    on<PaySubscriptionEvent>(_paySubscription);
  }

  final _financeRepository = locator.get<FinanceRepository>();
  final _userCubit = locator.get<UserCubit>();


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



  void _getBalanceSubscription(GetBalanceSubscriptionEvent event,emit) async {
    emit(state.copyWith(status: FinanceStatus.loading));
    final user  = _userCubit.userEntity;
    final directions = _userCubit.userEntity.directions;
    emit(state.copyWith(status: FinanceStatus.loaded,user: user,directions: directions));

  }

  void _paySubscription(PaySubscriptionEvent event,emit) async {
    try{
      emit(state.copyWith(status: FinanceStatus.payment));
      await Future.delayed(const Duration(seconds: 1));
      //todo update user
      emit(state.copyWith(status: FinanceStatus.paymentComplete));
    }on Failure catch(e){

    }
  }





 }

