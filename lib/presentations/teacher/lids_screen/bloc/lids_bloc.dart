

  import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtuozy/domain/repository/teacher_repository.dart';
import 'package:virtuozy/presentations/teacher/lids_screen/bloc/lids_state.dart';
import 'package:virtuozy/utils/failure.dart';

import '../../../../di/locator.dart';
import 'lids_event.dart';

class LidsBloc extends Bloc<LidsEvent,LidsState>{

  LidsBloc():super(LidsState.unknown()){
     on<GetListEvent>(getLids);
  }


  final _teacherRepository = locator.get<TeacherRepository>();


   void getLids(GetListEvent event,emit) async{
      try {
        await emit(state.copyWith(status: LidsStatus.loading));
        final lids = await _teacherRepository.getLids(idTeacher: event.idTeacher);
        final lidsMy = lids.where((e) => e.dateTrial.isEmpty).toList();
        final lidsTrial = lids.where((element) => element.dateTrial.isNotEmpty).toList();
        await emit(state.copyWith(status: LidsStatus.loaded,lids: lids,lidsMy: lidsMy,lidsTrial: lidsTrial));
      }on Failure catch (e) {
       await emit(state.copyWith(status: LidsStatus.error,error: e.message));
      }


   }

}