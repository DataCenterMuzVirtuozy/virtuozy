
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:virtuozy/domain/entities/teacher_entity.dart';
import 'package:virtuozy/domain/entities/user_entity.dart';
import 'package:virtuozy/domain/repository/teacher_repository.dart';
import 'package:virtuozy/domain/repository/user_repository.dart';
import 'package:virtuozy/domain/teacher_cubit.dart';
import 'package:virtuozy/domain/user_cubit.dart';
import 'package:virtuozy/utils/failure.dart';
import 'package:virtuozy/utils/preferences_util.dart';

import '../di/locator.dart';
import '../utils/network_check.dart';
part 'app_event.dart';
part 'app_state.dart';

 class AppBloc extends Bloc<AppEvent,AppState>{
  AppBloc():super(AppState.unknown()){
    on<InitAppEvent>(_initApp);
    on<ObserveNetworkEvent>(_observeNetwork);
    on<CheckNetworkEvent>(_checkNetwork);
  }

  final NetworkConnectivity _networkConnectivity = NetworkConnectivity.instance;
  final _userCubit = locator.get<UserCubit>();
  final _teacherCubit = locator.get<TeacherCubit>();
  final _userRepository = locator.get<UserRepository>();
  final _teacherRepository = locator.get<TeacherRepository>();
  Map _source = {ConnectivityResult.none: false};


  void _initApp(InitAppEvent event,emit) async {
  try{
   emit(state.copyWith(authStatusCheck: AuthStatusCheck.unknown,error: ''));
   final uid = PreferencesUtil.uid;
   if(uid.isEmpty){
    _userCubit.setUser(user: UserEntity.unknown());
    emit(state.copyWith(authStatusCheck: AuthStatusCheck.unauthenticated));
   }else {
      final userType = PreferencesUtil.userType;
     if(userType.isUnknown){
      emit(state.copyWith(authStatusCheck: AuthStatusCheck.unauthenticated));
     }else{
        if(userType.isStudent){
         final user = await _getUser(uid: uid);
         _userCubit.setUser(user: user);
         if(user.userStatus == UserStatus.auth){
          emit(state.copyWith(authStatusCheck: AuthStatusCheck.authenticated,userType: UserType.student));
         }else if(user.userStatus == UserStatus.moderation){
          emit(state.copyWith(authStatusCheck: AuthStatusCheck.moderation));
         }
        }else if(userType.isTeacher){
         final teacher = await _getTeacher(uid: uid);
         _teacherCubit.setTeacher(teacher: teacher);
         emit(state.copyWith(authStatusCheck: AuthStatusCheck.authenticated,userType: UserType.teacher));
        }
     }

   }

  }on Failure catch(e){
   emit(state.copyWith(authStatusCheck: AuthStatusCheck.error,error: e.message));

  }

  }

  Future<TeacherEntity> _getTeacher({required String uid}) async {
     return await _teacherRepository.getTeacher(uid: uid);
  }


  Future<UserEntity> _getUser({required String uid}) async {
   // final phone = PreferencesUtil.phoneUser;
   // final status = PreferencesUtil.statusUser;
   // final lastName = PreferencesUtil.lastNameUser;
   // final firstName = PreferencesUtil.firstNameUser;
   // final branch = PreferencesUtil.branchUser;
   return await _userRepository.getUser(uid: uid);
  }


  void _checkNetwork(CheckNetworkEvent event,emit)async{
   if(event.statusNetwork.isDisconnect){
    emit(state.copyWith(statusNetwork: StatusNetwork.disconnect));
   }else{
    emit(state.copyWith(statusNetwork: StatusNetwork.connect));
   }

  }

  void _observeNetwork( event,emit)async{

   _networkConnectivity.initialise();
   _networkConnectivity.myStream.listen((source) {
    _source = source;
    switch (_source.keys.toList()[0]) {
     case ConnectivityResult.mobile:
      add(const CheckNetworkEvent(statusNetwork: StatusNetwork.connect));
      break;
     case ConnectivityResult.wifi:
      add(const CheckNetworkEvent(statusNetwork: StatusNetwork.connect));
      break;
     case ConnectivityResult.none:
      add(const CheckNetworkEvent(statusNetwork: StatusNetwork.disconnect));
      break;

    }});


  }

 }


