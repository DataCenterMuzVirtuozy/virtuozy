

import 'package:flutter/widgets.dart';
import 'package:virtuozy/components/dialogs/contents/alert_dialog/accept_docunents_content.dart';
import 'package:virtuozy/components/dialogs/contents/alert_dialog/download_doc_content.dart';
import 'package:virtuozy/components/dialogs/contents/alert_dialog/log_out_content.dart';
import 'package:virtuozy/components/dialogs/contents/alert_dialog/log_out_teacher_content.dart';
import 'package:virtuozy/components/dialogs/contents/alert_dialog/select_date_content.dart';
import 'package:virtuozy/components/dialogs/contents/bottom_sheet_menu/bonuses_list_content.dart';
import 'package:virtuozy/components/dialogs/contents/bottom_sheet_menu/details_lesson_content.dart';
import 'package:virtuozy/domain/entities/document_entity.dart';
import 'package:virtuozy/domain/entities/teacher_entity.dart';
import 'package:virtuozy/domain/entities/user_entity.dart';

import '../../domain/entities/lesson_entity.dart';
import 'contents/bottom_sheet_menu/seach_location_cmplete_content.dart';
import 'contents/bottom_sheet_menu/select_branch_content.dart';
import 'contents/bottom_sheet_menu/steps_confirm_lesson_content.dart';
import 'contents/bottom_sheet_menu/support_list_content.dart';



sealed class DialogsContent{
  build({required BuildContext context,Object? args});
}


sealed class AlertDialogContent{
  build({required BuildContext context,Object? args});
}

class DownloadDocument extends AlertDialogContent{
  @override
  build({required BuildContext context, Object? args}) {
    return DownloadDocContent(documentEntity: (args as DocumentEntity));
  }

}

class AcceptDocuments extends AlertDialogContent{
  @override
  build({required BuildContext context, Object? args}) {
   return  AcceptDocumentsContent(docs: (args as List<DocumentEntity>),);
  }

}

class SelectDate extends AlertDialogContent {
  @override
  build({required BuildContext context, Object? args}) {
    return SelectDateContent(lessons: (args as List<Lesson>));
  }
}

class LogOut extends AlertDialogContent{
  @override
  build({required BuildContext context, Object? args}) {
    return  LogOutContent(user: (args as UserEntity),);
  }

}

class LogOutTeacher extends AlertDialogContent{
  @override
  build({required BuildContext context, Object? args}) {
    return LogOutTeacherContent(teacher: (args as TeacherEntity));
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

class ListSupport extends DialogsContent{
  @override
  build({required BuildContext context, Object? args}) {
    return SupportListContent(typeMessager: (args as TypeMessager));
  }

}



