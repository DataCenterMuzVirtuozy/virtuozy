import 'package:easy_localization/easy_localization.dart';

class ParserPrice {
  static String getBalance(double quantity) {
    if (quantity == 0.0) {
      return '0';
    }

    var f = NumberFormat.decimalPattern("en_US").format(quantity);
   return f.replaceFirst(',', ' ');


  }
}
