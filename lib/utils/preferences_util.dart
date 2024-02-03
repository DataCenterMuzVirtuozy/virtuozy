


import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virtuozy/utils/theme_provider.dart';

class PreferencesUtil{

  static SharedPreferences? _prefsInstance;

  static Future<SharedPreferences?> init() async {
    _prefsInstance = await SharedPreferences.getInstance();
    return _prefsInstance;
  }


  static Future<void> setColorScheme({required Color color}) async{
    String red = color.red.toString();
    String green = color.green.toString();
    String blue = color.blue.toString();
    String opacity = color.opacity.toString();

    await _prefsInstance!.setStringList(_keyColor, [red,green,blue,opacity]);
  }

  static Color get getColorScheme{
    final result = _prefsInstance!.getStringList(_keyColor)??['228', '96', '54','1.0'];
    int r = int.parse(result[0]);
    int g = int.parse(result[1]);
    int b = int.parse(result[2]);
    double opacity = double.parse(result[3]);
    return Color.fromRGBO(r, g, b, opacity);
  }


  static Future<void> setTheme({required ThemeStatus themeStatus}) async{
    int theme = 0;
    switch(themeStatus){
      case ThemeStatus.color:theme = 2;
      case ThemeStatus.dark: theme = 1;
      case ThemeStatus.first:theme = 0;

    }
    await _prefsInstance!.setInt(_keyTheme, theme);
  }

  static ThemeStatus get getTheme{
    final result = _prefsInstance!.getInt(_keyTheme)??0;

    switch(result){
      case 0: return ThemeStatus.first;
      case 1: return ThemeStatus.dark;
      case 2: return ThemeStatus.color;
    }

    return ThemeStatus.first;
  }





}



String get _keyTheme =>'key_theme';
String get _keyColor =>'key_color';