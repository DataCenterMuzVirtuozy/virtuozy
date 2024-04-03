
  import 'package:equatable/equatable.dart';

import '../../../../domain/entities/notifi_setting_entity.dart';

enum NotifiStatus{
  loading,
  loaded,
  error,
  saving,
  saved,
  unknown
}


class NotifiState  extends Equatable{


  final NotifiStatus status;
  final String error;
  final List<NotifiSettingsEntity> settings;


  factory NotifiState.unknown(){
    return const NotifiState(status: NotifiStatus.unknown, error: '', settings: []);
  }

  @override
  List<Object?> get props => [status,error,settings];

  const NotifiState({
    required this.status,
    required this.error,
    required this.settings,
  });

  NotifiState copyWith({
    NotifiStatus? status,
    String? error,
    List<NotifiSettingsEntity>? settings,
  }) {
    return NotifiState(
      status: status ?? this.status,
      error: error ?? this.error,
      settings: settings ?? this.settings,
    );
  }
}