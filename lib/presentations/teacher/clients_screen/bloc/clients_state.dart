import 'package:equatable/equatable.dart';

import '../../../../domain/entities/client_entity.dart';

enum ClientsStatus { loading, loaded, error, unknown }

extension ClientStatusExt on ClientsStatus {
  bool get isLoading => this == ClientsStatus.loading;
  bool get isLoaded => this == ClientsStatus.loaded;
  bool get isError => this == ClientsStatus.error;
  bool get isUnknown => this == ClientsStatus.unknown;
}

class ClientsState extends Equatable {
  final ClientsStatus status;
  final String error;
  final List<ClientEntity> all;
  final List<ClientEntity> action;
  final List<ClientEntity> archive;
  final List<ClientEntity> today;
  final List<ClientEntity> replacement;


  const ClientsState({required this.status, required this.error,
  required this.replacement,
  required this.all,
  required this.archive,
  required this.action,
  required this.today});

  factory ClientsState.unknown() {
    return const ClientsState(status: ClientsStatus.unknown, error: '', replacement: [], all: [], archive: [], action: [], today: [

    ]);
  }


  ClientsState copyWith({
    ClientsStatus? status,
    String? error,
    List<ClientEntity>? all,
    List<ClientEntity>? action,
    List<ClientEntity>? archive,
    List<ClientEntity>? today,
    List<ClientEntity>? replacement,
}){
    return ClientsState(
        status: status ?? this.status,
        error: error ?? this.error,
        replacement: replacement??this.replacement,
        all: all??this.all,
        archive: archive??this.archive,
        action: action??this.action,
        today: today??this.today);
  }

  @override
  List<Object?> get props => [status,error,all,action,archive,today,replacement];
}
