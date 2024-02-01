


import 'package:shared_preferences/shared_preferences.dart';

class PreferencesUtil{

  static SharedPreferences? _prefsInstance;

  static Future<SharedPreferences?> init() async {
    _prefsInstance = await SharedPreferences.getInstance();
    return _prefsInstance;
  }


  static Future<void> setTheme({required bool themeFirst}) async{
    await _prefsInstance!.setBool(_keyTheme, themeFirst);
  }

  static bool get getTheme=>_prefsInstance!.getBool(_keyTheme)??true;





}



String get _keyTheme =>'key_theme';