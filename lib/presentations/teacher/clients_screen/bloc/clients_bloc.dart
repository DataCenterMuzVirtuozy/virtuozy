

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
     on<GetClientsEvent>(getClients);
  }

  final _teacherRepository = locator.get<TeacherRepository>();
  final _teacherCubit = locator.get<TeacherCubit>();

  void getClients(GetClientsEvent event,emit) async{
    try {
      await emit(state.copyWith(status: ClientsStatus.loading));
      final idT = _teacherCubit.teacherEntity.id;
      final dateNow = DateTime.now().toString().split(' ')[0];
      final clients = await _teacherRepository.getClients(idTeacher: idT);
      final action = clients.where((element) => element.status == ClientStatus.action).toList();
      final archive = clients.where((element) => element.status == ClientStatus.archive).toList();
      final today = clients.where((element) => element.dateNearLesson == dateNow).toList();
      await emit(state.copyWith(status: ClientsStatus.loaded,all: clients,action: action,archive: archive,today: today));
    }on Failure catch (e) {
      await emit(state.copyWith(status: ClientsStatus.error,error: e.message));
    }
  }

}