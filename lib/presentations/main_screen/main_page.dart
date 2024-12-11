


 import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:virtuozy/components/dialogs/dialoger.dart';
import 'package:virtuozy/components/home_drawer_menu.dart';
import 'package:virtuozy/domain/entities/user_entity.dart';
import 'package:virtuozy/presentations/auth_screen/bloc/auth_state.dart';
import 'package:virtuozy/presentations/teacher/clients_screen/clients_page.dart';
import 'package:virtuozy/presentations/teacher/lids_screen/lids_page.dart';

import 'package:virtuozy/resourses/colors.dart';
 import 'package:badges/badges.dart' as badges;
import 'package:virtuozy/resourses/strings.dart';
import 'package:virtuozy/router/paths.dart';
import 'package:virtuozy/utils/auth_mixin.dart';
import '../../../utils/text_style.dart';
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
        if(s.authStatus == AuthStatus.logOut||s.authStatus == AuthStatus.deleted){
          Dialoger.showToast('Аккаунт успешно удален'.tr());
          GoRouter.of(context).push(pathLogIn);
        }

        if(s.authStatus == AuthStatus.errorDeleting){
          Dialoger.showActionMaterialSnackBar(
              context: context, title: s.error);
        }

      },
      builder: (context,state) {

        if(state.authStatus == AuthStatus.deleting){
          return const Scaffold(
            body: Center(child: CircularProgressIndicator())
          );
        }

        return BackButtonListener(
          onBackButtonPressed: () async {
            if(context.canPop()){
              return false;
            }
           if(_stackPopPage.isEmpty){
             if (_popUnderway) {
               return false;
             }
             _popUnderway = true;
             Dialoger.showToast('Нажмите быстро два раза, чтобы закрыть приложение'.tr());
             await Future.delayed(const Duration(milliseconds: 700));
             _popUnderway = false;
             return true;
           }else{
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
            //backgroundColor: Theme.of(context).colorScheme.surface,
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.surface,
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

                      ValueListenableBuilder<int>(
                          valueListenable: currentItemNotifier,
                        builder: (context,currentIndexItemMenu,child) {
                          return TitlePage(title: userType.isStudent||userType.isUnknown?titlesDrawMenuStudent[currentIndexItemMenu]:
                          titlesDrawMenuTeacher[currentIndexItemMenu]);
                        }
                      ),
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
            drawer: const HomeDrawerMenu(),
          body: ValueListenableBuilder<int>(
              valueListenable: currentItemNotifier,
            builder: (context,currentIndexItemMenu,child) {
              if(currentIndexItemMenu == 0){
                _stackPopPage.clear();
              }else{
                if(!_stackPopPage.contains(currentIndexItemMenu)) {
                  _stackPopPage.add(currentIndexItemMenu);
                }


              }
              _indexPage = currentIndexItemMenu;
              return _buildScreens(userType: userType)[currentIndexItemMenu];
            }
          ),

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
        const WebPage(url: '',)
      ];
    }else if(userType.isTeacher){
      return [
        const TodaySchedulePage(),
        const ScheduleTablePage(),
        const LidsPage(),
        const ClientsPage(),
         Container()
      ];
    }else{
      return [
        const SubscriptionPage(),
        SchedulePage(currentMonth: globalCurrentMonthCalendar),
        const FinancePage(selIndexDirection: -1),
        const PromotionPage(),
        const WebPage(url: '',)
      ];
    }

  }


  void _openMenu(){
    scaffoldKey.currentState!.openDrawer();
  }

}