



 import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtuozy/di/locator.dart';
import 'package:virtuozy/domain/entities/notifi_setting_entity.dart';
import 'package:virtuozy/domain/entities/user_entity.dart';
import 'package:virtuozy/domain/repository/teacher_repository.dart';
import 'package:virtuozy/domain/repository/user_repository.dart';
import 'package:virtuozy/domain/teacher_cubit.dart';
import 'package:virtuozy/domain/user_cubit.dart';
import 'package:virtuozy/presentations/auth_screen/bloc/auth_event.dart';
import 'package:virtuozy/presentations/auth_screen/bloc/auth_state.dart';
import 'package:virtuozy/utils/failure.dart';
import 'package:virtuozy/utils/preferences_util.dart';

import '../../../components/dialogs/dialoger.dart';
import '../../../data/models/log_model.dart';
import '../../../data/services/log_service.dart';

class AuthBloc extends Bloc<AuthEvent,AuthState>{
  AuthBloc():super(AuthState.unknown()){
    on<LogInEvent>(_logIn);
    on<GetCodeEvent>(_getCode);
    on<SearchLocationEvent>(_getIdBranch);
    on<SingInEvent>(_singIn);
    on<CompleteSinIgEvent>(_completeSingIn);
    on<LogOutEvent>(_logOut);
    on<LogOutTeacherEvent>(_logOutTeacher);
    on<DeleteAccountEvent>(_deleteAccount);
    on<ResetPassEvent>(_resetPass,transformer: droppable());
  }


    final _userCubit = locator.get<UserCubit>();
    final _userRepository = locator.get<UserRepository>();
    final _teacherRepository = locator.get<TeacherRepository>();
    final _teacherCubit = locator.get<TeacherCubit>();
    late UserEntity user;

     void _resetPass(ResetPassEvent event, emit) async {
       try{
         emit(state.copyWith(authStatus: AuthStatus.resettingPass,error: ''));
         final urkSchool = PreferencesUtil.urlSchool;
         if(urkSchool.isEmpty){
           emit(state.copyWith(authStatus: AuthStatus.onSearchLocation));
         }else if(event.phone.isEmpty){
           throw Failure('Введите номер телефона'.tr());
         }
         await Future.delayed(const Duration(seconds: 2));
         await _userRepository.resetPass(phone: event.phone);
         emit(state.copyWith(authStatus: AuthStatus.sendRequestResPass));
       }on Failure catch(e,s){
         LogService.sendLog(TypeLog.errorResetPass,s);
         emit(state.copyWith(authStatus: AuthStatus.errorResetPass,error: e.message));
       }
      }

    void _deleteAccount(DeleteAccountEvent event,emit) async {
      try {
        if(event.user.userStatus.isModeration || event.user.userStatus.isAuth){
          emit(state.copyWith(authStatus: AuthStatus.deleting,error: ''));
          await Future.delayed(const Duration(seconds: 1));
          await _userRepository.deleteAccount();
          await PreferencesUtil.clear();
          user = event.user.copyWith(userStatus: UserStatus.notAuth);
          _userCubit.updateUser(newUser: user);
          Dialoger.showToast('Аккаунт успешно удален'.tr());
        }
        emit(state.copyWith(authStatus: AuthStatus.logOut));
      } on Failure catch (e,s) {
        LogService.sendLog(TypeLog.errorDeleteAccount,s);
        emit(state.copyWith(authStatus: AuthStatus.errorDeleting,error: 'Ошибка удаления аккаунта'.tr()));
      } catch (e,s){
        LogService.sendLog(TypeLog.errorDeleteAccount,s);
        emit(state.copyWith(authStatus: AuthStatus.errorDeleting,error: 'Ошибка удаления аккаунта'.tr()));
      }
    }

  void _logIn(LogInEvent event,emit) async {

    try{
      emit(state.copyWith(authStatus: AuthStatus.processLogIn,error: ''));
      final baseUrlApi = PreferencesUtil.urlSchool;
      if(event.phone.isEmpty){
        throw Failure('Введите номер телефона'.tr());
      }else if(event.password.isEmpty){
        throw Failure('Введиде пароль'.tr());
      } else if(baseUrlApi.isEmpty){
        emit(state.copyWith(authStatus: AuthStatus.baseUrlEmpty, error: ''));
        return;
      }

      if(event.phone == "+3 (333) 333-33-33"){
        final teacher = await _teacherRepository.getTeacher(uid: event.phone);
        _teacherCubit.setTeacher(teacher: teacher);
        await PreferencesUtil.setTypeUser(userType: UserType.teacher);
        // await PreferencesUtil.setToken(uid: event.phone);
        emit(state.copyWith(authStatus: AuthStatus.authenticated));
         return;
      }

      UserEntity user = await _userRepository.logIn(phone: event.phone,password: event.password);
      if(user.userStatus.isDeleted){
        throw Failure('Данный аккаунт был удален пользователем'.tr());
      }
        await PreferencesUtil.setPhoneUser(phone: event.phone);
        user = user.copyWith(userStatus: UserStatus.auth);
        _userCubit.setUser(user: user);
        await _createLocalUser(user);
        await Future.delayed(const Duration(seconds: 1));
        await PreferencesUtil.setTypeUser(userType: UserType.student);
        LogService.sendLog(TypeLog.login);
        emit(state.copyWith(authStatus: AuthStatus.authenticated));

    }on Failure catch (e,s){
      await PreferencesUtil.clear();
      LogService.sendLog(TypeLog.errorLogin,s);
      emit(state.copyWith(authStatus: AuthStatus.errorLogIn,error: e.message));
    } catch (e,stakeTrace){
      await PreferencesUtil.clear();
      LogService.sendLog(TypeLog.errorLogin,stakeTrace);
      emit(state.copyWith(authStatus: AuthStatus.errorLogIn,
          error: 'Ошибка получения данных'.tr()));
    }

  }

  void _singIn(SingInEvent event,emit) async {

    try{
      emit(state.copyWith(authStatus: AuthStatus.processSingIn,error: ''));
      final urkSchool = PreferencesUtil.urlSchool;
      if(urkSchool.isEmpty){
        emit(state.copyWith(authStatus: AuthStatus.onSearchLocation));
      }else if(event.surName.isEmpty){
        throw Failure('Фамилия неуказана'.tr());
      }else if(event.name.isEmpty){
        throw Failure('Имя неуказано'.tr());
      }else if(event.phone.isEmpty){
        throw Failure('Введите номер телефона'.tr());
      }
      await Future.delayed(const Duration(seconds: 1));
      await _userRepository.signIn(phone: event.phone, name: event.name, surName: event.surName);
      await PreferencesUtil.setPhoneUser(phone: event.phone);
      final user = _createUserEntity(event);
      await _createLocalUser(user);
      LogService.sendLog(TypeLog.registration);
      emit(state.copyWith(authStatus: AuthStatus.sendRequestCode));
    }on Failure catch(e,s){
      LogService.sendLog(TypeLog.errorRegistration,s);
       emit(state.copyWith(authStatus: AuthStatus.error,error: e.message));
    }

  }




  UserEntity _createUserEntity( SingInEvent event) {
    final user =  UserEntity(
        notifiSttings: [
          const NotifiSettingsEntity(name:"Уведомление об оплате",
              config:1),
          const NotifiSettingsEntity(name:"Подтверждение уроков",
              config:1),
          const NotifiSettingsEntity(name:"Напоминание об уроке",
              config:1),
          const NotifiSettingsEntity(name:"Пропуск урока",
              config:1),
          const NotifiSettingsEntity(name:"Уведомление о бонусах",
              config:1),
          const NotifiSettingsEntity(name:"Новые предложения",
              config:1),
        ],
        documents: [],
        userStatus: UserStatus.moderation,
        lastName: event.surName,
        firstName: event.name,
        branchName: '',
        phoneNumber: event.phone,
        userType: UserType.student,
        directions: [],
        id: 0,
        sex: '',
        about_me: '',
        date_birth: '',
        registration_date: '',
        has_kids: false,
        subways:[],
        avaUrl: '',
        who_find: '');
    return user;
  }

  Future<void> _createLocalUser(UserEntity user) async {
     await PreferencesUtil.setFirstNameUser(firstName: user.firstName);
     await PreferencesUtil.setLastNameUser(lastName: user.lastName);
     await PreferencesUtil.setPhoneUser(phone: user.phoneNumber);
     await PreferencesUtil.setStatusUser(status:
     user.userStatus == UserStatus.moderation?2:
         user.userStatus == UserStatus.auth?1:0
     );

    _userCubit.setUser(user:user);
  }

  Future<void> _completeSingIn(CompleteSinIgEvent event,emit) async{
    try{
      await PreferencesUtil.setBranchUser(branch: event.branch);
      user = user.copyWith(branchName: event.branch);
      _userCubit.updateUser(newUser: user);
    } on Failure catch(e){
       Failure(e.message);
    }
  }


  void _getIdBranch(SearchLocationEvent event,emit) async {
    emit(state.copyWith(authStatus: AuthStatus.searchLocation));
    await Future.delayed(const Duration(milliseconds: 700));
    emit(state.copyWith(authStatus: AuthStatus.searchLocationComplete,changedLocation:event.loc));
  }


  void _getCode(GetCodeEvent event, emit) async {
    emit(state.copyWith(authStatus: AuthStatus.sendRequestCode));
    await Future.delayed(const Duration(seconds: 3));
    emit(state.copyWith(authStatus: AuthStatus.awaitCode));
  }

  void _logOut(LogOutEvent event,emit) async {
    if(event.user.userStatus.isModeration || event.user.userStatus.isAuth){
      user = event.user.copyWith(userStatus: UserStatus.notAuth);
      _userCubit.updateUser(newUser: user);
      await PreferencesUtil.clear();
    }
    LogService.sendLog(TypeLog.logout);
   emit(state.copyWith(authStatus: AuthStatus.logOut));
  }

  void _logOutTeacher(LogOutTeacherEvent event,emit) async{
    await PreferencesUtil.clear();
    final teacher = _teacherCubit.teacherEntity.copyWith(userStatus: UserStatus.notAuth);
    _teacherCubit.updateTeacher(newTeacher: teacher);
    emit(state.copyWith(authStatus: AuthStatus.logOut));
  }

}