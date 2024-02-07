



 import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtuozy/presentations/auth_screen/bloc/auth_event.dart';
import 'package:virtuozy/presentations/auth_screen/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent,AuthState>{
  AuthBloc():super(AuthState.unknown()){
    on<LogInEvent>(_logIn);
    on<GetCodeEvent>(_getCode);
    on<SearchLocationEvent>(_getIdBranch);
    on<SingInEvent>(_singIn);
  }





  void _logIn(LogInEvent event,emit) async {
    emit(state.copyWith(authStatus: AuthStatus.processLogIn));
    await Future.delayed(const Duration(seconds: 3));
    emit(state.copyWith(authStatus: AuthStatus.authenticated));
  }

  void _singIn(SingInEvent event,emit) async {
    emit(state.copyWith(authStatus: AuthStatus.processSingIn));
    await Future.delayed(const Duration(seconds: 3));
    emit(state.copyWith(authStatus: AuthStatus.authenticated));
  }


  void _getIdBranch(SearchLocationEvent event,emit) async {
    emit(state.copyWith(authStatus: AuthStatus.searchLocation));
    await Future.delayed(const Duration(seconds: 3));
    emit(state.copyWith(authStatus: AuthStatus.searchLocationComplete));
  }


  void _getCode(GetCodeEvent event, emit) async {
    emit(state.copyWith(authStatus: AuthStatus.sendRequestCode));
    await Future.delayed(const Duration(seconds: 3));
    emit(state.copyWith(authStatus: AuthStatus.awaitCode));
  }

}