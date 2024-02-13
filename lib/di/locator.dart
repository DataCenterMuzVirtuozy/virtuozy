



import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:virtuozy/data/repository/user_repository_impl.dart';
import 'package:virtuozy/data/services/user_service.dart';
import 'package:virtuozy/data/utils/user_util.dart';
import 'package:virtuozy/domain/repository/user_repository.dart';
import 'package:virtuozy/domain/user_cubit.dart';
import 'package:virtuozy/utils/theme_provider.dart';

final locator = GetIt.instance;

void setup() {

  locator.registerLazySingleton<ThemeProvider>(() => ThemeProvider());
  locator.registerLazySingleton<UserCubit>(() => UserCubit());


  locator.registerLazySingleton<UserService>(() => UserService());
  locator.registerLazySingleton<UserUtil>(() => UserUtil());
  locator.registerFactory<UserRepository>(() => UserRepositoryImpl());

  locator.registerLazySingleton(() => ValueNotifier<int>(0));


}