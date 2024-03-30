


import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:virtuozy/components/dialogs/dialoger.dart';
import 'package:virtuozy/di/locator.dart';
import 'package:virtuozy/domain/entities/teacher_entity.dart';
import 'package:virtuozy/domain/entities/user_entity.dart';
import 'package:virtuozy/domain/user_cubit.dart';
import 'package:virtuozy/presentations/auth_screen/bloc/auth_bloc.dart';
import 'package:virtuozy/presentations/auth_screen/bloc/auth_event.dart';
import 'package:virtuozy/resourses/colors.dart';
import 'package:virtuozy/resourses/images.dart';
import 'package:virtuozy/router/paths.dart';
import 'package:virtuozy/utils/app_theme.dart';
import 'package:virtuozy/utils/auth_mixin.dart';
import 'package:virtuozy/utils/theme_provider.dart';

import '../utils/preferences_util.dart';
import '../utils/text_style.dart';

class HomeDrawerMenu extends StatefulWidget{
  const HomeDrawerMenu({super.key,required this.onCallLogOut,required this.onSelectedPage});

  final VoidCallback onCallLogOut;
  final Function onSelectedPage;

  @override
  State<HomeDrawerMenu> createState() => _HomeDrawerMenuState();
}

class _HomeDrawerMenuState extends State<HomeDrawerMenu> with AuthMixin{



  @override
  void didChangeDependencies() {
   super.didChangeDependencies();

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
            children: [
              Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 100,top: 50),
                        width: width,
                        height: 100.0,
                        decoration: BoxDecoration(
                            color: colorYellow
                        ),
                        child:  Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Gap(8.0),
                            Visibility(
                              visible: user.phoneNumber.isNotEmpty||
                                  teacher.phoneNum.isNotEmpty,
                              child: Row(
                                children: [
                                  Icon(Icons.phone_enabled_rounded,color: colorWhite,
                                      size: 12.0),
                                  const Gap(5.0),
                                  Text(userType.isStudent?user.phoneNumber:
                                  teacher.phoneNum,
                                      style: TStyle.textStyleVelaSansBold(colorWhite,size: 12.0)),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: user.branchName.isNotEmpty,
                              child: Row(
                                children: [
                                  Icon(Icons.location_on_outlined,color: colorWhite,size: 12.0),
                                  const Gap(5.0),
                                  Text(user.branchName,style: TStyle.textStyleVelaSansMedium(colorWhite,size: 12.0)),
                                ],
                              ),
                            ),

                          ],
                        ),
                      ),
                      Visibility(
                        visible: user.userStatus.isAuth||user.userStatus.isModeration,
                        child: Container(
                          alignment: Alignment.bottomLeft,
                            padding: const EdgeInsets.only(left: 10,top: 20),
                            width: width,
                            //height: 70,
                            color: colorOrange,
                            child: TextButton(
                              onPressed: () {
                                GoRouter.of(context).push(pathProfile);
                              },
                              child: Text('${userType.isStudent?user.firstName:teacher.firstName} ${userType.isStudent?user.lastName:teacher.lastName}',
                                  maxLines: 2,
                                  style: TStyle.textStyleGaretHeavy(colorWhite,size: 16.0)),
                            ),),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: (){
                        GoRouter.of(context).push(pathProfile);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 40,left: 10),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colorOrange
                        ),
                        padding: const EdgeInsets.all(2),
                        child: const CircleAvatar(
                          radius: 40.0,
                          backgroundImage: NetworkImage(
                            // Replace with your image URL or path
                            "https://www.kino-teatr.ru/acter/photo/0/8/57680/931617.jpg",
                          ),
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
                  onSelectedPage:(item){
                    widget.onSelectedPage.call(item);
                  }, teacher: teacher),

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
required UserEntity user}){

  if(userType.isStudent||userType.isUnknown){
    return Column(
        children: [
    DrawerItem(
      title: 'Главная'.tr(),textColor: Theme.of(context).textTheme.displayMedium!.color!, onPressed: () {
      onSelectedPage.call(0);
      },),
  DrawerItem(title: 'Расписание'.tr(),textColor: Theme.of(context).textTheme.displayMedium!.color!, onPressed: () {
  onSelectedPage.call(1);
  },),

  DrawerItem(title: 'Финансы'.tr(),textColor: Theme.of(context).textTheme.displayMedium!.color!,
    onPressed: () {
  onSelectedPage.call(2);
  },),

  DrawerItem(title: 'Предложения'.tr(),textColor: Theme.of(context).textTheme.displayMedium!.color!, onPressed: () {
  onSelectedPage.call(3);
  },),


  // DrawerItem(title: 'Уведомления'.tr(),textColor: Theme.of(context).textTheme.displayMedium!.color!, onPressed: () {
  //   GoRouter.of(context).push(pathNotification);
  // },),

      DrawerItem(
        title: 'Сайт'.tr(),
        textColor: Theme.of(context).textTheme.displayMedium!.color!,
        onPressed: () {
          onSelectedPage.call(4);
        },
      ),
      DrawerItem(
        title: 'Тема'.tr(),
        textColor: Theme.of(context).textTheme.displayMedium!.color!,
        onPressed: () {
          GoRouter.of(context).push(pathTheme);
        },
      ),
      DrawerItem(
        title: user.userStatus.isModeration || user.userStatus.isAuth
            ? 'Выйти'.tr()
            : 'Войти'.tr(),
        textColor: colorRed,
        onPressed: () {
          if (user.userStatus.isNotAuth) {
            GoRouter.of(context).push(pathLogIn);
          } else {
            Dialoger.showLogOut(context: context, user: user);
          }
        },),
  // Column(
  //   children: [
  //     TextButton(onPressed: (){},
  //         child:  Text('Политика конфиденциальности'.tr(),style: TStyle.textStyleVelaSansRegularUnderline(colorGrey))),
  //     TextButton(onPressed: (){},
  //         child:  Text('Пользовательское соглашение'.tr(),style: TStyle.textStyleVelaSansRegularUnderline(colorGrey)))
  //
  //
  //   ],
  // )
   ]
  );
  }else{
    return Column(
        children: [
          DrawerItem(title: 'Главная'.tr(),textColor: Theme.of(context).textTheme.displayMedium!.color!, onPressed: () {
            onSelectedPage.call(0);
          },),

          DrawerItem(title: 'Расписание'.tr(),textColor: Theme.of(context).textTheme.displayMedium!.color!, onPressed: () {
            onSelectedPage.call(1);
          },),

          DrawerItem(title: 'Лиды'.tr(),textColor: Theme.of(context).textTheme.displayMedium!.color!, onPressed: () {
            onSelectedPage.call(2);
          },),

          DrawerItem(title: 'Клиенты'.tr(),textColor: Theme.of(context).textTheme.displayMedium!.color!, onPressed: () {
            onSelectedPage.call(3);
          },),
          DrawerItem(title: 'Тема'.tr(),textColor: Theme.of(context).textTheme.displayMedium!.color!, onPressed: () {
            GoRouter.of(context).push(pathTheme);
          },),

          DrawerItem(title: 'Выйти'.tr(),
            textColor: colorRed, onPressed: ()  {
            Dialoger.showLogOutTeacher(context: context,teacher: teacher);
            },),

        ]
    );

  }
}






class DrawerItem extends StatelessWidget{

  final String title;
  final Color textColor;
  final VoidCallback onPressed;

  final int countBadge;

  const DrawerItem(
      {super.key,
        this.countBadge=0,
        required this.title,
        this.textColor = const Color.fromRGBO(158, 168, 178, 1),
        required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: InkWell(
        onTap: (){
          GoRouter.of(context).pop();
          onPressed();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.
          spaceBetween,
          children: [
            Expanded(child: Text(title,style: TStyle.textStyleVelaSansBold(textColor,size: 18.0)))

          ],
        ),
      ),
    );
  }




}