


 import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:virtuozy/components/calendar/calendar.dart';
import 'package:virtuozy/components/dialogs/dialoger.dart';
import 'package:virtuozy/components/home_drawer_menu.dart';
import 'package:virtuozy/domain/entities/user_entity.dart';
import 'package:virtuozy/presentations/auth_screen/bloc/auth_state.dart';

import 'package:virtuozy/resourses/colors.dart';
import 'package:virtuozy/resourses/images.dart';
 import 'package:badges/badges.dart' as badges;
import 'package:virtuozy/resourses/strings.dart';
import 'package:virtuozy/router/paths.dart';
import 'package:virtuozy/utils/auth_mixin.dart';
import '../../../utils/text_style.dart';
import '../../../utils/theme_provider.dart';
import '../../components/title_page.dart';
import '../auth_screen/bloc/auth_bloc.dart';
import '../student/finance_screen/finance_page.dart';
import '../student/promotion_screen/promotion_page.dart';
import '../student/schedule_screen/schedule_page.dart';
import '../student/subscription_screen/subscription_page.dart';
import '../student/web_screen/web_page.dart';
import '../teacher/schedule_table_screen/schedule_table_page.dart';
import '../teacher/today_schedule_screen/today_schedule_page.dart';





  GlobalKey<ScaffoldState> scaffoldKeyGlobal = GlobalKey<ScaffoldState>();

class MainPage extends StatefulWidget{
   const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with AuthMixin{
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();



  int _indexPage = 0;
  List<int> _stackPopPage = [];
   var _titlePage = '';


  @override
  void initState() {
    super.initState();
    _titlePage = titlesDrawMenuStudent[0];
    scaffoldKeyGlobal = scaffoldKey;
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();


  }



  @override
  Widget build(BuildContext context) {

    bool _popUnderway = false;

    return BlocConsumer<AuthBloc,AuthState>(
      listener: (c, s) {
        if(s.authStatus == AuthStatus.logOut){
          GoRouter.of(context).push(pathLogIn);
        }
      },
      builder: (context,state) {
        return BackButtonListener(
          onBackButtonPressed: () async {
            if(context.canPop()){
              return false;
            }
           if(_stackPopPage.isEmpty){
             if (_popUnderway) {
               print('A1');
               return false;
             }
             _popUnderway = true;
             print('A2');
             Dialoger.showToast('Нажмите быстро два раза, чтобы закрыть приложение'.tr());
             await Future.delayed(const Duration(milliseconds: 700));
             _popUnderway = false;
             return true;
           }else{
             print('A3');
             setState(() {
               int lastIndex = _stackPopPage.length -1;
               _stackPopPage.removeAt(lastIndex);
               if(_stackPopPage.isEmpty){
                   _indexPage = 0;
                   _titlePage = titlesDrawMenuStudent[_indexPage];
               }else{
                 _indexPage = _stackPopPage[_stackPopPage.length-1];
                 _titlePage = titlesDrawMenuStudent[_indexPage];
               }

               currentItemNotifier.value = _indexPage;

             });
             return true;
           }




          },
          child: Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.background,
              automaticallyImplyLeading: false,
              actions: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(onPressed: (){
                        _openMenu();
                      }, icon:                          Icon(
                        //Icons.library_music_outlined,
                          CupertinoIcons.music_note_list,
                          color: Theme.of(context).iconTheme.color)),

                      TitlePage(title: _titlePage),
                      badges.Badge(
                          position: badges.BadgePosition.topStart(start: 5.0,top: 3.0),
                        showBadge: false,
                      badgeContent: Text('3',style: TStyle.textStyleVelaSansBold(colorWhite)),
                          child: IconButton(
                              onPressed: () {
                                GoRouter.of(context).push(pathNotification);
                              },
                              icon: Icon(Icons.notifications_none_rounded,color:Theme.of(context).iconTheme.color))),

                    ],
                  ),
                )
              ],
            ),
            drawer: HomeDrawerMenu(
              onCallLogOut: () {  },
            onSelectedPage: (index){
              setState(() {
                if(index == 0){
                  _stackPopPage.clear();
                }else{
                  if(_stackPopPage.contains(index))return;
                  _stackPopPage.add(index);

                }
                _indexPage = index;
                _titlePage = titlesDrawMenuStudent[_indexPage];

              });


            },),
          body: _buildScreens(userType: userType)[_indexPage],
          //   body:  PersistentTabView(
          //   context,
          //   controller: _controller,
          //   screens: _buildScreens(),
          //   items: _navBarsItems(),
          //   confineInSafeArea: true,
          //   backgroundColor: Colors.white, // Default is Colors.white.
          //   handleAndroidBackButtonPress: true, // Default is true.
          //   resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
          //   stateManagement: true, // Default is true.
          //   hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
          //   decoration: NavBarDecoration(
          //     borderRadius: BorderRadius.circular(10.0),
          //     colorBehindNavBar: Colors.white,
          //   ),
          //   popAllScreensOnTapOfSelectedTab: true,
          //   popActionScreens: PopActionScreensType.all,
          //   itemAnimationProperties: ItemAnimationProperties( // Navigation Bar's items animation properties.
          //     duration: Duration(milliseconds: 200),
          //     curve: Curves.ease,
          //   ),
          //   screenTransitionAnimation: ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
          //     animateTabTransition: true,
          //     curve: Curves.ease,
          //     duration: Duration(milliseconds: 200),
          //   ),
          //   navBarStyle: NavBarStyle.style1, // Choose the nav bar style with this property.
          // ),
          ),
        );
      },
    );
  }


  List<Widget> _buildScreens({required UserType userType}) {
    if(userType.isStudent){
      return [
        const SubscriptionPage(),
        SchedulePage(currentMonth: globalCurrentMonthCalendar),
        const FinancePage(selIndexDirection: -1),
        const PromotionPage(),
        const WebPage()
      ];
    }else if(userType.isTeacher){
      return [
        const TodaySchedulePage(),
        const ScheduleTablePage()
      ];
    }else{
      return [
        const SubscriptionPage(),
        SchedulePage(currentMonth: globalCurrentMonthCalendar),
        const FinancePage(selIndexDirection: -1),
        const PromotionPage(),
        const WebPage()
      ];
    }

  }


  void _openMenu(){
    scaffoldKey.currentState!.openDrawer();
  }
  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.home),
        title: ("Главная".tr()),
        activeColorPrimary: colorOrange,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.calendar_today),
        title: ("Расписание".tr()),
        activeColorPrimary: colorOrange,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.money_rubl_circle),
        title: ("Финансы".tr()),
        activeColorPrimary: colorOrange,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.store_mall_directory_rounded),
        title: ("Предложения".tr()),
        activeColorPrimary: colorOrange,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.globe),
        title: ("Сайт".tr()),
        activeColorPrimary: colorOrange,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }
}