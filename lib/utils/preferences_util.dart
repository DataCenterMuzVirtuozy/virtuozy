


import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virtuozy/utils/theme_provider.dart';

class PreferencesUtil{

  static SharedPreferences? _prefsInstance;

  static Future<SharedPreferences?> init() async {
    _prefsInstance = await SharedPreferences.getInstance();
    return _prefsInstance;
  }

  static Future<void> setUID({required String uid}) async {
    await _prefsInstance!.setString(_keyUID, uid);
  }

  // 0 - not auth 1 - auth 2 - moderation
  static Future<void> setStatusUser({required int status}) async{
    await _prefsInstance!.setInt(_keyStatus, status);
  }

  static Future<void> setLastNameUser({required String lastName}) async{
    await _prefsInstance!.setString(_keyLastName, lastName);
  }

  static Future<void> setFirstNameUser({required String firstName}) async{
    await _prefsInstance!.setString(_keyFirstName, firstName);
  }
  static Future<void> setPhoneUser({required String phone}) async{
    await _prefsInstance!.setString(_keyPhoneNumber, phone);
  }

  static Future<void> setBranchUser({required String branch}) async{
    await _prefsInstance!.setString(_keyBranch, branch);
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


  static int get statusUser => _prefsInstance!.getInt(_keyStatus)??0;
  static String get lastNameUser => _prefsInstance!.getString(_keyLastName)??'';
  static String get firstNameUser => _prefsInstance!.getString(_keyFirstName)??'';
  static String get phoneUser => _prefsInstance!.getString(_keyPhoneNumber)??'';
  static String get branchUser => _prefsInstance!.getString(_keyBranch)??'';
  static String get uid => _prefsInstance!.getString(_keyUID)??'';

  static ThemeStatus get getTheme{
    //final result = _prefsInstance!.getInt(_keyTheme)??0;
    const result = 0;
    switch(result){
      case 0: return ThemeStatus.first;
      case 1: return ThemeStatus.dark;
      case 2: return ThemeStatus.color;
    }

    return ThemeStatus.first;
  }


  static clear() async {
    _prefsInstance!.clear();
  }





}



String get _keyTheme =>'key_theme';
String get _keyColor =>'key_color';
String get _keyLastName => '_key_last_name';
String get _keyFirstName =>'key_first_name';
String get _keyPhoneNumber => 'ky_phone';
String get _keyBranch => 'key_branch';
String get _keyStatus => 'key_status';
String get _keyUID => 'key_uid';