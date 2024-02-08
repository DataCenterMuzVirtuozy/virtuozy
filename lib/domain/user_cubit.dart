



 import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtuozy/domain/entities/user_entity.dart';

class UserCubit extends Cubit<UserEntity>{
  UserCubit():super(UserEntity.unknown());


  UserEntity userEntity = UserEntity.unknown();


  getUser(){
    emit(userEntity);
  }


  setUser({required UserEntity user}){
    userEntity = user;
    emit(userEntity);
  }


  updateUser({required UserEntity newUser}){
      userEntity = newUser;
      emit(userEntity);
  }



}