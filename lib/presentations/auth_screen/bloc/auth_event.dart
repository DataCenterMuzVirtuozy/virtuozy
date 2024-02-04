


 import 'package:equatable/equatable.dart';

class AuthEvent extends Equatable{


  @override
  List<Object?> get props => [];

  const AuthEvent();
}


 class LogInEvent extends AuthEvent{
    final String code;
    const LogInEvent({
    required this.code,
  });
}

 class GetCodeEvent extends AuthEvent{
   final String phoneNumber;
   const GetCodeEvent({
     required this.phoneNumber,
   });
 }