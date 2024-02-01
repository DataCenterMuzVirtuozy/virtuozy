

 import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../resourses/colors.dart';
import '../utils/text_style.dart';

class AppBarCustom extends StatelessWidget implements PreferredSizeWidget{

  final String title;

  const AppBarCustom({super.key, required this.title}): preferredSize = const Size.fromHeight(60.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
    backgroundColor: colorWhite,
    title: Text(title,style: TStyle.textStyleVelaSansBold(colorBlack,size: 18.0)),
);
  }

  @override
  final Size  preferredSize;

}