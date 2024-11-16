


 import 'package:equatable/equatable.dart';
import 'package:virtuozy/domain/entities/teacher_entity.dart';
import 'package:virtuozy/domain/entities/user_entity.dart';

class AuthEvent extends Equatable{


  @override
  List<Object?> get props => [];

  const AuthEvent();
}


 class LogInEvent extends AuthEvent{

    final String phone;
    final String password;
    const LogInEvent( {required this.phone,
      required this.password,
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
   final String name;
   final String surName;
   final String phone;


   const SingInEvent({
     required this.name,
     required this.surName,
     required this.phone,
   });
 }

 class GetCodeEvent extends AuthEvent{
   final String idBranch;
   const GetCodeEvent({
     required this.idBranch,
   });
 }

 class LogOutEvent extends AuthEvent{
  final UserEntity user;

  const LogOutEvent({required this.user});

 }

 class LogOutTeacherEvent extends AuthEvent{
   final TeacherEntity teacher;

   const LogOutTeacherEvent({required this.teacher});

 }