



 import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtuozy/domain/entities/teacher_entity.dart';
import 'package:virtuozy/domain/entities/user_entity.dart';

class UserCubit extends Cubit<UserEntity>{
  UserCubit():super(UserEntity.unknown());


  UserEntity userEntity = UserEntity.unknown();


  getUser(){
    emit(userEntity);
  }


  setUser({required UserEntity user}){
    print('setUser');
    userEntity = user;
    emit(userEntity);
  }




  updateUser({required UserEntity newUser}){
    print('updateUser');
      userEntity = newUser;
      emit(userEntity);
  }



}