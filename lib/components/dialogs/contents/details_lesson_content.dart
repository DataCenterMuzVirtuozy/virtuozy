


 import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:virtuozy/domain/entities/user_entity.dart';

import '../../../resourses/colors.dart';
import '../../../utils/status_to_color.dart';
import '../../../utils/text_style.dart';
import '../../buttons.dart';
import '../dialoger.dart';
import '../sealeds.dart';

class DetailsLessonContent extends StatelessWidget {
  const DetailsLessonContent(
      {super.key, required this.lessons, required this.directions});

  final List<Lesson> lessons;
  final List<DirectionLesson> directions;
  final double _heightBox = 295.0;

  DirectionLesson _getDirectionByLesson({required Lesson lessonEntity}){
    return directions.firstWhere((element) => element.name == lessonEntity.nameDirection);
  }

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: _heightBox,
      child: PageView.builder(
        itemCount: lessons.length,
          itemBuilder: (context,index){
        return ItemDetailsLesson(
            lesson: lessons[index],
            direction: _getDirectionByLesson(lessonEntity: lessons[index]));
      }),
    );
  }



}

class ItemDetailsLesson extends StatelessWidget{
  const ItemDetailsLesson({super.key, required this.lesson, required this.direction});

  final Lesson lesson;
  final DirectionLesson direction;

  @override
  Widget build(BuildContext context) {
   return Container(
     padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
     margin: const EdgeInsets.only(bottom: 20.0),
     width: double.infinity,
     decoration: BoxDecoration(
         color: Theme.of(context).colorScheme.surfaceVariant,
         borderRadius: BorderRadius.circular(10.0)
     ),
     child: Column(
       crossAxisAlignment: CrossAxisAlignment.center,
       children: [
         Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             Row(
               children: [
                 Icon(Icons.calendar_month, color: Theme.of(context).textTheme.displayMedium!.color!, size: 15.0),
                 const Gap(5.0),
                 Text(lesson.date,
                     style: TStyle.textStyleVelaSansMedium(
                         Theme.of(context).textTheme.displayMedium!.color!, size: 16.0)),
               ],
             ),
             Row(
               children: [
                 Icon(Icons.timelapse_rounded, color: Theme.of(context).textTheme.displayMedium!.color!, size: 15.0),
                 const Gap(5.0),
                 Text(lesson.timePeriod,
                     style: TStyle.textStyleVelaSansMedium(
                         Theme.of(context).textTheme.displayMedium!.color!, size: 16.0)),
               ],
             ),
           ],
         ),
         const Gap(10.0),
         Row(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             Text('Кабинет №',
                 style: TStyle.textStyleVelaSansMedium(colorGrey, size: 16.0)),
             Text('${lesson.idAuditory}',
                 style: TStyle.textStyleVelaSansMedium(colorGrey, size: 16.0)),
           ],
         ),
         const Gap(10.0),
         Text(lesson.nameTeacher,
             style: TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!, size: 18.0)),
         const Gap(10.0),
         Text(lesson.nameDirection,
             style: TStyle.textStyleVelaSansMedium(colorGrey, size: 16.0)),
         const Gap(20.0),
         Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             Row(
               children: [
                 Container(
                   margin: const EdgeInsets.only(left: 10.0),
                   width: 10.0,
                   height: 10.0,
                   decoration: BoxDecoration(
                       shape: BoxShape.circle,
                       color: StatusToColor.getColor(lessonStatus: lesson.status)
                   ),
                 ),
                 const Gap(10.0),
                 Text(_getNameStatus(lesson.status),
                     style: TStyle.textStyleVelaSansRegular(
                         colorGrey, size: 14.0)),
               ],
             ),
             Visibility(
               visible: lesson.status == LessonStatus.complete,
               child: Row(
                 children: [
                   Text(lesson.timeAccept,
                       style: TStyle.textStyleVelaSansRegular(
                           colorGrey, size: 13.0)),
                   const Gap(5.0),
                   Icon(Icons.timelapse_rounded, color: colorGrey, size: 13.0),

                 ],
               ),
             )
           ],
         ),
         Visibility(
             visible: lesson.status == LessonStatus.awaitAccept,
             child: Padding(
               padding: const EdgeInsets.only(top: 20.0,bottom: 20.0),
               child: SizedBox(
                 height: 40.0,
                 child: SubmitButton(
                   onTap: () async {
                     Navigator.pop(context);
                     Dialoger.showModalBottomMenu(
                         blurred: false,
                         args:[lesson,direction,[lesson]],
                         title:'Подтверждение урока'.tr(),context: context,
                         content: ConfirmLesson());
                   },
                   //colorFill: Theme.of(context).colorScheme.tertiary,
                   colorFill: colorGreen,
                   borderRadius: 10.0,
                   textButton:
                   'Подтвердите прохождение урока'.tr(),
                 ),
               ),
             )
         ),


       ],
     ),
   );
  }

  String _getNameStatus(LessonStatus status) {
    switch (status) {
      case LessonStatus.planned:
        return StatusToColor.namesStatus[0];
      case LessonStatus.complete:
        return StatusToColor.namesStatus[6];
      case LessonStatus.cancel:
        return StatusToColor.namesStatus[2];
      case LessonStatus.out:
        return StatusToColor.namesStatus[4];
      case LessonStatus.reservation:
        return StatusToColor.namesStatus[3];
      case LessonStatus.singly:
        return StatusToColor.namesStatus[5];
      case LessonStatus.trial:
        return StatusToColor.namesStatus[1];
      case LessonStatus.awaitAccept:
        return StatusToColor.namesStatus[7];
      case LessonStatus.layering:
        return StatusToColor.namesStatus[8];
      case LessonStatus.unknown:
        return '';


    }


  }

}
