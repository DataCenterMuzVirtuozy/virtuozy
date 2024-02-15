

import 'package:flutter/widgets.dart';
import 'package:virtuozy/components/dialogs/contents/details_lesson_content.dart';
import 'package:virtuozy/domain/entities/user_entity.dart';

import 'contents/seach_location_cmplete_content.dart';
import 'contents/select_branch_content.dart';
import 'contents/steps_confirm_lesson_content.dart';

sealed class DialogsContent{
  build({required BuildContext context,Object? args});
}

class DetailsLesson extends DialogsContent{
  @override
  build({required BuildContext context, Object? args}) {
    return DetailsLessonContent(lesson: (args as List<dynamic>)[0] as Lesson,
        direction: (args)[1] as DirectionLesson);
  }

}


class ConfirmLesson extends DialogsContent{
  @override
  build({required BuildContext context,Object? args}) {
    return  StepsConfirmLesson(lesson: (args as List<dynamic>)[0] as Lesson,
        direction: (args)[1] as DirectionLesson,listNotAcceptLesson: (args)[2] as List<Lesson>);
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