import 'package:equatable/equatable.dart';

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

  const ClientsState({required this.status, required this.error});

  factory ClientsState.unknown() {
    return const ClientsState(status: ClientsStatus.unknown, error: '');
  }


  ClientsState copyWith({
    ClientsStatus? status,
    String? error
}){
    return ClientsState(status: status??this.status, error: error??this.error);
}

  @override
  List<Object?> get props => [];
}
