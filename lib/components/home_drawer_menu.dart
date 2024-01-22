


import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:virtuozy/resourses/colors.dart';
import 'package:virtuozy/resourses/images.dart';

import '../utils/text_style.dart';

class HomeDrawerMenu extends StatelessWidget{
  const HomeDrawerMenu({super.key,required this.onCallLogOut});

  final VoidCallback onCallLogOut;


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
        color: colorWhite,
        width: width/1.2,
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
                        height: 180.0,
                        decoration: BoxDecoration(
                            color: colorYellow
                        ),
                        child: Image.asset(illustration_2,fit: BoxFit.cover),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
                        width: width,
                          color: colorOrange,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Иван Иванивич Иванов',style: TStyle.textStyleGaretHeavy(colorWhite,size: 20.0)),
                              Text('+7 (999) 999-99-99',style: TStyle.textStyleVelaSansBold(colorWhite,size: 16.0)),
                            ],
                          )),
                    ],
                  ),
                  DrawerItem(title: 'Выйти'.tr(),textColor: Colors.red, onPressed: () {

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