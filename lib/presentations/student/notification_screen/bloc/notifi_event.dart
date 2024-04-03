


 import 'package:equatable/equatable.dart';
import 'package:virtuozy/domain/entities/notifi_setting_entity.dart';

class NotifiEvent extends Equatable{

  @override
  List<Object?> get props => [];

  const NotifiEvent();
}


  class GetNotifiSettingsEvent extends NotifiEvent{

    const GetNotifiSettingsEvent();
  }

 class  SaveSettingNotifiEvent extends NotifiEvent {
  final List<int> settings;
  const SaveSettingNotifiEvent({required this.settings});
}