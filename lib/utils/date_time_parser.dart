


 import 'package:easy_localization/easy_localization.dart';

class DateTimeParser{


    static getDateTime({required DateTime dateNow}){
      return '${DateFormat.yMd().format(dateNow)} ${DateFormat.Hm().format(dateNow)}';
    }

    static getDate({required DateTime dateNow}){
      return DateFormat('yyyy-MM-dd').format(dateNow);
    }



 }