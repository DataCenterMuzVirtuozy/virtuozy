



  import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){

    test('Test',(){



     const d = '2024-05-20/2024-05-30';
     final fDay =  DateFormat('yyyy-MM-dd').parse(d.split('/')[0]);
     final lDay = DateFormat('yyyy-MM-dd').parse(d.split('/')[1]);

      print('${lDay} ${fDay}');
    });


  }