
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:virtuozy/domain/entities/user_entity.dart';
import 'package:virtuozy/domain/user_cubit.dart';
import 'package:virtuozy/utils/preferences_util.dart';

import '../di/locator.dart';
import '../utils/network_check.dart';
part 'app_event.dart';
part 'app_state.dart';

 class AppBloc extends Bloc<AppEvent,AppState>{
  AppBloc():super(AppState.unknown()){
    on<InitAppEvent>(_initApp);
    on<ObserveNetworkEvent>(_observeNetwork);
    on<CheckNetworkEvent>(_checkNetwork);
  }

  final NetworkConnectivity _networkConnectivity = NetworkConnectivity.instance;
  final userCubit = locator.get<UserCubit>();
  Map _source = {ConnectivityResult.none: false};


  void _initApp(InitAppEvent event,emit) async {
   emit(state.copyWith(authStatusCheck: AuthStatusCheck.unknown));
    final user = _getUser();
    userCubit.setUser(user: user);
   await Future.delayed(const Duration(seconds: 3));

   if(user.userStatus == UserStatus.notAuth){
    print('A1');
    emit(state.copyWith(authStatusCheck: AuthStatusCheck.unauthenticated));
   }else{
    if(user.userStatus == UserStatus.auth){
     print('A2');
     emit(state.copyWith(authStatusCheck: AuthStatusCheck.authenticated));
    }else if(user.userStatus == UserStatus.moderation){
     print('A3');
     emit(state.copyWith(authStatusCheck: AuthStatusCheck.moderation));
    }

   }

  }


  UserEntity _getUser(){
   final phone = PreferencesUtil.phoneUser;
   final status = PreferencesUtil.statusUser;
   final lastName = PreferencesUtil.lastNameUser;
   final firstName = PreferencesUtil.firstNameUser;
   final branch = PreferencesUtil.branchUser;

   return UserEntity(userStatus: status == 1?UserStatus.auth:
       status == 2?UserStatus.moderation:UserStatus.notAuth,
       lastName: lastName, firstName: firstName, branchName: branch,
       phoneNumber: phone);
  }


  void _checkNetwork(CheckNetworkEvent event,emit)async{
   if(event.statusNetwork.isDisconnect){
    emit(state.copyWith(statusNetwork: StatusNetwork.disconnect));
   }else{
    emit(state.copyWith(statusNetwork: StatusNetwork.connect));
   }

  }

  void _observeNetwork( event,emit)async{

   _networkConnectivity.initialise();
   _networkConnectivity.myStream.listen((source) {
    _source = source;
    switch (_source.keys.toList()[0]) {
     case ConnectivityResult.mobile:
      add(const CheckNetworkEvent(statusNetwork: StatusNetwork.connect));
      break;
     case ConnectivityResult.wifi:
      add(const CheckNetworkEvent(statusNetwork: StatusNetwork.connect));
      break;
     case ConnectivityResult.none:
      add(const CheckNetworkEvent(statusNetwork: StatusNetwork.disconnect));
      break;

    }});


  }

 }


