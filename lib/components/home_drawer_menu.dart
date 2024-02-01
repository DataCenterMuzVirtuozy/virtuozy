


import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:virtuozy/di/locator.dart';
import 'package:virtuozy/resourses/colors.dart';
import 'package:virtuozy/resourses/images.dart';
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

class _HomeDrawerMenuState extends State<HomeDrawerMenu> {

  final themeProvider = locator.get<ThemeProvider>();
  bool themeFirst = true;


  @override
  void initState() {
    themeFirst=PreferencesUtil.getTheme;

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
            color: colorWhite,
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
                    alignment: Alignment.bottomCenter,
                    children: [
                      Container(
                        width: width,
                        height: 120.0,
                        decoration: BoxDecoration(
                            color: colorYellow
                        ),
                        //child: Image.asset(illustration_2,fit: BoxFit.cover),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
                        width: width,
                          color: colorOrange,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Иван Иванович Иванов',style: TStyle.textStyleGaretHeavy(colorWhite,size: 20.0)),
                              Text('+7 (999) 999-99-99',style: TStyle.textStyleVelaSansBold(colorWhite,size: 16.0)),
                            ],
                          )),
                    ],
                  ),
                  const Gap(20.0),
                  DrawerItem(title: 'Мои абонементы'.tr(),textColor: colorBlack, onPressed: () {
                    widget.onSelectedPage.call(0);
                  },),

                  DrawerItem(title: 'Расписание'.tr(),textColor: colorBlack, onPressed: () {
                     widget.onSelectedPage.call(1);
                  },),

                  DrawerItem(title: 'Финансы'.tr(),textColor: colorBlack, onPressed: () {
                    widget.onSelectedPage.call(2);
                  },),

                  DrawerItem(title: 'Предложения'.tr(),textColor: colorBlack, onPressed: () {
                    widget.onSelectedPage.call(3);
                  },),
                  DrawerItem(title: 'Тема'.tr(),textColor: colorBlack, onPressed: () {
                    //todo testing

                  },),

                  Row(
                    children: [
                      InkWell(
                        onTap: (){
                          themeProvider.setTheme(themeFirst: false,color: colorGreen);
                        },
                        child: Container(
                          margin: const EdgeInsets.all(10.0),
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colorGreen
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          themeProvider.setTheme(themeFirst: false,color: colorRed);
                        },
                        child: Container(
                          margin: const EdgeInsets.all(10.0),
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colorRed
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          themeProvider.setTheme(themeFirst: false,color: colorYellow);
                        },
                        child: Container(
                          margin: const EdgeInsets.all(10.0),
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colorYellow
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          themeProvider.setTheme(themeFirst: false,color: colorOrange);
                        },
                        child: Container(
                          margin: const EdgeInsets.all(10.0),
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colorOrange
                          ),
                        ),
                      )
                    ],
                  ),

                  DrawerItem(title: 'Сайт'.tr(),textColor: colorBlack, onPressed: () {
                    widget.onSelectedPage.call(4);
                  },),

                  DrawerItem(title: 'Выйти'.tr(),textColor: colorRed, onPressed: () {

                  },),
                ],
              ),

              Column(
                children: [
                  TextButton(onPressed: (){},
                      child:  Text('Политика конфиденциальности'.tr(),style: TStyle.textStyleVelaSansRegularUnderline(colorGrey))),
                  TextButton(onPressed: (){},
                      child:  Text('Пользовательское соглашение'.tr(),style: TStyle.textStyleVelaSansRegularUnderline(colorGrey)))


                ],
              )


            ],
          ),
        ),
      ),);
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
      child: GestureDetector(
        onTap: (){
          GoRouter.of(context).pop();
          onPressed();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.
          spaceBetween,
          children: [
            Text(title,style: TStyle.textStyleVelaSansBold(textColor,size: 18.0))

          ],
        ),
      ),
    );
  }




}