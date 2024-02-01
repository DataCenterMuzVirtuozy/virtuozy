



import 'package:get_it/get_it.dart';
import 'package:virtuozy/utils/theme_provider.dart';

final locator = GetIt.instance;

void setup() {

  locator.registerLazySingleton<ThemeProvider>(() => ThemeProvider());

}