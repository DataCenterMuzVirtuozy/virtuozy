
import 'package:flutter/material.dart';
import 'package:virtuozy/resourses/colors.dart';

class AppTheme{


  static  ThemeData get light=> ThemeData(
    useMaterial3: true,
    //textSelectionTheme: TextSelectionThemeData(cursorColor: colorItem),
    colorScheme: ColorScheme.fromSeed(seedColor: colorPink),
  );





}