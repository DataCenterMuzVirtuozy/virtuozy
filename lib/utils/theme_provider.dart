


import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:virtuozy/utils/preferences_util.dart';


class ThemeProvider with ChangeNotifier{

  bool _themeFirst=true;
  Color? _color;

  bool get themeFirst => _themeFirst;
  Color get color =>_color!;


  setTheme({required bool themeFirst,Color? color}) async {
    _themeFirst=themeFirst;
    _color = color;
    await PreferencesUtil.setTheme(themeFirst: themeFirst);
    notifyListeners();

  }




}