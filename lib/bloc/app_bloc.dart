
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:virtuozy/utils/preferences_util.dart';

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
  Map _source = {ConnectivityResult.none: false};


  void _initApp(InitAppEvent event,emit) async {
   emit(state.copyWith(authStatusCheck: AuthStatusCheck.unknown));
   final user = PreferencesUtil.phoneUser;
   final status = PreferencesUtil.statusUser;
   await Future.delayed(const Duration(seconds: 3));
   if(user.isEmpty){
    emit(state.copyWith(authStatusCheck: AuthStatusCheck.unauthenticated));
   }else{
    if(status == 1){
     emit(state.copyWith(authStatusCheck: AuthStatusCheck.authenticated));
    }else{
     emit(state.copyWith(authStatusCheck: AuthStatusCheck.moderation));
    }

   }

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


