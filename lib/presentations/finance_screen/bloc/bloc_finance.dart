


 import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtuozy/di/locator.dart';
import 'package:virtuozy/domain/entities/price_subscription_entity.dart';
import 'package:virtuozy/domain/entities/user_entity.dart';
import 'package:virtuozy/domain/repository/finance_repository.dart';
import 'package:virtuozy/presentations/finance_screen/bloc/event_finance.dart';
import 'package:virtuozy/presentations/finance_screen/bloc/state_finance.dart';
import 'package:virtuozy/utils/failure.dart';
import 'package:virtuozy/utils/update_list_ext.dart';

import '../../../domain/entities/transaction_entity.dart';
import '../../../domain/user_cubit.dart';

class BlocFinance extends Bloc<EventFinance,StateFinance>{
  BlocFinance():super(StateFinance.unknown()){
    on<GetListSubscriptionsEvent>(_getPriceSubscription);
    on<GetBalanceSubscriptionEvent>(_getBalanceSubscription);
    on<PaySubscriptionEvent>(_paySubscription);
    on<GetListTransactionsEvent>(_getListTransaction);
  }

  final _financeRepository = locator.get<FinanceRepository>();
  final _userCubit = locator.get<UserCubit>();
  List<TransactionEntity> _listTransaction = [];


  void _getListTransaction(GetListTransactionsEvent event,emit) async {
     try{
       emit(state.copyWith(listTransactionStatus: ListTransactionStatus.loading));
       await Future.delayed(const Duration(seconds: 1));
       print('List ${_listTransaction.length}');
       emit(state.copyWith(listTransactionStatus: ListTransactionStatus.loaded,transactions: _listTransaction));
     }on Failure catch(e){
       emit(state.copyWith(listTransactionStatus: ListTransactionStatus.error,error: e.message));
     }
  }


  void _getPriceSubscription(GetListSubscriptionsEvent event,emit) async {
    try{
      emit(state.copyWith(paymentStatus: PaymentStatus.loading));
      await Future.delayed(const Duration(seconds: 1));
      final prices = await _financeRepository.getSubscriptionsByDirection(nameDirection: event.nameDirection);
      emit(state.copyWith(paymentStatus: PaymentStatus.loaded,pricesDirectionEntity: prices));
    }on Failure catch(e){
      emit(state.copyWith(paymentStatus: PaymentStatus.paymentError,error: e.message));
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
      emit(state.copyWith(paymentStatus: PaymentStatus.payment));
      await Future.delayed(const Duration(seconds: 1));
      _updateDirectionUser(
          priceSubscriptionEntity: event.priceSubscriptionEntity,
          currentDirection: event.currentDirection);
      emit(state.copyWith(paymentStatus: PaymentStatus.paymentComplete));
    }on Failure catch(e){

    }
  }


  void _updateDirectionUser({required PriceSubscriptionEntity priceSubscriptionEntity,required DirectionLesson currentDirection}){
    final user = _userCubit.userEntity;
    final directions = user.directions;
    final newBalance = currentDirection.subscription.balanceLesson + priceSubscriptionEntity.quantityLesson;
    final newBalanceSub = currentDirection.subscription.balanceSub + priceSubscriptionEntity.price;
    final supUpdate = currentDirection.subscription.copyWith(
      balanceLesson: newBalance,
      balanceSub: newBalanceSub
    );
    final updateDirection = currentDirection.copyWith(subscription: supUpdate);
    final indexDirection = directions.indexWhere((element) => element.name == currentDirection.name);
    final finalDirectionList = directions.update(indexDirection,updateDirection);
    final newUser = user.copyWith(directions: finalDirectionList);
    _userCubit.updateUser(newUser: newUser);
    _listTransaction.add(TransactionEntity(
        typeTransaction: TypeTransaction.addBalance,
        time: DateTime.now().toString(),
        quantity: newBalanceSub));


  }





 }

