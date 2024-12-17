import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:virtuozy/bloc/app_bloc.dart';
import 'package:virtuozy/di/locator.dart' as di;
import 'package:virtuozy/domain/user_cubit.dart';
import 'package:virtuozy/presentations/auth_screen/bloc/auth_bloc.dart';
import 'package:virtuozy/presentations/main_screen/main_page.dart';
import 'package:virtuozy/presentations/student/document_screen/bloc/docs_bloc.dart';
import 'package:virtuozy/presentations/student/finance_screen/bloc/bloc_finance.dart';
import 'package:virtuozy/presentations/student/notification_screen/bloc/notifi_bloc.dart';
import 'package:virtuozy/presentations/student/profile_screen/bloc/profile_bloc.dart';
import 'package:virtuozy/presentations/student/schedule_screen/bloc/schedule_bloc.dart';
import 'package:virtuozy/presentations/student/splash_screen/splash_page.dart';
import 'package:virtuozy/presentations/student/subscription_screen/bloc/sub_bloc.dart';
import 'package:virtuozy/presentations/teacher/clients_screen/bloc/clients_bloc.dart';
import 'package:virtuozy/presentations/teacher/clients_screen/clients_page.dart';
import 'package:virtuozy/presentations/teacher/schedule_table_screen/bloc/table_bloc.dart';
import 'package:virtuozy/presentations/teacher/today_schedule_screen/bloc/today_schedule_bloc.dart';
import 'package:virtuozy/router/app_router.dart';
import 'package:virtuozy/utils/app_theme.dart';
import 'package:virtuozy/utils/preferences_util.dart';
import 'package:virtuozy/utils/theme_provider.dart';

import 'components/dialogs/dialoger.dart';
import 'di/locator.dart';
import 'presentations/teacher/lids_screen/bloc/lids_bloc.dart';



Future<void> _backgroundHandler(RemoteMessage message) async {
  // Handle background message
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  //FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
  await EasyLocalization.ensureInitialized();
  await PreferencesUtil.init();
  await FlutterDownloader.initialize(
      debug: true,
      // optional: set to false to disable printing logs to console (default: true)
      ignoreSsl:
          true // option: set to false to disable working with http links (default: false)
      );
  //final notificationSettings = await FirebaseMessaging.instance.requestPermission(provisional: true);

// For apple platforms, ensure the APNS token is available before making any FCM plugin API calls
//   final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
//   if (apnsToken != null) {
//     print('APNS token is available, make FCM plugin API requests');
//     // APNS token is available, make FCM plugin API requests...
//   }
  di.setup();

  runApp(EasyLocalization(
      supportedLocales: const [Locale('ru', 'RU')],
      path: 'lib/assets/translations',
      fallbackLocale: const Locale('ru', 'RU'),
      child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final themeProvider = locator.get<ThemeProvider>();

  _getCurrentTheme() {
    final theme = PreferencesUtil.getTheme;
    final color = PreferencesUtil.getColorScheme;
    themeProvider.setTheme(themeStatus: theme, color: color);
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
      child: Consumer<ThemeProvider>(builder: (c, theme, widget) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<AppBloc>(
                create: (_) => AppBloc()..add(ObserveNetworkEvent())),
            BlocProvider<AuthBloc>(create: (_) => AuthBloc()),
            BlocProvider<SubBloc>(create: (_) => SubBloc()),
            BlocProvider<ScheduleBloc>(create: (_) => ScheduleBloc()),
            BlocProvider<BlocFinance>(create: (_) => BlocFinance()),
            BlocProvider<UserCubit>(create: (_) => UserCubit()),
            BlocProvider<NotifiBloc>(create: (_) => NotifiBloc()),
            BlocProvider<DocsBloc>(create: (_) => DocsBloc()),
            BlocProvider<ProfileBloc>(create: (_) => ProfileBloc()),
            BlocProvider<TodayScheduleBloc>(create: (_) => TodayScheduleBloc()),
            BlocProvider<TableBloc>(create: (_) => TableBloc()),
            BlocProvider<ClientsBloc>(create: (_) => ClientsBloc()),
            BlocProvider<LidsBloc>(create: (_) => LidsBloc())
          ],
          child: MaterialApp.router(
            title: 'Flutter Demo',
            theme: theme.themeStatus == ThemeStatus.first
                ? AppTheme.first
                : theme.themeStatus == ThemeStatus.dark
                    ? AppTheme.dark
                    : AppTheme.custom(theme.color),
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
          ),
        );
      }),
    );
  }
}

class InitPage extends StatefulWidget {
  const InitPage({super.key});

  @override
  State<InitPage> createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppBloc, AppState>(listener: (c, s) {
      if (s.authStatusCheck == AuthStatusCheck.error) {
        Dialoger.showActionMaterialSnackBar(
            context: context, onAction: () {}, title: s.error);
      }
      if (s.statusNetwork.isDisconnect) {
        Dialoger.showActionMaterialSnackBar(
            context: context, onAction: () {}, title: 'Нет сети'.tr());
      }
    }, builder: (context, state) {
      //return const ClientsPage();
      if (state.authStatusCheck == AuthStatusCheck.unknown) {
        return const SplashPage();
      } else if (state.authStatusCheck == AuthStatusCheck.unauthenticated ||
          state.authStatusCheck == AuthStatusCheck.moderation) {
        return const MainPage();
      }

      return const MainPage();
    });
  }

  @override
  void initState() {
    super.initState();
    context.read<AppBloc>().add(InitAppEvent());
  }
}
