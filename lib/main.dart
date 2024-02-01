import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtuozy/resourses/colors.dart';
import 'package:virtuozy/router/app_router.dart';
import 'package:virtuozy/utils/app_theme.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:virtuozy/utils/preferences_util.dart';
import 'package:virtuozy/di/locator.dart' as di;
import 'package:virtuozy/utils/theme_provider.dart';

import 'di/locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await PreferencesUtil.init();
  di.setup();
  runApp(EasyLocalization(
      supportedLocales: const [Locale('ru', 'RU')],
  path: 'lib/assets/translations',
      fallbackLocale:const Locale('ru', 'RU'),
  child:  MyApp()));
}

class MyApp extends StatefulWidget {
   MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final themeProvider = locator.get<ThemeProvider>();

  _getCurrentTheme(){
    final theme=PreferencesUtil.getTheme;
    //todo save color
    themeProvider.setTheme(themeFirst: true,color: colorGreen);
  }


  @override
  void initState() {
    super.initState();
    _getCurrentTheme();
  } // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) {
        return themeProvider;
      },
      child: Consumer<ThemeProvider>(
        builder: (context,theme,child) {
          return MaterialApp.router(
            title: 'Flutter Demo',
            theme:theme.themeFirst?AppTheme.first:AppTheme.custom(theme.color),
            themeAnimationCurve: Curves.easeIn,
            themeAnimationDuration: const Duration(milliseconds: 1000),
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            routerConfig: AppRouter.router,
            builder: (context, child) => ResponsiveBreakpoints.builder(
              child: child!,
              breakpoints: [
                const Breakpoint(start: 0, end: 450, name: MOBILE),
                const Breakpoint(start: 451, end: 800, name: TABLET),
              ],
            ),
            //home: const MyHomePage(title: 'Flutter Demo Home Page'),
          );
        }
      ),
    );
  }
}

