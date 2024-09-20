


 import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtuozy/di/locator.dart';
import 'package:virtuozy/domain/entities/price_subscription_entity.dart';
import 'package:virtuozy/domain/entities/subscription_entity.dart';
import 'package:virtuozy/domain/entities/user_entity.dart';
import 'package:virtuozy/domain/repository/finance_repository.dart';
import 'package:virtuozy/presentations/student/finance_screen/bloc/state_finance.dart';
import 'package:virtuozy/utils/date_time_parser.dart';
import 'package:virtuozy/utils/failure.dart';
import 'package:virtuozy/utils/update_list_ext.dart';

import '../../../../domain/entities/transaction_entity.dart';
import '../../../../domain/repository/user_repository.dart';
import '../../../../domain/user_cubit.dart';
import '../../../../utils/preferences_util.dart';
import 'event_finance.dart';


class BlocFinance extends Bloc<EventFinance,StateFinance>{
  BlocFinance():super(StateFinance.unknown()){
    on<GetListSubscriptionsEvent>(_getPriceSubscription);
    on<GetBalanceSubscriptionEvent>(_getBalanceSubscription);
    on<PaySubscriptionEvent>(_paySubscription);
    on<GetListTransactionsEvent>(_getListTransaction);
    on<WritingOfMoneyEvent>(_writingOffMoney);
    on<ApplyBonusEvent>(_applyBonus);
    on<RefreshSubscriptionEvent>(_refreshSubscription,transformer: droppable());

  }

  final _financeRepository = locator.get<FinanceRepository>();
  final _userCubit = locator.get<UserCubit>();
  final _userRepository = locator.get<UserRepository>();
  List<TransactionEntity> _listTransaction = [];


  void _getListTransaction(GetListTransactionsEvent event,emit) async {
     try{
       emit(state.copyWith(listTransactionStatus: ListTransactionStatus.loading));
        final idUser = _userCubit.userEntity.id;
        final idDir = event.directions.length>1?-1:event.directions[0].id;
       final listApi = await _financeRepository.getTransactions(idUser: idUser, idDirections: idDir);
       _listTransaction = _listSortTransHistory(list: listApi);
       emit(state.copyWith(listTransactionStatus: ListTransactionStatus.loaded,transactions: _listTransaction));
     }on Failure catch(e){
       emit(state.copyWith(listTransactionStatus: ListTransactionStatus.error,error: e.message));
     }
  }

  List<TransactionEntity> _listSortTransHistory({required List<TransactionEntity> list}){
    list.sort((a,b)=>DateTimeParser.getTimeMillisecondEpoch(time: a.time, date: a.date)
        .compareTo(DateTimeParser.getTimeMillisecondEpoch(time: b.time, date: b.date)));
    list = list.reversed.toList();
     return list;
  }


  List<SubscriptionEntity> _listSortSubHistory({required List<SubscriptionEntity> list}){
    list.sort((a,b)=>DateTimeParser.getTimeMillisecondEpochByDate(date: a.dateBay)
        .compareTo(DateTimeParser.getTimeMillisecondEpochByDate( date: b.dateBay)));
    list = list.reversed.toList();
    return list;
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


  void _refreshSubscription(RefreshSubscriptionEvent event,emit) async {
    emit(state.copyWith(status: FinanceStatus.loading));
    final uid = PreferencesUtil.uid;
    final user = await _userRepository.getUser(uid: uid);
    _userCubit.setUser(user: user);

    if(user.userStatus == UserStatus.moderation || user.userStatus == UserStatus.notAuth){
      emit(state.copyWith(
          status: FinanceStatus.loaded));
      return;
    }

    final titlesDrawingMenu = _getTitlesDrawingMenu(directions: user.directions);
    final directions = _getDirections(user: user,indexDir: event.indexDirection,allViewDir: event.allViewDir);
    final expiredSubscriptions = _getExpiredSubscriptions(directions,event.allViewDir,event.indexDirection);
    List<SubscriptionEntity> listSubHistory = _getHistorySubscriptions(directions,event.allViewDir,event.indexDirection);
    listSubHistory = _listSortSubHistory(list: listSubHistory);
    emit(state.copyWith(
        status: FinanceStatus.loaded,
        user: user,
        subscriptionHistory: listSubHistory,
        directions: directions,
        titlesDrawingMenu: titlesDrawingMenu,
        expiredSubscriptions: expiredSubscriptions));

  }



  void _getBalanceSubscription(GetBalanceSubscriptionEvent event,emit) async {
    final user  = _userCubit.userEntity;
    if(user.userStatus.isNotAuth){
      emit(state.copyWith(status: FinanceStatus.loaded,user: user));
      return;
    }
    if(event.refreshDirection){
      emit(state.copyWith(status: FinanceStatus.loading));
      await Future.delayed(const Duration(seconds: 1));
    }

    if(user.userStatus == UserStatus.moderation || user.userStatus == UserStatus.notAuth){
      emit(state.copyWith(
          status: FinanceStatus.loaded));
      return;
    }

    final titlesDrawingMenu = _getTitlesDrawingMenu(directions: user.directions);
    final directions = _getDirections(user: user,indexDir: event.indexDirection,allViewDir: event.allViewDir);
    final expiredSubscriptions = _getExpiredSubscriptions(directions,event.allViewDir,event.indexDirection);
    List<SubscriptionEntity> listSubHistory = _getHistorySubscriptions(directions,event.allViewDir,event.indexDirection);
    listSubHistory = _listSortSubHistory(list: listSubHistory);
    emit(state.copyWith(
        status: FinanceStatus.loaded,
        user: user,
        subscriptionHistory: listSubHistory,
        directions: directions,
        titlesDrawingMenu: titlesDrawingMenu,
        expiredSubscriptions: expiredSubscriptions));

  }






  List<SubscriptionEntity> _getHistorySubscriptions(List<DirectionLesson> directions,bool allView,int indexDir){
    List<SubscriptionEntity> resList = [];
    List<SubscriptionEntity> resListHis = [];
    if(allView){

      for(var e in directions){
        resList.addAll(e.subscriptionsAll);
      }

    }else{
      resList = directions[0].subscriptionsAll;
    }

    // for(var s in resList){
    //   if(s.status == StatusSub.inactive){
    //     resListHis.add(s);
    //   }
    // }
    return resList;
  }


  List<SubscriptionEntity> _getExpiredSubscriptions(List<DirectionLesson> directions,bool allView,int indexDir){
     List<SubscriptionEntity> resList = [];

    if(allView){

      for(var e in directions){
        resList.addAll(e.lastSubscriptions);
      }

    }else{
      resList = directions[0].lastSubscriptions;
    }


    return resList;
  }


  List<String> _getTitlesDrawingMenu({required List<DirectionLesson> directions}){
    List<String> resultList = [];
    //directions.sort((a,b)=>b.lastSubscriptions[0].balanceSub.compareTo(a.lastSubscriptions[0].balanceSub));
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
      final user = _userCubit.userEntity;
      final indexCurrentDir = _getIndexDir(user.directions, event.currentDirection);
      final statusNewSub = _getStatusSubNew(user.directions[indexCurrentDir].subscriptionsAll);
      final dateNow = DateTime.now();
      var newSub = SubscriptionEntity(
        contactValues: ['','',''],
                id: 0,
                option: Option.unknown(),
                idUser: user.id,
                idDir: event.currentDirection.id,
                nameDir: event.currentDirection.name,
                name: event.priceSubscriptionEntity.name,
                price: event.priceSubscriptionEntity.price,
                priceOneLesson: event.priceSubscriptionEntity.priceOneLesson,
                balanceSub: event.priceSubscriptionEntity.price,
                balanceLesson: event.priceSubscriptionEntity.quantityLesson,
                dateStart: statusNewSub == StatusSub.active?DateTimeParser.getDateToApi(dateNow: dateNow):'',
                dateBay: DateTimeParser.getDateToApi(dateNow: dateNow),
                dateEnd: '',
                commentary: '',
                status: statusNewSub,
          nameTeacher: '');
      final idSub = await _financeRepository.baySubscription(subscriptionEntity: newSub);
       newSub = newSub.copyWith(id: idSub);
      _updateDirectionUser(subscriptionEntity: newSub,currentDirection: event.currentDirection);
      emit(state.copyWith(paymentStatus: PaymentStatus.paymentComplete));
    }on Failure catch(e){
      emit(state.copyWith(paymentStatus: PaymentStatus.paymentError,error: e.message));
    }catch (e){
      emit(state.copyWith(paymentStatus: PaymentStatus.paymentError,error: e.toString()));
    }
  }


  int _getIndexDir(List<DirectionLesson> directions,DirectionLesson currentDirection){
    final dirNewCur = directions.firstWhere((element) => element.id == currentDirection.id);
    return directions.indexOf(dirNewCur);
  }



  StatusSub _getStatusSubNew(List<SubscriptionEntity> subscriptionsAll) {
  bool hasActiveSub = false;
    for(var e in subscriptionsAll){
       if(e.status == StatusSub.active){
        hasActiveSub = true;
       }
    }
    if(hasActiveSub){
      return StatusSub.planned;
    }else{
      return StatusSub.active;
    }

  }


  void _updateDirectionUser({required SubscriptionEntity subscriptionEntity,required DirectionLesson currentDirection}) async {
    final user = _userCubit.userEntity;
    final directions = user.directions;
    final lastSubsNew = currentDirection.lastSubscriptions;
    final allSubsNew = currentDirection.subscriptionsAll;
    allSubsNew.add(subscriptionEntity);
    if(currentDirection.lastSubscriptions[0].status == StatusSub.inactive){
      lastSubsNew.update(0,subscriptionEntity);
    }else{
      lastSubsNew.add(subscriptionEntity);
    }

    final updateDirection = currentDirection.copyWith(lastSubscriptions: lastSubsNew,subscriptionsAll: allSubsNew);
    final indexDirection = directions.indexWhere((element) => element.name == currentDirection.name);
    final finalDirectionList = directions.update(indexDirection,updateDirection);
    final newUser = user.copyWith(directions: finalDirectionList);
    final timeNow = DateTime.now();
    final time = DateTimeParser.getTime(dateNow: timeNow);
    final date = DateTimeParser.getDateToApi(dateNow: timeNow);
    _userCubit.updateUser(newUser: newUser);
    final transactionEntity = TransactionEntity(
        idDir: currentDirection.id,
        idUser: user.id,
        typeTransaction: TypeTransaction.addBalance,
        time: time,
        quantity: subscriptionEntity.price,
        date: date);
    await _financeRepository.addTransaction(transactionEntity: transactionEntity);
    _listTransaction.add(transactionEntity);


  }


  void _writingOffMoney(WritingOfMoneyEvent event,emit) async {
    final user = _userCubit.userEntity;
    final directions = user.directions;
    final newBalance = event.currentDirection.lastSubscriptions[0].balanceLesson - 1;
    final newBalanceSub = event.currentDirection.lastSubscriptions[0].balanceSub - event.currentDirection.lastSubscriptions[0].priceOneLesson;
    final supUpdate = event.currentDirection.lastSubscriptions[0].copyWith(
        balanceLesson: newBalance,
        balanceSub: event.lessonConfirm.bonus?
        event.currentDirection.lastSubscriptions[0].balanceSub:
        newBalanceSub
    );

    final lastSubsNew = event.currentDirection.lastSubscriptions.update(0, supUpdate);
    final updateDirection = event.currentDirection.copyWith(lastSubscriptions: lastSubsNew);
    final indexDirection = directions.indexWhere((element) => element.name == event.currentDirection.name);
    final finalDirectionList = directions.update(indexDirection,updateDirection);
    final newUser = user.copyWith(directions: finalDirectionList);
    _userCubit.updateUser(newUser: newUser);
    if(!event.lessonConfirm.bonus){
      final timeNow = DateTime.now();
      final time = DateTimeParser.getTime(dateNow: timeNow);
      final date = DateTimeParser.getDateToApi(dateNow: timeNow);
      final transactionEntity = TransactionEntity(
          idUser: user.id,
          idDir: event.currentDirection.id,
          typeTransaction: TypeTransaction.minusLesson,
          time: time,
          date: date,
          quantity: event.currentDirection.lastSubscriptions[0].priceOneLesson);
      await _financeRepository.addTransaction(transactionEntity: transactionEntity);
      _listTransaction.add(transactionEntity);
    }

  }


  void _applyBonus(ApplyBonusEvent event,emit) async {
    try{
      emit(state.copyWith(applyBonusStatus: ApplyBonusStatus.loading));
      final user = _userCubit.userEntity;
      final directions = user.directions;
      final newBalance = event.currentDirection.lastSubscriptions[0].balanceLesson + 1;
      final newBalanceSub = event.currentDirection.lastSubscriptions[0].balanceSub - event.currentDirection.lastSubscriptions[0].priceOneLesson;
      final supUpdate = event.currentDirection.lastSubscriptions[0].copyWith(
          balanceLesson: newBalance,
          balanceSub: newBalanceSub
      );

      final lastSubsNew = event.currentDirection.lastSubscriptions.update(0, supUpdate);
      final updateDirection = event.currentDirection.copyWith(lastSubscriptions: lastSubsNew);
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

