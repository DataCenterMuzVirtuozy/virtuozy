
import 'package:flutter/material.dart';
import 'package:virtuozy/resourses/colors.dart';

class AppTheme{


  static  ThemeData get first=> ThemeData(
    useMaterial3: true,
    iconTheme: IconThemeData(color:colorBlack),
    colorScheme: ColorScheme(
      tertiary: colorGreen,
      surfaceVariant: colorBeruzaLight,
      secondary: colorOrange,
      primary: colorOrange,
      brightness: Brightness.light,
      onPrimary: colorOrange,
      onSecondary: colorBeruza,
      error: colorRed,
      onError: colorRed,
      background: colorWhite,
      onBackground: colorWhite,
      surface: colorGreen,
      onSurface: colorBeruzaLight,

    ),
  );


  static ThemeData custom(color) => ThemeData(
    useMaterial3: true,
    colorSchemeSeed: color

  );


}