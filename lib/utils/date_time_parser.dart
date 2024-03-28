


 import 'package:easy_localization/easy_localization.dart';

class DateTimeParser{


    static getDateTime({required DateTime dateNow}){
      return '${DateFormat.yMd().format(dateNow)} ${DateFormat.Hm().format(dateNow)}';
    }

    static getDate({required DateTime dateNow}){
      return DateFormat.yMd().format(dateNow);
    }


    static getDateFromApi({required String date}){
      if(date.isEmpty){
        return '';
      }
      final dt =  DateFormat('yyyy-MM-dd').parse(date);
      return DateFormat.yMd().format(dt);
    }
    static getDateToApi({required DateTime dateNow}){
      return DateFormat('yyyy-MM-dd').format(dateNow);
    }

    static getTime({required DateTime dateNow}){
      return DateFormat.Hm().format(dateNow);
    }

    static getTimeMillisecondEpoch({required String time,required String date}){
      if(time.isEmpty||date.isEmpty){
        return '';
      }
      final dateTime = '$date $time';
      final dt =  DateFormat('yyyy-MM-dd HH:mm').parse(dateTime);
      return dt.millisecondsSinceEpoch;
    }

    static getDateAndTime({required String dateTime}){
      if(dateTime.isEmpty){
        return '';
      }
      final dt =  DateFormat('yyyy-MM-dd HH:mm').parse(dateTime);
      return '${DateFormat.yMd().format(dt)}/${DateFormat.Hm().format(dt)}';
    }





 }