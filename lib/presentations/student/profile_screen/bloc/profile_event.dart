


 import 'package:equatable/equatable.dart';
import 'package:virtuozy/domain/entities/user_entity.dart';

class ProfileEvent extends Equatable{

  @override
  List<Object?> get props => [];

  const ProfileEvent();
}


 class GetDataUserEvent extends ProfileEvent{

   const GetDataUserEvent();
}

class SaveNewDataUserEvent extends ProfileEvent{
  final UserEntity newUserData;
  const SaveNewDataUserEvent({required this.newUserData});
}