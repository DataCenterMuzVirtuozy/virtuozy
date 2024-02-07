


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

class SearchLocationEvent extends AuthEvent{}


 class SingInEvent extends AuthEvent{
   final String name;
   final String phone;
   final String idBranch;
   const SingInEvent({
     required this.phone,
     required this.idBranch,
     required this.name,
   });
 }

 class GetCodeEvent extends AuthEvent{
   final String phoneNumber;
   const GetCodeEvent({
     required this.phoneNumber,
   });
 }