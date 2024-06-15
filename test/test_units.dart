



  import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){
  List<List<int>> listY = [];
  List<List<int>> listX = [];
  final y = [10,11,12,13,14,15,16,17,18,19,20,21];


    test('Test',(){
    const c = 7;
    const f =12;
    final x = List.generate(c, (index) => index);
    for (var i = 0; i < f; i++) {
      listY.add(List<int>.generate(c, (index) {
        return (c * (i + 1)) - (c - index);
      }));
    }
    for (var i = 0; i < c; i++) {
      listX.add(List<int>.generate(f, (index) {
        return (c*index);
      }));
    }
    print('X ${listX[0]}');

    //y
    for (var r = 0; r < 84; r++) {
      for (var h in listY) {
        if (h.contains(r)) {
          //print('Y ${r} ${y[listY.indexOf(h)]}');
        }
      }
    }


    //x
    for (var r = 0; r < 84; r++) {
      for (var h in listX) {
        if (h.contains(r)) {
          print('X ${r} ${x[listX.indexOf(h)]}');
        }
      }
    }

    });


  }