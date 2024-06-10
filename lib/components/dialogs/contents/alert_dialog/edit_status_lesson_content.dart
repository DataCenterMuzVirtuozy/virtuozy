


 import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:virtuozy/domain/entities/lesson_entity.dart';
import 'package:virtuozy/utils/status_to_color.dart';

import '../../../../presentations/teacher/schedule_table_screen/bloc/table_bloc.dart';
import '../../../../presentations/teacher/schedule_table_screen/bloc/table_event.dart';
import '../../../../resourses/colors.dart';
import '../../../../utils/text_style.dart';

class EditStatusLessonContent extends StatelessWidget{
  const EditStatusLessonContent({super.key, required this.lessonNew, required this.contextLast});


  final Lesson lessonNew;
  final BuildContext contextLast;

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.published_with_changes,color: Theme.of(context).textTheme.displayMedium!.color!,size: 40.0),
          const SizedBox(height: 15.0),
          Text('Изменить статус урока?'.tr(),
              textAlign:TextAlign.center,
              style:TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!,size: 18.0)),
          const SizedBox(height: 5.0),
          Text('Статус урока будет изменен на:'.tr(),
              textAlign:TextAlign.center,
              style:TStyle.textStyleVelaSansRegular(Theme.of(context).textTheme.displayMedium!.color!,size: 14.0)),
          const Gap(5),
          Text(StatusToColor.getNameStatus(lessonNew.status).tr().toUpperCase(),
              textAlign:TextAlign.center,
              style:TStyle.textStyleVelaSansRegularUnderline(textColorBlack(context),size: 16.0)),

          const SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Отмена'.tr(),
                      textAlign: TextAlign.center,
                      style: TStyle.textStyleVelaSansBold(
                          Theme.of(context).textTheme.displayMedium!.color!,
                          size: 16.0))),
              const Gap(5.0),
              TextButton(
                onPressed: () {
                  context.read<TableBloc>().add(EditStatusLessonEvent(lesson: lessonNew));
                  Navigator.pop(context);
                  Navigator.pop(contextLast);
                },
                child: Text('Ок'.tr(),
                    textAlign: TextAlign.center,
                    style:
                    TStyle.textStyleVelaSansBold(colorRed,size: 16.0)),)
            ],
          )
        ],
      ),
    );

  }

}