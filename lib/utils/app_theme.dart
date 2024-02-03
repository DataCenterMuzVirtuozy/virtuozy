
import 'package:flutter/material.dart';
import 'package:virtuozy/resourses/colors.dart';

class AppTheme{


  static  ThemeData get first=> ThemeData(
    useMaterial3: true,
    iconTheme: IconThemeData(color:colorBlack),
    textTheme: TextTheme(displayMedium: TextStyle(color: colorBlack)),
    colorScheme: ColorScheme(
      tertiary: colorGreen,  // фон кнопки в параметрах
      surfaceVariant: colorBeruzaLight, // фон карточек
      secondary: colorOrange, // фон кнопок
      primary: colorOrange,
      brightness: Brightness.light,
      onPrimary: colorOrange,
      onSecondary: colorBeruza,
      error: colorRed,
      onError: colorRed,
      background: colorWhite, // фон экранов
      onBackground: colorWhite,
      surface: colorBlack,
      onSurface: colorBeruzaLight,

    ),
  );


  static  ThemeData get dark=> ThemeData(
    useMaterial3: true,
    textTheme: TextTheme(displayMedium: TextStyle(color: colorWhite)),
    iconTheme: IconThemeData(color:colorWhite),
    colorScheme: ColorScheme(
      tertiary: colorGreen,
      surfaceVariant: const Color(0xFF202122),
      secondary: colorOrange,
      primary: colorOrange,
      brightness: Brightness.light,
      onPrimary: colorOrange,
      onSecondary: colorBeruza,
      error: colorRed,
      onError: colorRed,
      background: const Color(0xFF181819),
      onBackground: colorBlack,
      surface: colorWhite,
      onSurface: colorBeruzaLight,

    ),
  );



  static ThemeData custom(color) => ThemeData(
    useMaterial3: true,
    colorSchemeSeed: color

  );


}