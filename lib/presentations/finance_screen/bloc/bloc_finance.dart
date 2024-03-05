


 import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtuozy/di/locator.dart';
import 'package:virtuozy/domain/entities/price_subscription_entity.dart';
import 'package:virtuozy/domain/entities/subscription_entity.dart';
import 'package:virtuozy/domain/entities/user_entity.dart';
import 'package:virtuozy/domain/repository/finance_repository.dart';
import 'package:virtuozy/presentations/finance_screen/bloc/event_finance.dart';
import 'package:virtuozy/presentations/finance_screen/bloc/state_finance.dart';
import 'package:virtuozy/presentations/subscription_screen/bloc/sub_state.dart';
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
    on<WritingOfMoneyEvent>(_writingOffMoney);
    on<ApplyBonusEvent>(_applyBonus);
  }

  final _financeRepository = locator.get<FinanceRepository>();
  final _userCubit = locator.get<UserCubit>();
  List<TransactionEntity> _listTransaction = [];


  void _getListTransaction(GetListTransactionsEvent event,emit) async {
     try{
       emit(state.copyWith(listTransactionStatus: ListTransactionStatus.loading));
       await Future.delayed(const Duration(seconds: 1));
       _listTransaction = _listTransaction.reversed.toList();
       emit(state.copyWith(listTransactionStatus: ListTransactionStatus.loaded,transactions: _listTransaction));
     }on Failure catch(e){
       emit(state.copyWith(listTransactionStatus: ListTransactionStatus.error,error: e.message));
     }
  }


  void _getPriceSubscription(GetListSubscriptionsEvent event,emit) async {
    try{
      if(event.refreshDirection) {
        emit(state.copyWith(paymentStatus: PaymentStatus.loading));
        await Future.delayed(const Duration(seconds: 1));
      }

      final prices = await _financeRepository.getSubscriptionsAll();

      emit(state.copyWith(paymentStatus: PaymentStatus.loaded,pricesSubscriptionsAll: prices));
    }on Failure catch(e){
      emit(state.copyWith(paymentStatus: PaymentStatus.paymentError,error: e.message));
    }
  }



  void _getBalanceSubscription(GetBalanceSubscriptionEvent event,emit) async {
    if(event.refreshDirection){
      emit(state.copyWith(status: FinanceStatus.loading));
      await Future.delayed(const Duration(seconds: 1));
    }
    final user  = _userCubit.userEntity;
    if(user.userStatus == UserStatus.moderation || user.userStatus == UserStatus.notAuth){
      emit(state.copyWith(
          status: FinanceStatus.loaded));
      return;
    }
    final expiredSubscriptions = _getExpiredSubscriptions(user,event.allViewDir,event.indexDirection);
    final titlesDrawingMenu = _getTitlesDrawingMenu(directions: user.directions);
    final directions = _getDirections(user: user,indexDir: event.indexDirection,allViewDir: event.allViewDir);
    emit(state.copyWith(
        status: FinanceStatus.loaded,
        user: user,
        directions: directions,
        titlesDrawingMenu: titlesDrawingMenu,
        expiredSubscriptions: expiredSubscriptions));
  }

  List<SubscriptionEntity> _getExpiredSubscriptions(UserEntity user,bool allView,int indexDir){
     List<SubscriptionEntity> resList = [];

    if(allView){

      for(var e in user.directions){
        resList.addAll(e.subscriptionsAll);
      }

    }else{
      resList = user.directions[indexDir].subscriptionsAll;
    }


    return resList.where((element) => element.status == StatusSub.inactive).toList();
  }


  List<String> _getTitlesDrawingMenu({required List<DirectionLesson> directions}){
    List<String> resultList = [];
    directions.sort((a,b)=>b.lastSubscription.balanceSub.compareTo(a.lastSubscription.balanceSub));
    resultList = directions.map((e) => e.name).toList();
    int length = resultList.length;
    if(length>1){
      resultList.insert(length, 'Все направления'.tr());
    }
    return resultList;
  }

  List<DirectionLesson> _getDirections({required UserEntity user, required indexDir,required bool allViewDir}){
    if(allViewDir){
      return user.directions;
    }
    return [user.directions[indexDir]];
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
    final newBalance = currentDirection.lastSubscription.balanceLesson + priceSubscriptionEntity.quantityLesson;
    final newBalanceSub = currentDirection.lastSubscription.balanceSub + priceSubscriptionEntity.price;
    final supUpdate = currentDirection.lastSubscription.copyWith(
      balanceLesson: newBalance,
      balanceSub: newBalanceSub
    );
    final updateDirection = currentDirection.copyWith(lastSubscription: supUpdate);
    final indexDirection = directions.indexWhere((element) => element.name == currentDirection.name);
    final finalDirectionList = directions.update(indexDirection,updateDirection);
    final newUser = user.copyWith(directions: finalDirectionList);
    final timeNow = DateTime.now();
    final parseTime = '${DateFormat.yMd().format(timeNow)} ${DateFormat.Hm().format(timeNow)}';
    _userCubit.updateUser(newUser: newUser);
    _listTransaction.add(TransactionEntity(
        typeTransaction: TypeTransaction.addBalance,
        time: parseTime,
        quantity: priceSubscriptionEntity.price));


  }


  void _writingOffMoney(WritingOfMoneyEvent event,emit) async {
    final user = _userCubit.userEntity;
    final directions = user.directions;
    final newBalance = event.currentDirection.lastSubscription.balanceLesson - 1;
    final newBalanceSub = event.currentDirection.lastSubscription.balanceSub - event.currentDirection.lastSubscription.priceOneLesson;
    final supUpdate = event.currentDirection.lastSubscription.copyWith(
        balanceLesson: newBalance,
        balanceSub: newBalanceSub
    );
    final updateDirection = event.currentDirection.copyWith(lastSubscription: supUpdate);
    final indexDirection = directions.indexWhere((element) => element.name == event.currentDirection.name);
    final finalDirectionList = directions.update(indexDirection,updateDirection);
    final newUser = user.copyWith(directions: finalDirectionList);
    final timeNow = DateTime.now();
    final parseTime = '${DateFormat.yMd().format(timeNow)} ${DateFormat.Hm().format(timeNow)}';
    _userCubit.updateUser(newUser: newUser);
    _listTransaction.add(TransactionEntity(
        typeTransaction: TypeTransaction.minusLesson,
        time: parseTime,
        quantity: event.currentDirection.lastSubscription.priceOneLesson));
  }


  void _applyBonus(ApplyBonusEvent event,emit) async {
    try{
      emit(state.copyWith(applyBonusStatus: ApplyBonusStatus.loading));
      final user = _userCubit.userEntity;
      final directions = user.directions;
      final newBalance = event.currentDirection.lastSubscription.balanceLesson + 1;
      final newBalanceSub = event.currentDirection.lastSubscription.balanceSub - event.currentDirection.lastSubscription.priceOneLesson;
      final supUpdate = event.currentDirection.lastSubscription.copyWith(
          balanceLesson: newBalance,
          balanceSub: newBalanceSub
      );
      final updateDirection = event.currentDirection.copyWith(lastSubscription: supUpdate);
      final indexDirection = directions.indexWhere((element) => element.name == event.currentDirection.name);
      final finalDirectionList = directions.update(indexDirection,updateDirection);
      final newUser = user.copyWith(directions: finalDirectionList);
      _userCubit.updateUser(newUser: newUser);
      emit(state.copyWith(applyBonusStatus: ApplyBonusStatus.loaded));
    }on Failure catch(e){
      emit(state.copyWith(applyBonusStatus: ApplyBonusStatus.error,error: e.message));
    }
  }





 }

