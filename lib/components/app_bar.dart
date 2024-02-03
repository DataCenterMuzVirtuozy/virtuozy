

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
      iconTheme: IconThemeData(
        color: Theme.of(context).iconTheme.color
      ),
    backgroundColor: Theme.of(context).colorScheme.background,
    title: Text(title,style: TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!,size: 18.0)),
);
  }

  @override
  final Size  preferredSize;

}