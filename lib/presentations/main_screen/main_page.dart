


 import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:virtuozy/components/calendar.dart';
import 'package:virtuozy/components/home_drawer_menu.dart';
import 'package:virtuozy/presentations/home_screen/home_page.dart';
import 'package:virtuozy/presentations/pay_screen/pay_page.dart';
import 'package:virtuozy/presentations/schedule_screen/schedule_page.dart';
import 'package:virtuozy/presentations/web_screen/web_page.dart';
import 'package:virtuozy/presentations/promotion_screen/promotion_page.dart';
import 'package:virtuozy/resourses/colors.dart';
import 'package:virtuozy/resourses/images.dart';
 import 'package:badges/badges.dart' as badges;
import 'package:virtuozy/router/paths.dart';

import '../../utils/text_style.dart';

class MainPage extends StatefulWidget{
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {


  late PersistentTabController _controller;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  int _indexPage = 0;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(onPressed: (){
                  _openMenu();
                }, icon: const Icon(Icons.menu_open_rounded)),
                SvgPicture.asset(logo,width: 100.0),
                badges.Badge(
                    position: badges.BadgePosition.topStart(start: 5.0,top: 3.0),
                  showBadge: true,
                badgeContent: Text('3',style: TStyle.textStyleVelaSansBold(colorWhite)),
                    child: IconButton(
                        onPressed: () {
                          GoRouter.of(context).push(pathNotification);
                        },
                        icon: const Icon(Icons.notifications_none_rounded))),

              ],
            ),
          )
        ],
      ),
      drawer: HomeDrawerMenu(
        onCallLogOut: () {  },
      onSelectedPage: (index){
          setState(() {
            _indexPage = index;
          });
      },),
    body: _buildScreens()[_indexPage],
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
    );
  }


  List<Widget> _buildScreens() {
    return [
      const HomePage(),
      const SchedulePage(),
      const PayPage(),
      const PromotionPage(),
      const WebPage()
    ];
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