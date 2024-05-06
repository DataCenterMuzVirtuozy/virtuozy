


import 'dart:ui';

import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:virtuozy/components/dialogs/contents/bottom_sheet_menu/support_list_content.dart';
import 'package:virtuozy/components/dialogs/dialoger.dart';
import 'package:virtuozy/components/dialogs/sealeds.dart';
import 'package:virtuozy/domain/entities/teacher_entity.dart';
import 'package:virtuozy/domain/entities/user_entity.dart';
import 'package:virtuozy/resourses/colors.dart';
import 'package:virtuozy/resourses/images.dart';
import 'package:virtuozy/resourses/strings.dart';
import 'package:virtuozy/router/paths.dart';
import 'package:virtuozy/utils/auth_mixin.dart';

import '../utils/text_style.dart';
import 'package:badges/src/badge.dart' as badge;

int _currentIndexItemMenu = 0;
ValueNotifier<int> currentItemNotifier = ValueNotifier(0);

class HomeDrawerMenu extends StatefulWidget{
  const HomeDrawerMenu({super.key});

  // final VoidCallback onCallLogOut;
  // final Function onSelectedPage;

  @override
  State<HomeDrawerMenu> createState() => _HomeDrawerMenuState();
}

class _HomeDrawerMenuState extends State<HomeDrawerMenu> with AuthMixin{



  @override
  void didChangeDependencies() {
   super.didChangeDependencies();

  }

  Widget _getAvatar(String urlAva){
    if(urlAva.isEmpty){
        return Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: colorWhite,width: 1.5)
            ),
            child: Icon(Icons.image_search_rounded,color: colorWhite,size: 30,));
      }else{

      return Container(
        width: 80,
        height: 80,
        decoration: const BoxDecoration(
            shape: BoxShape.circle,
        ),
        child: ClipOval(
          child: CachedNetworkImage(
            key: ValueKey(user.avaUrl),
            fit: BoxFit.cover,
            imageUrl: user.avaUrl,
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                CircularProgressIndicator(value: downloadProgress.progress,color: colorWhite),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
      );

      }

  }




  @override
  Widget build(BuildContext context) {
    final width = MediaQuery
        .of(context)
        .size
        .width;
    final height = MediaQuery
        .of(context)
        .size
        .height;
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 5),
      child: Container(
        margin:const EdgeInsets.only(right: 100),
        width: width/1.2,
        decoration:  BoxDecoration(
            color: Theme.of(context).colorScheme.background,
          borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0))),
        //height: height/2,
        child: Drawer(
          backgroundColor: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Stack(
                    children: [
                      InkWell(
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.bottomCenter,
                              constraints: const BoxConstraints(minHeight: 100),
                              padding: const EdgeInsets.only(left: 105,top: 50,right: 20,bottom: 5),
                              width: width,
                              decoration: BoxDecoration(
                                  color: colorYellow
                              ),
                              child:  Visibility(
                                visible: user.userStatus.isAuth||user.userStatus.isModeration,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text('${userType.isStudent?user.firstName:teacher.firstName} ${userType.isStudent?user.lastName:teacher.lastName}',
                                          maxLines: 2,
                                          style: TStyle.textStyleGaretHeavy(colorWhite,size: 15.0)),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Visibility(
                              visible: user.userStatus.isAuth||user.userStatus.isModeration,
                              child: Container(
                                alignment: Alignment.topLeft,
                                  padding: const EdgeInsets.only(left: 105,top: 10),
                                  width: width,
                                  height: 40,
                                  color: colorOrange,
                              child:
                                 Row(
                                   children: [
                                     Icon(Icons.phone_enabled_rounded,color: colorWhite,
                                         size: 12.0),
                                     const Gap(5.0),
                                     Text(userType.isStudent?user.phoneNumber:
                                     teacher.phoneNum,
                                         style: TStyle.textStyleVelaSansBold(colorWhite,size: 12.0)),
                                   ],
                                 )),
                            ),
                          ],
                        ),
                        onTap: (){
                          GoRouter.of(context).push(pathProfile);
                          Navigator.pop(context);
                        },
                      ),
                      Visibility(
                        visible: user.userStatus.isAuth||user.userStatus.isModeration,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: InkWell(
                            onTap: (){
                              GoRouter.of(context).push(pathProfile);
                              Navigator.pop(context);
                            },
                            child: Container(
                              margin: const EdgeInsets.only(top: 50,left: 10),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: colorOrange
                              ),
                              padding: const EdgeInsets.all(2),
                              child:  _getAvatar(user.avaUrl),
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                  const Gap(20.0),
                  _getItemsMenu(userType: userType,
                      context: context,
                      user: user,
                      //currentIndexItemMenu: _currentIndexItemMenu,
                      docsAccept: docsAccept,
                      onSelectedPage:(item){
                        setState(() {
                          //_currentIndexItemMenu = item;
                          currentItemNotifier.value = item;
                          //widget.onSelectedPage.call(item);
                        });

                      }, teacher: teacher),
                ],
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //todo url enter
                    IconButton(onPressed: ()async{
                      Dialoger.showBottomMenu(
                          title: 'Telegram',
                          args: TypeMessager.telegram,
                          context: context,
                          content: ListSupport());
                    }, icon:  Image.asset(telegram,width: 30,height: 30,)),
                    IconButton(onPressed: () async {
                      Dialoger.showBottomMenu(
                          title: 'WhatsApp',
                          args: TypeMessager.whatsapp,
                          context: context,
                          content: ListSupport());
                    }, icon:  Image.asset(whatsapp,width: 35,height: 35,))


                  ],
                ),
              ),

            ],
          ),
        ),
      ),);
  }


}




Widget _getItemsMenu({required UserType userType,
  required TeacherEntity teacher,
required Function onSelectedPage,
required BuildContext context,
required UserEntity user,
  //required int currentIndexItemMenu,
required bool docsAccept}){



  if(userType.isStudent||userType.isUnknown){
    return ValueListenableBuilder<int>(
      valueListenable: currentItemNotifier,
      builder: (context,currentIndexItemMenu,child) {
        return Column(
            children: [
        DrawerItem(
          currentIndexItemMenu: currentIndexItemMenu,
          index: 0,
          title: titlesDrawMenuStudent[0],textColor: Theme.of(context).textTheme.displayMedium!.color!,
          onPressed: () {
            currentItemNotifier.value = 0;
         // onSelectedPage.call(0);
          },),
          DrawerItem(
        currentIndexItemMenu:currentIndexItemMenu,
        index: 1,
        title: titlesDrawMenuStudent[1],
            textColor: Theme.of(context).textTheme.displayMedium!.color!,
            onPressed: () {
              currentItemNotifier.value = 1;

          },),

          DrawerItem(
        currentIndexItemMenu:currentIndexItemMenu,
        index: 2,
        title: titlesDrawMenuStudent[2],textColor: Theme.of(context).textTheme.displayMedium!.color!,
        onPressed: () {

          currentItemNotifier.value = 2;

          },),

              Visibility(
                visible: user.userStatus.isAuth||user.userStatus.isModeration,
                child: badge.Badge(
                  showBadge: !docsAccept,
                  badgeContent: Text('!',style: TStyle.textStyleGaretHeavy(colorWhite,size: 16),),
                  position: BadgePosition.topEnd(end: 20,top: 8),
                  child: DrawerItem(
                    title: titlesDrawMenuStudent[6],textColor: Theme.of(context).textTheme.displayMedium!.color!,
                    onPressed: () {
                      GoRouter.of(context).push(pathDocuments);
                    },),
                ),
              ),

          DrawerItem(
        currentIndexItemMenu:currentIndexItemMenu,
        index: 3,
        title: titlesDrawMenuStudent[3],
            textColor: Theme.of(context).textTheme.displayMedium!.color!, onPressed: () {
          onSelectedPage.call(3);
          },),

          //settings
          DrawerItemSetting(title: titlesDrawMenuStudent[5],user: user),


          DrawerItem(
            index: 4,
            currentIndexItemMenu: currentIndexItemMenu,
            title:titlesDrawMenuStudent[4],
            textColor: Theme.of(context).textTheme.displayMedium!.color!,
            onPressed: () {
              onSelectedPage.call(4);
            },
          ),
          // DrawerItem(
          //   title: titlesDrawMenuStudent[7],
          //   textColor: Theme.of(context).textTheme.displayMedium!.color!,
          //   onPressed: () {
          //     GoRouter.of(context).push(pathTheme);
          //   },
          // ),
          // Visibility(
          //   visible:  user.userStatus.isNotAuth,
          //   child: DrawerItem(
          //     title: user.userStatus.isModeration || user.userStatus.isAuth
          //         ? titlesDrawMenuStudent[8]
          //         : titlesDrawMenuStudent[9],
          //     textColor: Theme.of(context).textTheme.displayMedium!.color!,
          //     onPressed: () {
          //       if (user.userStatus.isNotAuth) {
          //         GoRouter.of(context).push(pathLogIn);
          //       } else {
          //         Dialoger.showLogOut(context: context, user: user);
          //       }
          //     },),
          // ),

           ]
          );
      }
    );
  }else{
    return Column(
        children: [
          DrawerItem(
            //currentIndexItemMenu:currentIndexItemMenu,
            index: 0,
            title: 'Главная'.tr(),textColor: Theme.of(context).textTheme.displayMedium!.color!, onPressed: () {
            onSelectedPage.call(0);
          },),

          DrawerItem(
            //currentIndexItemMenu: currentIndexItemMenu,
            index: 1,
            title: 'Расписание'.tr(),textColor: Theme.of(context).textTheme.displayMedium!.color!, onPressed: () {
            onSelectedPage.call(1);
          },),

          DrawerItem(
            //currentIndexItemMenu:currentIndexItemMenu,
            index: 2,
            title: 'Лиды'.tr(),textColor: Theme.of(context).textTheme.displayMedium!.color!, onPressed: () {
            onSelectedPage.call(2);
          },),

          DrawerItem(
            //currentIndexItemMenu:currentIndexItemMenu,
            index: 3,
            title: 'Клиенты'.tr(),textColor: Theme.of(context).textTheme.displayMedium!.color!, onPressed: () {
            onSelectedPage.call(3);
          },),
          DrawerItem(
            title: 'Тема'.tr(),textColor: Theme.of(context).textTheme.displayMedium!.color!, onPressed: () {
            GoRouter.of(context).push(pathTheme);
          },),

          // DrawerItem(
          //   title: 'Выйти'.tr(),
          //   textColor: colorRed, onPressed: ()  {
          //   Dialoger.showLogOutTeacher(context: context,teacher: teacher);
          //   },),

        ]
    );

  }
}

 class DrawerItemSetting extends StatefulWidget{
  const DrawerItemSetting({super.key,  this.index = -2,required this.user,  this.currentIndexItemMenu = -1, required this.title});


  final int index;
  final String title;
  final int currentIndexItemMenu;
  final UserEntity user;

  @override
  State<DrawerItemSetting> createState() => _DrawerItemSettingState();
}

class _DrawerItemSettingState extends State<DrawerItemSetting> {

  double h = 0;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10,top: 10,bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: (){
          setState(() {
            if(h==0){
              h=widget.user.userStatus.isAuth||widget.user.userStatus.isModeration?140.0:70.0;
            }else{
              h=0;
            }

          });
          //GoRouter.of(context).pop();
          //GoRouter.of(context).push(pathSettings);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:  const EdgeInsets.only(left: 20),
              child: Text(widget.title,style: TStyle.textStyleVelaSansBold( Theme.of(context).textTheme.displayMedium!.color!,
                  size: 18.0)),
            ),
            AnimatedContainer(
              alignment: Alignment.topCenter,
                duration: const Duration(milliseconds: 400),
            height: h,
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(left: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                    visible: widget.user.userStatus.isAuth||widget.user.userStatus.isModeration,
                    child: InkWell(
                      onTap: (){
                        GoRouter.of(context).push(pathProfile);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Gap(10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('Профиль'.tr(),style: TStyle.textStyleVelaSansRegular( Theme.of(context).textTheme.displayMedium!.color!,
                                  size: 16.0)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: widget.user.userStatus.isAuth||widget.user.userStatus.isModeration,
                    child: InkWell(
                      onTap: (){
                        GoRouter.of(context).push(pathSettingNotifi);
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Gap(10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('Уведомления'.tr(),style: TStyle.textStyleVelaSansRegular( Theme.of(context).textTheme.displayMedium!.color!,
                                  size: 16.0)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Gap(10),
                  InkWell(
                    onTap: (){
                      GoRouter.of(context).push(pathTheme);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Тема'.tr(),style: TStyle.textStyleVelaSansRegular( Theme.of(context).textTheme.displayMedium!.color!,
                            size: 16.0)),
                      ],
                    ),
                  ),
                  const Gap(10),
                  InkWell(
                    onTap: (){
                      if (widget.user.userStatus.isNotAuth) {
                        GoRouter.of(context).push(pathLogIn);
                      } else {
                        Dialoger.showLogOut(context: context, user: widget.user);
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text( widget.user.userStatus.isModeration || widget.user.userStatus.isAuth
                    ? titlesDrawMenuStudent[8]
                        : titlesDrawMenuStudent[9],
                            style: TStyle.textStyleVelaSansRegular( Theme.of(context).textTheme.displayMedium!.color!,
                            size: 16.0)),
                      ],
                    ),
                  )
                ],
              ),
            ),)
          ],
        ),
      ),
    );

  }
}






class DrawerItem extends StatelessWidget{

  final String title;
  final Color textColor;
  final VoidCallback onPressed;
  final int index;
  final int currentIndexItemMenu;
  final int countBadge;

  const DrawerItem(
      {super.key,
        this.countBadge=0,
        required this.title,
        this.textColor = const Color.fromRGBO(158, 168, 178, 1),
        required this.onPressed,
         this.index = -2,
         this.currentIndexItemMenu = -1});

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(right: 10,top: 10,bottom: 10),
      child: InkWell(
        onTap: (){
          GoRouter.of(context).pop();
          onPressed();
        },
        child: Row(
           crossAxisAlignment: CrossAxisAlignment.center,
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Visibility(
              visible: index==currentIndexItemMenu,
              child: Container(
                margin: const EdgeInsets.only(left: 20),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                    color: colorOrange,
                    shape: BoxShape.circle
                ),
              ),
            ),
            Padding(
              padding:  EdgeInsets.only(left: index==currentIndexItemMenu?10:20),
              child: Text(title,style: TStyle.textStyleVelaSansBold(textColor,size: 18.0)),
            ),



            // Expanded(
            //   child: Container(
            //     padding: index==currentIndexItemMenu?
            //     const EdgeInsets.symmetric(vertical: 5,horizontal: 20):
            //     const EdgeInsets.only(left: 20),
            //     decoration: BoxDecoration(
            //       color: index==currentIndexItemMenu?colorGrey.withOpacity(0.4)
            //           :Colors.transparent,
            //       borderRadius: const BorderRadius.only(topRight: Radius.circular(10),bottomRight: Radius.circular(10))
            //     ),
            //      child: Text(title,style: TStyle.textStyleVelaSansBold(textColor,size: 18.0))),
            // )

          ],
        ),
      ),
    );
  }




}