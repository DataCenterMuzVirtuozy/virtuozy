



import 'package:flutter/material.dart';

class TStyle{

  // static textStyleRegularUnderline(Color color,
    //     {double size = 12.0, FontWeight fontWeight = FontWeight.w500}){
    //
    //   return TextStyle(
    //       decoration: TextDecoration.underline,
    //       decorationStyle: TextDecorationStyle.dashed,
    //       decorationColor: textColor2,
    //       fontWeight: fontWeight,
    //       fontSize: size,
    //       fontFamily: fontDisketRegular,
    //       color: color
    //   );
    // }
  static textStyleVelaSansRegular(Color color,
      {double size = 12.0, FontWeight fontWeight = FontWeight.w500}) {
    return TextStyle(
        fontWeight: fontWeight,
        fontSize: size,
        fontFamily: fontVelaSansRegular,
        color: color
    );
  }

  static textStyleVelaSansMedium(Color color,
      {double size = 12.0, FontWeight fontWeight = FontWeight.w500}) {
    return TextStyle(
        fontWeight: fontWeight,
        fontSize: size,
        fontFamily: fontVelaSansMedium,
        color: color
    );
  }

    static textStyleVelaSansBold(Color color,
        {double size = 12.0, FontWeight fontWeight = FontWeight.w500}){

      return TextStyle(
          fontWeight: fontWeight,
          fontSize: size,
          fontFamily: fontVelaSansBold,
          color: color
      );
    }

  static textStyleVelaSansExtraBolt(Color color,
      {double size = 12.0, FontWeight fontWeight = FontWeight.w500}) {
    return TextStyle(
        fontWeight: fontWeight,
        fontSize: size,
        fontFamily: fontVelaSansExtraBolt,
        color: color
    );
  }

  static textStyleOpenSansRegular(Color color,
      {double size = 12.0, FontWeight fontWeight = FontWeight.w500}) {
    return TextStyle(
        fontWeight: fontWeight,
        fontSize: size,
        fontFamily: fontOpenSansRegular,
        color: color
    );
  }

  static textStyleOpenSansLight(Color color,
      {double size = 12.0, FontWeight fontWeight = FontWeight.w500}) {
    return TextStyle(
        fontWeight: fontWeight,
        fontSize: size,
        fontFamily: fontOpenSansLight,
        color: color
    );
  }

  static textStyleGaretHeavy(Color color,
      {double size = 12.0, FontWeight fontWeight = FontWeight.w500}) {
    return TextStyle(
        fontWeight: fontWeight,
        fontSize: size,
        fontFamily: fontGaretHeavy,
        color: color
    );
  }


  static textStyleVelaSansRegularUnderline(Color color,
      {double size = 12.0, FontWeight fontWeight = FontWeight.w500}){
    return TextStyle(
        decoration: TextDecoration.underline,
        fontWeight: fontWeight,
        fontSize: size,
        fontFamily: fontOpenSansRegular,
        color: color
    );

  }
    static String get fontVelaSansBold=>'VelaSansBold';
    static String get fontVelaSansRegular=>'VelaSansRegular';
    static String get fontVelaSansMedium=>'VelaSansMedium';
    static String get fontVelaSansExtraBolt=>'VelaSansExtraBolt';
    static String get fontOpenSansRegular=>'OpenSansRegular';
    static String get fontOpenSansLight=>'OpenSansLight';
    static String get fontGaretHeavy=>'GaretHeavy';





  }