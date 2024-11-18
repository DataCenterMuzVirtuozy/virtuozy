import 'package:easy_localization/easy_localization.dart';

class ParserPrice {
  static String getBalance(double quantity) {
    if (quantity == 0.0) {
      return '0.00';
    }
    var f = NumberFormat("###.0#", "en_US");
   return f.format(quantity);
    final i = quantity.toString().split('.')[0];
    final i1 = quantity.toString().split('.')[1];
    final i2 = int.parse(i1);
    if(i2>0){
      return quantity.toString();
    }else{
      return i;
    }

  }
}
