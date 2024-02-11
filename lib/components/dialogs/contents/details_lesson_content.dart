


 import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:virtuozy/domain/entities/user_entity.dart';

import '../../../resourses/colors.dart';
import '../../../utils/status_to_color.dart';
import '../../../utils/text_style.dart';
import '../../buttons.dart';

class DetailsLessonContent extends StatelessWidget {
  const DetailsLessonContent(
      {super.key, required this.lesson, required this.nameDirection});

  final Lesson lesson;
  final String nameDirection;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      width: double.infinity,
      decoration: BoxDecoration(
          color: colorBeruzaLight,
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
                  Icon(Icons.calendar_month, color: colorBlack, size: 15.0),
                  const Gap(5.0),
                  Text(lesson.date,
                      style: TStyle.textStyleVelaSansMedium(
                          colorBlack, size: 16.0)),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.timelapse_rounded, color: colorBlack, size: 15.0),
                  const Gap(5.0),
                  Text(lesson.timePeriod,
                      style: TStyle.textStyleVelaSansMedium(
                          colorBlack, size: 16.0)),
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
              style: TStyle.textStyleVelaSansBold(colorBlack, size: 18.0)),
          const Gap(10.0),
          Text(nameDirection,
              style: TStyle.textStyleVelaSansMedium(colorGrey, size: 16.0)),
          const Gap(20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 10.0,
                    height: 10.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: StatusToColor.getColor(lessonStatus: lesson.status)
                    ),
                  ),
                  const Gap(10.0),
                  Text(_getNameStatus(lesson.status),
                      style: TStyle.textStyleVelaSansExtraBolt(
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
      case LessonStatus.unknown:
        return '';
    }


    String _getDay(String date) {
      final day = DateFormat('yyyy-MM-dd')
          .parse(date)
          .day;

      return '';
    }
  }
}
