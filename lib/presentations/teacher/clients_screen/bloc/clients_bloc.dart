

  import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtuozy/domain/entities/client_entity.dart';
import 'package:virtuozy/domain/teacher_cubit.dart';
import 'package:virtuozy/presentations/teacher/clients_screen/bloc/clients_event.dart';
import 'package:virtuozy/presentations/teacher/clients_screen/bloc/clients_state.dart';

import '../../../../di/locator.dart';
import '../../../../domain/repository/teacher_repository.dart';
import '../../../../utils/failure.dart';

class ClientsBloc extends Bloc<ClientsEvent,ClientsState>{


  ClientsBloc():super(ClientsState.unknown()){
     on<GetClientsEvent>(getClients,transformer: droppable());
  }

  final _teacherRepository = locator.get<TeacherRepository>();
  final _teacherCubit = locator.get<TeacherCubit>();

  void getClients(GetClientsEvent event,emit) async{
    try {
      await emit(state.copyWith(status: ClientsStatus.loading));
      final idT = _teacherCubit.teacherEntity.id;
      final dateNow = DateTime.now().toString().split(' ')[0];
      final clientsFromApi = await _teacherRepository.getClients(idTeacher: idT);
      final action = clientsFromApi.where((element) => element.status == ClientStatus.action).toList();
      final archive = clientsFromApi.where((element) => element.status == ClientStatus.archive).toList();
      final today = clientsFromApi.where((element) => element.dateNearLesson == dateNow&&element.status!=ClientStatus.trial||
      element.status!=ClientStatus.empty).toList();
      final replacement = clientsFromApi.where((element) => element.status == ClientStatus.replacement).toList();
      final clients = clientsFromApi.where((element) => element.status != ClientStatus.archive).toList();
      await emit(state.copyWith(status: ClientsStatus.loaded,all: clients,action: action,archive: archive,today: today,
      replacement: replacement));
      print('CLienst ${clients.length}');
    }on Failure catch (e) {
      await emit(state.copyWith(status: ClientsStatus.error,error: e.message));
    }
  }

}