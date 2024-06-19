

  import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtuozy/presentations/teacher/lids_screen/bloc/lids_state.dart';

import 'lids_event.dart';

class LidsBloc extends Bloc<LidsEvent,LidsState>{

  LidsBloc():super(LidsState.unknown()){

  }



}