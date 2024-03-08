


 class ParserPrice{

 static String getBalance(double balanceDirection) {
  if (balanceDirection == 0.0) {
   return '0.00';
  }

  final ths = (balanceDirection/1000).toString();
  final i1 = int.parse(ths.split('.')[0]);
  final i2 = i1*1000;
  final i3 = double.parse((balanceDirection - i2).toStringAsFixed(2));
  if(i3 == 0.0){
   return '$i1 000';
  }else{
    final i4 = int.parse(i3.toString().split('.')[1]);
    final i5 = int.parse(i3.toString().split('.')[0]);
    if(i4>0){
     return '$i1 $i5.$i4';
    }else{
     return '$i1 $i5';
    }
  }

 }
 }