
  import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtuozy/di/locator.dart';
import 'package:virtuozy/domain/entities/notifi_setting_entity.dart';
import 'package:virtuozy/domain/entities/user_entity.dart';
import 'package:virtuozy/domain/repository/user_repository.dart';
import 'package:virtuozy/domain/user_cubit.dart';
import 'package:virtuozy/utils/failure.dart';

import 'notifi_event.dart';
import 'notifi_state.dart';

class NotifiBloc extends Bloc<NotifiEvent,NotifiState>{

  NotifiBloc():super(NotifiState.unknown()){
    on<SaveSettingNotifiEvent>(_saveSettings);
    on<GetNotifiSettingsEvent>(_getNotifi);
  }

  final _userRepo =  locator.get<UserRepository>();
  final _userCubit = locator.get<UserCubit>();


    void _saveSettings(SaveSettingNotifiEvent event,emit) async {
     try{
       emit(state.copyWith(status: NotifiStatus.saving));
       UserEntity user = _userCubit.userEntity;

       List<NotifiSettingsEntity> settingsNew = [];
       print('Conf ${event.settings.toString()}');
       for(int i = 0; i< user.notifiSttings.length;i++){
          settingsNew.add(
              NotifiSettingsEntity(
                  name: user.notifiSttings[i].name,
                  config: event.settings[i]));
       }
       await _userRepo.saveSettingNotifi(uid: user.id, settingEntity: settingsNew);
       user = user.copyWith(notifiSttings: settingsNew);
       _userCubit.setUser(user: user);
       emit(state.copyWith(status: NotifiStatus.saved));
     }on Failure catch(e){
       emit(state.copyWith(status: NotifiStatus.error,error: e.message));
     }
    }



    void _getNotifi(GetNotifiSettingsEvent event,emit)async{
      try{
        emit(state.copyWith(status: NotifiStatus.loading,error: ''));
        await Future.delayed(const Duration(milliseconds: 700));
        final user = _userCubit.userEntity;
        emit(state.copyWith(status: NotifiStatus.loaded,settings: user.notifiSttings));
      }on Failure catch(e){
        emit(state.copyWith(status: NotifiStatus.error,error: e.message));
      }
    }






  }