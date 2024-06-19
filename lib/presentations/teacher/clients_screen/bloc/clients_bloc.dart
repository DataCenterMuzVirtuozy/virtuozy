

  import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtuozy/presentations/teacher/clients_screen/bloc/clients_event.dart';
import 'package:virtuozy/presentations/teacher/clients_screen/bloc/clients_state.dart';

class ClientsBloc extends Bloc<ClientsEvent,ClientsState>{


  ClientsBloc():super(ClientsState.unknown()){

  }

}