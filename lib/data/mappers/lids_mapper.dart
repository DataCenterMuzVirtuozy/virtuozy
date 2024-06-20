

 import 'package:virtuozy/data/models/lids_model.dart';
import 'package:virtuozy/domain/entities/lids_entity.dart';
import 'package:virtuozy/utils/status_to_color.dart';

class LidsMapper{


   static LidsEntity fromApi({required LidsModel model}){
     return LidsEntity(name: model.name,
         dateCreated: model.dateCreated,
         nameDir: model.nameDir,
         dateTrial: model.dateTrial,
         dateLastLesson: model.dateLastLesson,
         lessonLastStatus: StatusToColor.lessonStatusFromApi(model.lessonLastStatus),
         idSchool: model.idSchool);
   }


 }