
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtuozy/domain/entities/teacher_entity.dart';
import 'package:virtuozy/domain/entities/user_entity.dart';
import 'package:virtuozy/domain/teacher_cubit.dart';
import 'package:virtuozy/domain/user_cubit.dart';
import 'package:virtuozy/utils/preferences_util.dart';

import '../bloc/app_bloc.dart';
import '../di/locator.dart';

mixin AuthMixin<T extends StatefulWidget> on State<T> {
  final _userCubit = locator.get<UserCubit>();
  final _teacherCubit = locator.get<TeacherCubit>();
  UserEntity get user =>_userCubit.userEntity;
  TeacherEntity get teacher => _teacherCubit.teacherEntity;
  UserType get userType => PreferencesUtil.userType;

}
