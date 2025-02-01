import 'package:easy_localization/easy_localization.dart';

class ParserPrice {
  static String getBalance(double quantity) {
    final intQuantity = quantity.toInt();
    if (intQuantity == 0) {
      return '0';
    }

    var f = NumberFormat.decimalPattern("en_US").format(intQuantity);
   return f.replaceFirst(',', ' ');


  }
}
