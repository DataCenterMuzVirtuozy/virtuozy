

  import 'package:virtuozy/utils/status_to_color.dart';

import '../../domain/entities/client_entity.dart';
import '../models/client_model.dart';

class ClientsMapper{


    static ClientEntity fromApi({required ClientModel model}){
      return ClientEntity(name: model.name,
          idStudent: model.idStudent,
          dateLestLesson: model.dateLestLesson,
          statusLastLesson: StatusToColor.lessonStatusFromApi(model.statusLastLesson),
          phoneNum: model.phoneNum,
          countAllLesson: model.countAllLesson,
          countBalanceLesson: model.countBalanceLesson,
          dateNearLesson: model.dateNearLesson,
          actionSub: model.actionSub,
          dateCreate: model.dateCreate,
          nameDir: model.nameDir,
          idSchool: model.idSchool,
          nameTeacher:model. nameTeacher,
          nameSub: model.nameSub,
          dOa: model.dOa, status: StatusToColor.clientStatusFromApi(model.status),
          timeNearLesson: model.timeNearLesson);
    }





  }