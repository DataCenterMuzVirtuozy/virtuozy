
part of 'app_bloc.dart';


enum AuthStatusCheck{
 unknown,
 authenticated,
 unauthenticated,
 error,
}

enum StatusNetwork{
 unknown,
 disconnect,
 connect

}

extension StatusNetworkExt on StatusNetwork{
  bool get isDisconnect=>this==StatusNetwork.disconnect;
  bool get isConnect=>this==StatusNetwork.connect;
}

 class AppState extends Equatable{

  final AuthStatusCheck authStatusCheck;
  final StatusNetwork statusNetwork;
  final String error;


  const AppState({
   required this.authStatusCheck,
   required this.statusNetwork,
   required this.error,
  });

  factory AppState.unknown() {
    return const AppState(
        authStatusCheck: AuthStatusCheck.unknown,
        statusNetwork: StatusNetwork.unknown,
        error: '');
  }



  @override
  List<Object?> get props => [authStatusCheck,statusNetwork,error];

  AppState copyWith({
    AuthStatusCheck? authStatusCheck,
    StatusNetwork? statusNetwork,
    String? error,
  }) {
    return AppState(
      authStatusCheck: authStatusCheck ?? this.authStatusCheck,
      statusNetwork: statusNetwork ?? this.statusNetwork,
      error: error ?? this.error,
    );
  }
}