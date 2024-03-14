
part of 'app_bloc.dart';


enum AuthStatusCheck{
 unknown,
 authenticated,
  moderation,
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
  final UserType userType;
  final String error;


  const AppState({
    required this.userType,
   required this.authStatusCheck,
   required this.statusNetwork,
   required this.error,
  });

  factory AppState.unknown() {
    return const AppState(
      userType: UserType.unknown,
        authStatusCheck: AuthStatusCheck.unknown,
        statusNetwork: StatusNetwork.unknown,
        error: '');
  }



  @override
  List<Object?> get props => [authStatusCheck,statusNetwork,error,userType];

  AppState copyWith({
    AuthStatusCheck? authStatusCheck,
    StatusNetwork? statusNetwork,
    String? error,
    UserType? userType
  }) {
    return AppState(
      userType: userType??this.userType,
      authStatusCheck: authStatusCheck ?? this.authStatusCheck,
      statusNetwork: statusNetwork ?? this.statusNetwork,
      error: error ?? this.error,
    );
  }
}