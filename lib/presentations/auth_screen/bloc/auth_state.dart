



 import 'package:equatable/equatable.dart';

 enum AuthStatus{
   unknown,
   authenticated,
   unauthenticated,
   error,
   searchLocation,
   searchLocationComplete,
   searchLocationError,
   onSearchLocation,
   processSingIn,
   processLogIn,
   processLogOut,
   awaitCode,
   sendRequestCode,
   moderation,
   baseUrlEmpty,
   logOut

 }


class AuthState extends Equatable{

   final AuthStatus authStatus;
   final String error;




   factory AuthState.unknown(){
     return const AuthState(authStatus: AuthStatus.unknown, error: '');
   }

  @override
  List<Object?> get props => [error,authStatus];

   const AuthState({
    required this.authStatus,
    required this.error,
  });

   AuthState copyWith({
    AuthStatus? authStatus,
    String? error,
  }) {
    return AuthState(
      authStatus: authStatus ?? this.authStatus,
      error: error ?? this.error,
    );
  }
}