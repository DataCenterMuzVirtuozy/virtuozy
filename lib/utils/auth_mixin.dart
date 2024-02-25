
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtuozy/domain/entities/user_entity.dart';
import 'package:virtuozy/domain/user_cubit.dart';

import '../bloc/app_bloc.dart';
import '../di/locator.dart';

mixin AuthMixin<T extends StatefulWidget> on State<T> {
  final _userCubit = locator.get<UserCubit>();
  UserEntity get user =>_userCubit.userEntity;



}
