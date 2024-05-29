

 import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:virtuozy/components/dialogs/contents/alert_dialog/details_info_lesson_content.dart';

import '../../../../domain/entities/lesson_entity.dart';
import '../../../../resourses/colors.dart';
import '../../../../utils/status_to_color.dart';
import '../../../../utils/text_style.dart';
import '../../../buttons.dart';
import '../../dialoger.dart';
import '../../sealeds.dart';

class InfoStatusLessonContent extends StatelessWidget{
  const InfoStatusLessonContent({super.key, required this.lesson});

  final Lesson lesson;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height-200),
      padding:  const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 2),
                  decoration:  BoxDecoration(
                      color:  colorGrey,
                      borderRadius: BorderRadius.circular(5)
                  ),
                  child: Text(
                      'offline',
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TStyle.textStyleVelaSansBold(Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .color!,
                          size: 10.0)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 2),
                  decoration:  BoxDecoration(
                      color:  StatusToColor.getColor(
                          lessonStatus: LessonStatus.cancel),
                      borderRadius: BorderRadius.circular(5)
                  ),
                  child: Text(
                      StatusToColor.getNameStatus(LessonStatus.cancel),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TStyle.textStyleVelaSansBold(Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .color!,
                          size: 10.0)),
                ),
              ],
            ),
            const Gap(10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Тип занятия:',
                    style: TStyle.textStyleVelaSansMedium(colorGrey,
                        size: 15.0)),
                Text('индивидуальный',
                    style: TStyle.textStyleVelaSansBold(textColorBlack(context),
                        size: 16.0))
              ],
            ),
            const Gap(5),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_month, color: colorGreen, size: 16.0),
                    const Gap(5),
                    Text('23.05.2024',
                        style: TStyle.textStyleVelaSansMedium(colorGrey,
                            size: 15.0)),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.timelapse, color: colorGreen, size: 16.0),
                    const Gap(5),
                    Text('12:30',
                        style: TStyle.textStyleVelaSansMedium(colorGrey,
                            size: 15.0)),
                  ],
                )
              ],
            ),
            const Gap(5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.location_on_outlined, color: colorGreen, size: 16.0),
                    const Gap(5),
                    Text('МШ1',
                        style: TStyle.textStyleVelaSansMedium(colorGrey,
                            size: 15.0)),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.directions, color: colorGreen, size: 16.0),
                    const Gap(5),
                    Text('Вокал',
                        style: TStyle.textStyleVelaSansMedium(colorGrey,
                            size: 15.0)),
                  ],
                )
              ],
            ),
           const Gap(5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Аудитория:',
                    style: TStyle.textStyleVelaSansMedium(colorGrey,
                        size: 15.0)),
                Text('2 - Эстрада',
                    style: TStyle.textStyleVelaSansBold(textColorBlack(context),
                        size: 16.0))
              ],
            ),
            const Gap(5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Преподаватель:',
                    style: TStyle.textStyleVelaSansMedium(colorGrey,
                        size: 15.0)),
                Text('Орлова Ольга',
                    style: TStyle.textStyleVelaSansBold(textColorBlack(context),
                        size: 16.0))
              ],
            ),
            const Gap(5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Длительность:',
                    style: TStyle.textStyleVelaSansMedium(colorGrey,
                        size: 15.0)),
                Text('60 мин.',
                    style: TStyle.textStyleVelaSansBold(textColorBlack(context),
                        size: 16.0))
              ],
            ),
            const Gap(5),
            Divider(color: colorGrey,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Клиент:',
                    style: TStyle.textStyleVelaSansMedium(colorGrey,
                        size: 15.0)),
                Text('Манкова Маргарита',
                    style: TStyle.textStyleVelaSansBold(textColorBlack(context),
                        size: 16.0))
              ],
            ),
            const Gap(5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Статус по времени:',
                    style: TStyle.textStyleVelaSansMedium(colorGrey,
                        size: 15.0)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 2),
                  decoration:  BoxDecoration(
                      color:  colorGrey,
                      borderRadius: BorderRadius.circular(5)
                  ),
                  child: Text(
                      'вчера',
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TStyle.textStyleVelaSansBold(Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .color!,
                          size: 12.0)),
                )            ],
            ),
            const Gap(10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Абонемент:',
                    style: TStyle.textStyleVelaSansMedium(colorGrey,
                        size: 15.0)),
                Expanded(
                  child: Text('Абик 4 12.05.2024 - 12.06.2024',
                      textAlign: TextAlign.end,
                      style: TStyle.textStyleVelaSansBold(textColorBlack(context),
                          size: 13.0)),
                )
              ],
            ),
            const Gap(5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Комментарий:',
                    style: TStyle.textStyleVelaSansMedium(colorGrey,
                        size: 15.0)),
                Text('...',
                    style: TStyle.textStyleVelaSansBold(textColorBlack(context),
                        size: 16.0))
              ],
            ),
            const Gap(30),
            Visibility(
              visible: lesson.status==LessonStatus.complete,
                child:
            SizedBox(
              height: 40.0,
              child: SubmitButton(
                colorFill: colorGreen,
                onTap: () {},
                borderRadius: 10.0,
                textButton: 'Вернуть и провести'.tr(),
              ),
            )
            ),
            Visibility(
              visible: lesson.status==LessonStatus.cancel || lesson.status == LessonStatus.singly|| lesson.status == LessonStatus.lastLesson
                  || lesson.status == LessonStatus.firstLesson|| lesson.status == LessonStatus.planned|| lesson.status == LessonStatus.awaitAccept,
              child: Column(
                children: [
                  SizedBox(
                    height: 40.0,
                    child: SubmitButton(
                      colorFill: colorGreen,
                      onTap: () {},
                      borderRadius: 10.0,
                      textButton: 'Провести'.tr(),
                    ),
                  ),
                  const Gap(8),
                  SizedBox(
                    height: 40.0,
                    child: SubmitButton(
                      colorFill: colorGreen,
                      onTap: () {},
                      borderRadius: 10.0,
                      textButton: 'Пропуск'.tr(),
                    ),
                  ),
                  const Gap(8),
                  SizedBox(
                    height: 40.0,
                    child: SubmitButton(
                      colorFill: colorGreen,
                      onTap: () {},
                      borderRadius: 10.0,
                      textButton: 'Перенести'.tr(),
                    ),
                  ),
                  const Gap(8),
                  SizedBox(
                    height: 40.0,
                    child: SubmitButton(
                      colorFill: colorRed,
                      onTap: () {},
                      borderRadius: 10.0,
                      textButton: 'Отменить'.tr(),
                    ),
                  ),
                ],
              ),
            ),
            const Gap(8),
            Visibility(
              visible: lesson.status != LessonStatus.complete || lesson.status == LessonStatus.reschedule,
              child: SizedBox(
                height: 40.0,
                child: SubmitButton(
                  colorFill: colorGrey,
                  onTap: () {
                    Dialoger.showCustomDialog(contextUp: context,
                        content: InfoDetailsLesson());

                  },
                  borderRadius: 10.0,
                  textButton: 'Подробнее'.tr(),
                ),
              ),
            )

          ],
        ),
      ),
    );
  }

}