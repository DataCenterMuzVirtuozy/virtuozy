
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:virtuozy/domain/entities/user_entity.dart';
import 'package:virtuozy/presentations/auth_screen/login_page.dart';
import 'package:virtuozy/presentations/auth_screen/singin_page.dart';
import 'package:virtuozy/presentations/auth_screen/success_send_sms_page.dart';
import 'package:virtuozy/presentations/branch_search_screen/branch_search_page.dart';
import 'package:virtuozy/presentations/finance_screen/pay_page.dart';
import 'package:virtuozy/presentations/main_screen/main_page.dart';
import 'package:virtuozy/presentations/notification_screen/notification_page.dart';
import 'package:virtuozy/presentations/onboarding_screen/onboarding_page.dart';
import 'package:virtuozy/presentations/promotion_screen/details_promo_page.dart';
import 'package:virtuozy/presentations/schedule_screen/details_schedule_page.dart';
import 'package:virtuozy/presentations/subscription_screen/details_bonus_page.dart';
import 'package:virtuozy/presentations/theme_screen/theme_page.dart';
import 'package:virtuozy/router/paths.dart';

import '../main.dart';
import '../presentations/finance_screen/list_subscriptions_hystory.dart';
import '../presentations/finance_screen/list_transactios_page.dart';
import '../presentations/schedule_screen/schedule_page.dart';

class AppRouter{


  static GoRouter get router=>GoRouter(
    initialLocation: pathApp,
    routes: [

      GoRoute(
        path: pathDetailBonus,
        pageBuilder: (context, state) {
          final data = (state.extra as List<dynamic>);
          return CupertinoPage(
              key: state.pageKey,
              child:  DetailsBonusPage(bonusEntity: (data[0] as BonusEntity),
              directionLesson: (data[1] as DirectionLesson)));
        },
      ),
      GoRoute(
        path: pathBranchSearch,
        pageBuilder: (context, state) {
          return CupertinoPage(
              key: state.pageKey,
              child: const BranchSearchPage());
        },
      ),
      GoRoute(
        path: pathMain,
        pageBuilder: (context, state) {
          return CupertinoPage(
              key: state.pageKey,
              child: const MainPage());
        },
      ),
      GoRoute(
        path: pathApp,
        pageBuilder: (context, state) {
          return CupertinoPage(
              key: state.pageKey,
              child: const InitPage());
        },
      ),
      GoRoute(
        path: pathTheme,
        pageBuilder: (context, state) {
          return CupertinoPage(
              key: state.pageKey,
              child: const ThemePage());
        },
      ),
      GoRoute(
        path: pathListSubscriptionsHistory,
        pageBuilder: (context, state) {
          return CupertinoPage(
              key: state.pageKey,
              child: const ListSubscriptionHistory());
        },
      ),
      GoRoute(
        path: pathPay,
        pageBuilder: (context, state) {
          return CupertinoPage(
              key: state.pageKey,
              child:   PayPage(direction: state.extra as DirectionLesson));
        },
      ),
      GoRoute(
        path: pathListTransaction,
        pageBuilder: (context, state) {
          return CupertinoPage(
              key: state.pageKey,
              child:  ListTransactionsPage());
        },
      ),
      GoRoute(
        path: pathDetailsSchedule,
        pageBuilder: (context, state) {
          return CupertinoPage(
              key: state.pageKey,
              child: const DetailsSchedulePage());
        },
      ),
      GoRoute(
        path: pathDetailPromo,
        pageBuilder: (context, state) {
          return CupertinoPage(
              key: state.pageKey,
              child:  DetailsPromoPage(title: (state.extra as String)??'',));
        },
      ),
      GoRoute(
        path: pathNotification,
        pageBuilder: (context, state) {
          return CupertinoPage(
              key: state.pageKey,
              child: const NotificationPage());
        },
      ),
      GoRoute(
        path: pathOnBoarding,
        pageBuilder: (context, state) => CupertinoPage(
            key: state.pageKey,
            child: const OnBoardingPage()),
      ),
      GoRoute(
        path: pathLogIn,
        pageBuilder: (context, state) => CupertinoPage(
            key: state.pageKey,
            child: const LogInPage()),
      ),
      GoRoute(
        path: pathSingIn,
        pageBuilder: (context, state) => CupertinoPage(
            key: state.pageKey,
            child: const SingInPage()),
      ),
      GoRoute(
        path: pathSuccessSendSMS,
        pageBuilder: (context, state) => CupertinoPage(
            key: state.pageKey,
            child: const SuccessSendSMS()),
      ),
    ],
  );



}

class SlideRightRoute extends PageRouteBuilder {
  final Widget page;
  SlideRightRoute({required this.page})
      : super(
    pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) =>
    page,
    transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
        ) =>
        SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
  );
}