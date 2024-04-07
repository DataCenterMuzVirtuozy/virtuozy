
import 'package:flutter/material.dart';
import 'package:virtuozy/resourses/colors.dart';
import 'package:virtuozy/utils/text_style.dart';

class AppTheme{


  static  ThemeData get first=> ThemeData(
    useMaterial3: true,
    datePickerTheme: DatePickerThemeData(
      backgroundColor: colorWhite,
      shadowColor: colorBlack,
      surfaceTintColor: colorBlack,
      headerForegroundColor: colorBlack,
      dayForegroundColor: MaterialStatePropertyAll(colorBlack),
      weekdayStyle: TStyle.textStyleVelaSansExtraBolt(colorBlack),
      dayStyle: TStyle.textStyleVelaSansBold(colorBlack),
      yearForegroundColor: MaterialStatePropertyAll(colorBlack),
      yearStyle: TStyle.textStyleVelaSansExtraBolt(colorBlack),
      todayForegroundColor: MaterialStatePropertyAll(colorBlack),


    ),
    switchTheme: SwitchThemeData(
       trackColor: MaterialStatePropertyAll(colorBeruzaLight),
       thumbColor: MaterialStatePropertyAll(colorBeruza)
    ),
    iconTheme: IconThemeData(color:colorBlack),
    textTheme: TextTheme(
        displayMedium: TextStyle(color: colorBlack,
        ),
      displayLarge: TextStyle(color: colorBlack,
      ),
      // ···
      titleLarge: TextStyle(color: colorBlack,
      ),
      displaySmall:TextStyle(color: colorBlack,
      ),



    ),
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
      onSurface: colorBlack,


    ),
  );


  static  ThemeData get dark=> ThemeData(
    useMaterial3: true,
    datePickerTheme: DatePickerThemeData(
      backgroundColor: colorBlack,
      shadowColor: colorWhite,
      surfaceTintColor: colorWhite,
      headerForegroundColor: colorWhite,
      dayForegroundColor: MaterialStatePropertyAll(colorWhite),
      weekdayStyle: TStyle.textStyleVelaSansExtraBolt(colorWhite),
      dayStyle: TStyle.textStyleVelaSansBold(colorWhite),
      yearForegroundColor: MaterialStatePropertyAll(colorWhite),
      yearStyle: TStyle.textStyleVelaSansExtraBolt(colorWhite),
      todayForegroundColor: MaterialStatePropertyAll(colorWhite),

    ),
    switchTheme: SwitchThemeData(
        trackColor: MaterialStatePropertyAll(colorGrey),
        thumbColor: MaterialStatePropertyAll(colorWhite)
    ),
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
      onSurface: colorWhite,

    ),
  );



  static ThemeData custom(color) => ThemeData(
    useMaterial3: true,
    colorSchemeSeed: color

  );


}