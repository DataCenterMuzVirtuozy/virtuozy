



 import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtuozy/di/locator.dart';
import 'package:virtuozy/domain/entities/user_entity.dart';
import 'package:virtuozy/domain/user_cubit.dart';
import 'package:virtuozy/presentations/auth_screen/bloc/auth_event.dart';
import 'package:virtuozy/presentations/auth_screen/bloc/auth_state.dart';
import 'package:virtuozy/utils/failure.dart';
import 'package:virtuozy/utils/preferences_util.dart';

class AuthBloc extends Bloc<AuthEvent,AuthState>{
  AuthBloc():super(AuthState.unknown()){
    on<LogInEvent>(_logIn);
    on<GetCodeEvent>(_getCode);
    on<SearchLocationEvent>(_getIdBranch);
    on<SingInEvent>(_singIn);
    on<CompleteSinIgEvent>(_completeSingIn);
    on<LogOutEvent>(_logOut);
  }


    final userCubit = locator.get<UserCubit>();
    late UserEntity user;



  void _logIn(LogInEvent event,emit) async {

    try{
      emit(state.copyWith(authStatus: AuthStatus.processLogIn,error: ''));
      if(event.phone.isEmpty){
        throw Failure('Введите номер телефона'.tr());
      }else if(event.code.isEmpty){
        throw Failure('Введиде пароль'.tr());
      }

       final phone = PreferencesUtil.phoneUser;

      if(event.phone == '+1 (111) 111-11-11'){
        userCubit.setUser(user: const UserEntity(
          userStatus: UserStatus.auth,
            lastName: 'Петров',
            firstName: 'Иван',
            branchName: 'Москва',
            phoneNumber: '+1 (111) 111-11-11'));
        await Future.delayed(const Duration(seconds: 2));
        emit(state.copyWith(authStatus: AuthStatus.authenticated));
        return;
      }

      if(phone == event.phone){
        await Future.delayed(const Duration(seconds: 2));
        userCubit.setUser(user:  UserEntity(
            userStatus: UserStatus.moderation,
            lastName: PreferencesUtil.lastNameUser,
            firstName: PreferencesUtil.firstNameUser,
            branchName: PreferencesUtil.branchUser,
            phoneNumber: PreferencesUtil.phoneUser));
        emit(state.copyWith(authStatus: AuthStatus.moderation));
        return;
      }

      await Future.delayed(const Duration(seconds: 2));
      emit(state.copyWith(authStatus: AuthStatus.error,error: 'Аккаунт не найден'.tr()));
    }on Failure catch (e){
      emit(state.copyWith(authStatus: AuthStatus.error,error: e.message));
    }

  }

  void _singIn(SingInEvent event,emit) async {

    try{
      emit(state.copyWith(authStatus: AuthStatus.processSingIn,error: ''));
      if(event.lastName.isEmpty){
        throw Failure('Фамилия неуказана'.tr());
      }else if(event.firstName.isEmpty){
        throw Failure('Имя неуказано'.tr());
      }else if(event.phone.isEmpty){
        throw Failure('Введите номер телефона'.tr());
      }
      await _createLocalUser(event);
      emit(state.copyWith(authStatus: AuthStatus.onSearchLocation));
    }on Failure catch(e){
       emit(state.copyWith(authStatus: AuthStatus.error,error: e.message));
    }

  }

  Future<void> _createLocalUser(SingInEvent event) async {
     await PreferencesUtil.setFirstNameUser(firstName: event.firstName);
     await PreferencesUtil.setLastNameUser(lastName: event.lastName);
     await PreferencesUtil.setPhoneUser(phone: event.phone);
     await PreferencesUtil.setStatusUser(status: 2);
     user = UserEntity(
        userStatus: UserStatus.moderation,
        lastName: event.lastName,
        firstName: event.firstName,
        branchName: '',
        phoneNumber: event.phone);
    userCubit.setUser(user:user);
  }

  Future<void> _completeSingIn(CompleteSinIgEvent event,emit) async{
    try{
      await PreferencesUtil.setBranchUser(branch: event.branch);
      user = user.copyWith(branchName: event.branch);
      userCubit.updateUser(newUser: user);
    } on Failure catch(e){

    }
  }


  void _getIdBranch(SearchLocationEvent event,emit) async {
    emit(state.copyWith(authStatus: AuthStatus.searchLocation));
    await Future.delayed(const Duration(seconds: 3));

    emit(state.copyWith(authStatus: AuthStatus.searchLocationComplete));
  }


  void _getCode(GetCodeEvent event, emit) async {
    emit(state.copyWith(authStatus: AuthStatus.sendRequestCode));
    await Future.delayed(const Duration(seconds: 3));
    emit(state.copyWith(authStatus: AuthStatus.awaitCode));
  }

  void _logOut(LogOutEvent event,emit) async {
    await PreferencesUtil.clear();
   emit(state.copyWith(authStatus: AuthStatus.logOut));
  }

}