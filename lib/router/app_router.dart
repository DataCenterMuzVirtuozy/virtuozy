
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:virtuozy/domain/entities/document_entity.dart';
import 'package:virtuozy/domain/entities/subscription_entity.dart';
import 'package:virtuozy/domain/entities/user_entity.dart';
import 'package:virtuozy/presentations/auth_screen/login_page.dart';
import 'package:virtuozy/presentations/auth_screen/reset_password_page.dart';
import 'package:virtuozy/presentations/auth_screen/singin_page.dart';
import 'package:virtuozy/presentations/auth_screen/success_send_sms_page.dart';
import 'package:virtuozy/presentations/student/document_screen/documents_page.dart';
import 'package:virtuozy/presentations/student/finance_screen/list_bonus_lesson.dart';
import 'package:virtuozy/presentations/student/notification_screen/setting_notifications_page.dart';
import 'package:virtuozy/presentations/student/settings_screen/settings_page.dart';
import 'package:virtuozy/presentations/teacher/clients_screen/clients_page.dart';

import 'package:virtuozy/router/paths.dart';

import '../main.dart';
import '../presentations/main_screen/main_page.dart';
import '../presentations/student/branch_search_screen/branch_search_page.dart';
import '../presentations/student/document_screen/preview_doc_page.dart';
import '../presentations/student/finance_screen/finance_page.dart';
import '../presentations/student/finance_screen/list_subscriptions_hystory.dart';
import '../presentations/student/finance_screen/list_transactios_page.dart';
import '../presentations/student/finance_screen/pay_page.dart';
import '../presentations/student/notification_screen/notification_page.dart';
import '../presentations/student/onboarding_screen/onboarding_page.dart';
import '../presentations/student/profile_screen/profile_page.dart';
import '../presentations/student/promotion_screen/details_promo_page.dart';
import '../presentations/student/schedule_screen/details_schedule_page.dart';
import '../presentations/student/subscription_screen/details_bonus_page.dart';
import '../presentations/student/theme_screen/theme_page.dart';
import '../presentations/student/web_screen/web_page.dart';


class AppRouter{


  static GoRouter get router=>GoRouter(
    initialLocation: pathApp,
    routes: [
      GoRoute(
        path: pathResetPass,
        pageBuilder: (context, state) {

          return CupertinoPage(
              key: state.pageKey,
              child:    ResetPasswordPage(editPass: state.extra as bool));
        },
      ),
      GoRoute(
        path: pathClients,
        pageBuilder: (context, state) {

          return CupertinoPage(
              key: state.pageKey,
              child:   const ClientsPage());
        },
      ),
      GoRoute(
        path: pathSettings,
        pageBuilder: (context, state) {

          return CupertinoPage(
              key: state.pageKey,
              child:   const SettingsPage());
        },
      ),
      GoRoute(
        path: pathBonusLessons,
        pageBuilder: (context, state) {

          return CupertinoPage(
              key: state.pageKey,
              child:   const ListBonusLessons());
        },
      ),
      GoRoute(
        path: pathSettingNotifi,
        pageBuilder: (context, state) {

          return CupertinoPage(
              key: state.pageKey,
              child:   const SettingNotificationsPage());
        },
      ),
      GoRoute(
        path: pathPreviewDoc,
        pageBuilder: (context, state) {
          final data = (state.extra as DocumentEntity);
          return CupertinoPage(
              key: state.pageKey,
              child:   PreviewDocPage(documentEntity: data,));
        },
      ),
      GoRoute(
        path: pathDocuments,
        pageBuilder: (context, state) {
          return CupertinoPage(
              key: state.pageKey,
              child:  const DocumentsPage());
        },
      ),
      GoRoute(
        path: pathProfile,
        pageBuilder: (context, state) {
          return CupertinoPage(
              key: state.pageKey,
              child:  const UserProfilePage());
        },
      ),
      GoRoute(
        path: pathFinance,
        pageBuilder: (context, state) {
          final data = (state.extra as int);
          return CupertinoPage(
              key: state.pageKey,
              child:  FinancePage(selIndexDirection: data));
        },
      ),
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
              child:  ListSubscriptionHistory(
                  listExpiredSubscriptions: (state.extra as List<SubscriptionEntity>)));
        },
      ),
      GoRoute(
        path: pathWep,
        pageBuilder: (context, state) {
          return CupertinoPage(
              key: state.pageKey,
              child:    WebPage(url: (state.extra as String)));
        },
      ),
      GoRoute(
        path: pathPay,
        pageBuilder: (context, state) {
          return CupertinoPage(
              key: state.pageKey,
              child:   PayPage(directions: state.extra as List<DirectionLesson>));
        },
      ),
      GoRoute(
        path: pathListTransaction,
        pageBuilder: (context, state) {
          return CupertinoPage(
              key: state.pageKey,
              child:  ListTransactionsPage(
                  directions: (state.extra as List<DirectionLesson>)));
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
            child:  SuccessSendSMS(resetPass: state.extra as bool)),
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