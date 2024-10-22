class ParserPrice {
  static String getBalance(double quantity) {
    if (quantity == 0.0) {
      return '0.00';
    }
    final i = quantity.toString().split('.')[0];
    final i1 = quantity.toString().split('.')[1];
    final i2 = int.parse(i1);
    if(i2>0){
      return quantity.toString();
    }else{
      return i;
    }


    if (quantity >= 1000) {
      final ths = (quantity / 1000).toString();
      final i1 = int.parse(ths.split('.')[0]);
      final i2 = i1 * 1000;
      final i3 = double.parse((quantity - i2).toStringAsFixed(2));
      if (i3 == 0.0) {
        return '$i1 000';
      } else {
        final i4 = int.parse(i3.toString().split('.')[1]);
        final i5 = int.parse(i3.toString().split('.')[0]);
        if (i4 > 0) {
          return '$i1$i5.$i4';
        } else {
          return '$i1$i5';
        }
      }
    } else {
      return quantity.toString();
    }

  }
}
