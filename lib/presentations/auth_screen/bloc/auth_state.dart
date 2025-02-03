



 import 'package:equatable/equatable.dart';

 enum AuthStatus{
   unknown,
   authenticated,
   unauthenticated,
   error,
   editingPass,
   editedPass,
   errorEditPass,
   errorLogIn,
   errorResetPass,
   searchLocation,
   searchLocationComplete,
   searchLocationError,
   onSearchLocation,
   processSingIn,
   processLogIn,
   processLogOut,
   awaitCode,
   sendRequestCode,
   sendRequestResPass,
   moderation,
   baseUrlEmpty,
   deleting,
   deleted,
   errorDeleting,
   resettingPass,
   logOut

 }


class AuthState extends Equatable{

   final AuthStatus authStatus;
   final String error;
   final String changedLocation;




   factory AuthState.unknown(){
     return const AuthState(authStatus: AuthStatus.unknown, error: '', changedLocation: '');
   }

  @override
  List<Object?> get props => [error,authStatus];

   const AuthState({
     required this.changedLocation,
    required this.authStatus,
    required this.error,
  });

   AuthState copyWith({
    AuthStatus? authStatus,
    String? error,
     String? changedLocation
  }) {
    return AuthState(
      changedLocation: changedLocation??this.changedLocation,
      authStatus: authStatus ?? this.authStatus,
      error: error ?? this.error,
    );
  }
}