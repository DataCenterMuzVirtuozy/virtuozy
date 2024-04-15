


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

    static getStringDateFromApi({required String date}){
      if(date.isEmpty){
        return '';
      }
      final dt =  DateFormat('yyyy-MM-dd').parse(date);
      int m = dt.month;
      switch(m){
        case 1: return 'Январь ${dt.year}';
        case 2: return 'Февраль ${dt.year}';
        case 3: return 'Март ${dt.year}';
        case 4: return 'Апрель ${dt.year}';
        case 5: return 'Май ${dt.year}';
        case 6: return 'Июнь ${dt.year}';
        case 7: return 'Июль ${dt.year}';
        case 8: return 'Август ${dt.year}';
        case 9: return 'Сентябрь ${dt.year}';
        case 10: return 'Октябрь ${dt.year}';
        case 11: return 'Ноябрь ${dt.year}';
        case 12: return 'Декабрь ${dt.year}';
        default: '';
      }

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

    static getTimeMillisecondEpochByDate({required String date}){
      if(date.isEmpty||date.isEmpty){
        return 0;
      }
      final dt =  DateFormat('yyyy-MM-dd').parse(date);
      return dt.millisecondsSinceEpoch;
    }

    static getDateAndTime({required String dateTime}){
      try{
        if(dateTime.isEmpty){
          return '';
        }
        final dt =  DateFormat('yyyy-MM-dd HH:mm').parse(dateTime);
        return '${DateFormat.yMd().format(dt)}/${DateFormat.Hm().format(dt)}';
      }catch (e){
        return '';
      }

    }

    static String getDateForCompare({required String date}){

      final dt =  DateFormat('yyyy-MM-dd').parse(date);
      final m = dt.month;
      switch(m){
        case 1: return 'Январь ${dt.year}';
        case 2: return 'Февраль ${dt.year}';
        case 3: return 'Март ${dt.year}';
        case 4: return 'Апрель ${dt.year}';
        case 5: return 'Май ${dt.year}';
        case 6: return 'Июнь ${dt.year}';
        case 7: return 'Июль ${dt.year}';
        case 8: return 'Август ${dt.year}';
        case 9: return 'Сентябрь ${dt.year}';
        case 10: return 'Октябрь ${dt.year}';
        case 11: return 'Ноябрь ${dt.year}';
        case 12: return 'Декабрь ${dt.year}';
        default: return '';
      }
    }





 }