


 import 'package:equatable/equatable.dart';

class AuthEvent extends Equatable{


  @override
  List<Object?> get props => [];

  const AuthEvent();
}


 class LogInEvent extends AuthEvent{
    final String code;
    final String phone;
    const LogInEvent( {required this.phone,
    required this.code,
  });
}

class SearchLocationEvent extends AuthEvent{
  const SearchLocationEvent();
}


class CompleteSinIgEvent extends AuthEvent{
  final String branch;

  const CompleteSinIgEvent({required this.branch});
}


 class SingInEvent extends AuthEvent{
   final String lastName;
   final String firstName;
   final String phone;

   const SingInEvent({
     required this.lastName,
     required this.firstName,
     required this.phone,
   });
 }

 class GetCodeEvent extends AuthEvent{
   final String idBranch;
   const GetCodeEvent({
     required this.idBranch,
   });
 }

 class LogOutEvent extends AuthEvent{}