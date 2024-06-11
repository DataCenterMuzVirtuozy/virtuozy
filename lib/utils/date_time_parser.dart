


 import 'dart:math';

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


    static parseDateFromView(String date){
      return DateFormat('dd.MM.yyyy').parse(date).toString().split(' ')[0];
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


    static String getDayByNumber(int numDay){
      return switch(numDay){
        1 => 'Пн',
        2 => 'Вт',
        3 => 'Ср',
        4 => 'Чт',
        5 => 'Пт',
        6 => 'Сб',
        7 => 'Вс',
        int() => throw UnimplementedError(),
      };

    }

    //временный метод для генерации
    static String date(){
      int randomNumber = Random().nextInt(3);
      final date = DateTime(DateTime.now().day+randomNumber);
      return date.toString().split(' ')[0];
    }


    //временный метод для генерации
    static String time(){
      int randomNumber = Random().nextInt(12);
      final times = [
        '10:00-11:00',
        '11:00-12:00',
        '12:00-13:00',
        '13:00-14:00',
        '14:00-15:00',
        '15:00-16:00',
        '16:00-17:00',
        '17:00-18:00',
        '18:00-19:00',
        '19:00-20:00',
        '20:00-21:00',
        '21:00-22:00',
      ];

      return times[randomNumber];
    }





 }