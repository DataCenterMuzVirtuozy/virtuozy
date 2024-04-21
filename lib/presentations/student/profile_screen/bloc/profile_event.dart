


 import 'package:equatable/equatable.dart';
import 'package:virtuozy/domain/entities/edit_profile_entity.dart';
import 'package:virtuozy/domain/entities/subway_entity.dart';
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
  final EditProfileEntity editProfileEntity;
  const SaveNewDataUserEvent({required this.editProfileEntity});
}

class GetSubwaysEvent extends ProfileEvent{
  final String query;

  const GetSubwaysEvent({
    required this.query,
  });
}

class AddSubwayEvent extends ProfileEvent{
  final SubwayEntity subway;

  const AddSubwayEvent({
    required this.subway,
  });
}