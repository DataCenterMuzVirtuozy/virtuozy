
 import 'package:easy_localization/easy_localization.dart';

import '../domain/entities/user_entity.dart';

class CreatorListDirections{


 static String _parseNAmeTeacher(String fullName){
    return fullName.split(' ')[0];
  }

  static List<String> getTitlesDrawingMenu({required List<DirectionLesson> directions}){
     List<String> resultList = [];
     List<Map<String,String>> dataNameDirList =[];
     List<String> namesDirCopy = [];
     String nameCopy = '';
     //directions.sort((a,b)=>b.lastSubscription.balanceSub.compareTo(a.lastSubscription.balanceSub));
     dataNameDirList = directions.map((e) =>{'nameDir': e.name,'nameTeacher':e.nameTeacher}).toList();
     for(var n in dataNameDirList){
       if(namesDirCopy.contains(n['nameDir'])){
         nameCopy = n['nameDir']!;
       }else{
         namesDirCopy.add(n['nameDir']!);
       }

     }
     for(var n in dataNameDirList){
       if(n['nameDir'] == nameCopy){
         resultList.add('$nameCopy (${_parseNAmeTeacher(n['nameTeacher']!)})');
       }else{
         resultList.add('${n['nameDir']}');
       }
     }
     int length = resultList.length;
     if(length>1){
       resultList.insert(length, 'Все направления'.tr());
     }
     return resultList;
   }

 }