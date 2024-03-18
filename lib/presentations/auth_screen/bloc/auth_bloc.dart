



 import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtuozy/di/locator.dart';
import 'package:virtuozy/domain/entities/user_entity.dart';
import 'package:virtuozy/domain/repository/teacher_repository.dart';
import 'package:virtuozy/domain/repository/user_repository.dart';
import 'package:virtuozy/domain/teacher_cubit.dart';
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
    on<LogOutTeacherEvent>(_logOutTeacher);
  }


    final _userCubit = locator.get<UserCubit>();
    final _userRepository = locator.get<UserRepository>();
    final _teacherRepository = locator.get<TeacherRepository>();
    final _teacherCubit = locator.get<TeacherCubit>();
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

      if(event.phone == "+3 (333) 333-33-33"){
        final teacher = await _teacherRepository.getTeacher(uid: event.phone);
        _teacherCubit.setTeacher(teacher: teacher);
        await PreferencesUtil.setTypeUser(userType: UserType.teacher);
        await PreferencesUtil.setUID(uid: event.phone);
        emit(state.copyWith(authStatus: AuthStatus.authenticated));
         return;
      }

      if(phone == event.phone){
        await Future.delayed(const Duration(seconds: 1));
        //todo id
        _userCubit.setUser(user:  UserEntity(
            userStatus: UserStatus.moderation,
            lastName: PreferencesUtil.lastNameUser,
            firstName: PreferencesUtil.firstNameUser,
            branchName: PreferencesUtil.branchUser,
            phoneNumber: PreferencesUtil.phoneUser,
            userType: UserType.student,
            directions: [],
            id: 0));
        await PreferencesUtil.setTypeUser(userType: UserType.student);
        emit(state.copyWith(authStatus: AuthStatus.moderation));
        return;
      }else{
        final user = await _userRepository.getUser(uid: event.phone);
        await PreferencesUtil.setUID(uid: event.phone);
        _userCubit.setUser(user: user);
        await _createLocalUser(user);
        await Future.delayed(const Duration(seconds: 1));
        await PreferencesUtil.setTypeUser(userType: UserType.student);
        emit(state.copyWith(authStatus: AuthStatus.authenticated));
        return;
      }

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


      user =  UserEntity(
          userStatus: UserStatus.moderation,
          lastName: event.lastName,
          firstName: event.firstName,
          branchName: '',
          phoneNumber: event.phone,
          userType: UserType.student,
          directions: [],
          id: 0);
      await _createLocalUser(user);
      emit(state.copyWith(authStatus: AuthStatus.onSearchLocation));
    }on Failure catch(e){
       emit(state.copyWith(authStatus: AuthStatus.error,error: e.message));
    }

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
    await Future.delayed(const Duration(seconds: 3));

    emit(state.copyWith(authStatus: AuthStatus.searchLocationComplete));
  }


  void _getCode(GetCodeEvent event, emit) async {
    emit(state.copyWith(authStatus: AuthStatus.sendRequestCode));
    await Future.delayed(const Duration(seconds: 3));
    emit(state.copyWith(authStatus: AuthStatus.awaitCode));
  }

  void _logOut(LogOutEvent event,emit) async {
    if(event.user.userStatus.isModeration || event.user.userStatus.isAuth){
      await PreferencesUtil.clear();
    }

   emit(state.copyWith(authStatus: AuthStatus.logOut));
  }

  void _logOutTeacher(LogOutTeacherEvent event,emit) async{
    await PreferencesUtil.clear();
    emit(state.copyWith(authStatus: AuthStatus.logOut));
  }

}