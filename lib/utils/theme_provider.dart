


import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:virtuozy/utils/preferences_util.dart';



enum ThemeStatus{
   dark,
   color,
   first

}

class ThemeProvider with ChangeNotifier{

  ThemeStatus _themeStatus= ThemeStatus.first;  // 0 - default, 1 - dark, 2 - color
  Color? _color;

  ThemeStatus get themeStatus => _themeStatus;
  Color get color =>_color!;


  setTheme({required ThemeStatus themeStatus,Color? color}) async {
    _themeStatus=themeStatus;
    _color = color;
    await PreferencesUtil.setTheme(themeStatus: themeStatus);
    notifyListeners();

  }




}