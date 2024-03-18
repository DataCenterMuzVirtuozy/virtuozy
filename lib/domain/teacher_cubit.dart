


import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtuozy/domain/entities/teacher_entity.dart';

class TeacherCubit extends Cubit<TeacherEntity>{
  TeacherCubit():super(TeacherEntity.unknown());


  TeacherEntity teacherEntity = TeacherEntity.unknown();


  getTeacher(){
    emit(teacherEntity);
  }



  setTeacher({required TeacherEntity teacher}){
    teacherEntity = teacher;
    emit(teacherEntity);
  }


  updateTeacher({required TeacherEntity newTeacher}){
    teacherEntity = newTeacher;
    emit(teacherEntity);
  }



}