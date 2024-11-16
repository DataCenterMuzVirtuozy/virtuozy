
 import 'package:virtuozy/utils/preferences_util.dart';

import '../data/rest/endpoints.dart';
import '../resourses/strings.dart';

class ContactSchoolByLocation{

   static getIdLocation(){
   final id =  PreferencesUtil.urlSchool.contains('msk')?'msk':'nsk';
    return id;

   }

   static getPhoneNUmber(){
     final id = PreferencesUtil.urlSchool;
     if(id.isEmpty){
       return '';
     }
     final phone =  id.contains('msk')?numMsk:numNsk;
     return phone;
   }

   static getPhoneNumberByIdLocation(String idLoc){
     if(idLoc.isEmpty){
       return '';
     }
     final phone =  idLoc=='msk'?numMsk:numNsk;
     return phone;
   }

   static getUrlWebsite(){
     final id =  PreferencesUtil.urlSchool.contains('msk')?Endpoints.urlMSK:Endpoints.urlNSK;
     return id;
   }



 }