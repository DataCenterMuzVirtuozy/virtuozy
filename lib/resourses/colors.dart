



import 'package:flutter/material.dart';
import 'package:virtuozy/utils/preferences_util.dart';



   Color get colorPink => const Color.fromRGBO(239, 229, 225, 1.0);
   Color get colorRed => Colors.red;
   Color get colorBlack => Colors.black;
   Color get colorWhite => Colors.white;
   Color get colorOrange => const Color.fromRGBO(228, 96, 54, 1.0);
   Color get colorGrey => const Color.fromRGBO(134, 152, 149, 1.0);
Color get colorGreyLight => const Color.fromRGBO(134, 152, 149, 0.5);
   Color  get colorBeruza => const Color.fromRGBO(31, 162, 184, 1.0);
Color  get colorBeruza2 => const Color.fromRGBO(230, 255, 255, 1.0);
   Color  get colorBeruzaLight => const Color.fromRGBO(31, 162, 184, 0.1);
   Color get colorYellow => const Color.fromRGBO(247, 196, 94, 1.0);
   Color get colorGreen => PreferencesUtil.branchUser == 'msk'?const Color.fromRGBO(0, 148, 77, 1.0):colorGreenNsk;
   Color get colorGreenLight => const Color.fromRGBO(94, 174, 82, 1.0);
   Color get secondaryContainer =>  const Color(0xFF161516);
   Color get colorGreenNsk => const Color.fromRGBO(175, 202, 11, 1.0);
   Color textColorBlack(BuildContext context) => Theme.of(context).textTheme.displayMedium!.color!;
   Color backgroundCard(BuildContext context) => Theme.of(context).colorScheme.surfaceVariant;


