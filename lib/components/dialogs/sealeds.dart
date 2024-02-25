

import 'package:flutter/widgets.dart';
import 'package:virtuozy/components/dialogs/contents/alert_dialog/log_out_content.dart';
import 'package:virtuozy/components/dialogs/contents/bottom_sheet_menu/bonuses_list_content.dart';
import 'package:virtuozy/components/dialogs/contents/bottom_sheet_menu/details_lesson_content.dart';
import 'package:virtuozy/domain/entities/user_entity.dart';

import 'contents/bottom_sheet_menu/seach_location_cmplete_content.dart';
import 'contents/bottom_sheet_menu/select_branch_content.dart';
import 'contents/bottom_sheet_menu/steps_confirm_lesson_content.dart';



sealed class DialogsContent{
  build({required BuildContext context,Object? args});
}


sealed class AlertDialogContent{
  build({required BuildContext context,Object? args});
}

class LogOut extends AlertDialogContent{
  @override
  build({required BuildContext context, Object? args}) {
    return  LogOutContent(user: (args as UserEntity),);
  }

}

class DetailsLesson extends DialogsContent{
  @override
  build({required BuildContext context, Object? args}) {
    return DetailsLessonContent(lessons: (args as List<dynamic>)[0] as List<Lesson>,
        directions: (args)[1] as List<DirectionLesson>);
  }

}


class ConfirmLesson extends DialogsContent{
  @override
  build({required BuildContext context,Object? args}) {
    return  StepsConfirmLesson(lesson: (args as List<dynamic>)[0] as Lesson,
        directions: (args)[1] as List<DirectionLesson>,
        listNotAcceptLesson: (args)[2] as List<Lesson>,
         allViewDirection: (args)[3] as bool);
  }
}

class SelectBranch extends DialogsContent{
  @override
  build({required BuildContext context,Object? args}) {
    return const SelectBranchContent();
  }
}
class SearchLocationComplete extends DialogsContent{
  @override
  build({required BuildContext context,Object? args}) {
    return  SearchLocationCompleteContent(branch: (args as String)??'');
  }

}

class ListBonuses extends DialogsContent{
  @override
  build({required BuildContext context, Object? args}) {
    return BonusesListContent(bonuses: (args as List<BonusEntity>));
  }

}