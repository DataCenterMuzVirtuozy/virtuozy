

import 'package:flutter/widgets.dart';

import 'contents/seach_location_cmplete_content.dart';
import 'contents/select_branch_content.dart';
import 'contents/steps_confirm_lesson_content.dart';

sealed class DialogsContent{
  build({required BuildContext context,Object? args});
}


class ConfirmLesson extends DialogsContent{
  @override
  build({required BuildContext context,Object? args}) {
    return const StepsConfirmLesson();
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