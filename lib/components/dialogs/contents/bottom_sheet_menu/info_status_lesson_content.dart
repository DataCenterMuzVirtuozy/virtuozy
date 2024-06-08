



import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:virtuozy/components/dialogs/contents/alert_dialog/details_info_lesson_content.dart';
import 'package:virtuozy/presentations/teacher/schedule_table_screen/bloc/table_event.dart';
import 'package:virtuozy/utils/date_time_parser.dart';

import '../../../../domain/entities/lesson_entity.dart';
import '../../../../presentations/teacher/schedule_table_screen/bloc/table_bloc.dart';
import '../../../../resourses/colors.dart';
import '../../../../utils/status_to_color.dart';
import '../../../../utils/text_style.dart';
import '../../../buttons.dart';
import '../../dialoger.dart';
import '../../sealeds.dart';

class InfoStatusLessonContent extends StatefulWidget{
  const InfoStatusLessonContent({super.key, required this.lesson});

  final Lesson lesson;

  @override
  State<InfoStatusLessonContent> createState() => _InfoStatusLessonContentState();
}

class _InfoStatusLessonContentState extends State<InfoStatusLessonContent> {


  LessonStatus _statusChange = LessonStatus.unknown;
  Lesson? _editedLesson;

  @override
  void initState() {
    super.initState();
    _statusChange = widget.lesson.status;
    _editedLesson = widget.lesson;
  }

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
                Text('Тип занятия:',
                    style: TStyle.textStyleVelaSansMedium(colorGrey,
                        size: 15.0)),
                Row(
                  children: [
                    Text(widget.lesson.type == LessonType.singly?'Индивидуальный':
                        widget.lesson.type == LessonType.group?'Групповой':'Можно ПУ',
                        style: TStyle.textStyleVelaSansBold(textColorBlack(context),
                            size: 16.0)),
                    const Gap(10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 2),
                      decoration:  BoxDecoration(
                          color:  colorGrey,
                          borderRadius: BorderRadius.circular(5)
                      ),
                      child: Text(
                          !widget.lesson.online?'offline':"offline",
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TStyle.textStyleVelaSansBold(Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .color!,
                              size: 10.0)),
                    )
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
                    Icon(Icons.calendar_month, color: colorGreen, size: 16.0),
                    const Gap(5),
                    Text(DateTimeParser.getDateFromApi(date: widget.lesson.date),
                        style: TStyle.textStyleVelaSansMedium(colorGrey,
                            size: 15.0)),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.timelapse, color: colorGreen, size: 16.0),
                    const Gap(5),
                    Text(widget.lesson.timePeriod.split('-')[0],
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
                    Text(widget.lesson.idSchool,
                        style: TStyle.textStyleVelaSansMedium(colorGrey,
                            size: 15.0)),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.directions, color: colorGreen, size: 16.0),
                    const Gap(5),
                    Text(widget.lesson.nameDirection,
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
                Text(widget.lesson.idAuditory,
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
                Text(widget.lesson.nameTeacher,
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
                Text('${widget.lesson.duration} мин.',
                    style: TStyle.textStyleVelaSansBold(textColorBlack(context),
                        size: 16.0))
              ],
            ),
            const Gap(5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Статус урока:',
                    style: TStyle.textStyleVelaSansMedium(colorGrey,
                        size: 15.0)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 2),
                  decoration:  BoxDecoration(
                      color:  StatusToColor.getColor(
                          lessonStatus: widget.lesson.status),
                      borderRadius: BorderRadius.circular(5)
                  ),
                  child: Text(
                      StatusToColor.getNameStatus(widget.lesson.status),
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
            const Gap(5),
            Divider(color: colorGrey,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Клиент:',
                    style: TStyle.textStyleVelaSansMedium(colorGrey,
                        size: 15.0)),
                Text(widget.lesson.nameStudent,
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
                      _getStatusTime(widget.lesson),
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
                  child: Text(widget.lesson.nameSub,
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
                Text(widget.lesson.comments,
                    style: TStyle.textStyleVelaSansBold(textColorBlack(context),
                        size: 16.0))
              ],
            ),
            const Gap(30),
            Visibility(
              visible: widget.lesson.status==LessonStatus.complete,
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
              visible: widget.lesson.status==LessonStatus.cancel || widget.lesson.status == LessonStatus.singly|| widget.lesson.status == LessonStatus.lastLesson
                  || widget.lesson.status == LessonStatus.firstLesson|| widget.lesson.status == LessonStatus.planned|| widget.lesson.status == LessonStatus.awaitAccept,
              child: Column(
                children: [
                  SizedBox(
                    height: 35.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: SubmitButton(
                            colorFill: colorGreen,
                            onTap: () {
                              //todo call alert
                              _editedLesson = _editedLesson?.copyWith(status: LessonStatus.awaitAccept);
                                context.read<TableBloc>().add(EditStatusLessonEvent(lesson: _editedLesson!));
                                Navigator.pop(context);
                            },
                            borderRadius: 10.0,
                            textButton: 'Провести'.tr(),
                          ),
                        ),
                        const Gap(8),
                        Expanded(
                          child: SubmitButton(
                            colorFill: colorGreen,
                            onTap: () {},
                            borderRadius: 10.0,
                            textButton: 'Пропуск'.tr(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(8),
                  SizedBox(
                    height: 35.0,
                    child: Row(
                      children: [
                        Expanded(
                          child: SubmitButton(
                            colorFill: colorGreen,
                            onTap: () {},
                            borderRadius: 10.0,
                            textButton: 'Перенести'.tr(),
                          ),
                        ),
                        const Gap(8),
                        Expanded(
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
                ],
              ),
            ),
            //const Gap(8),
            // Visibility(
            //   visible: lesson.status != LessonStatus.complete || lesson.status == LessonStatus.reschedule,
            //   child: SizedBox(
            //     height: 40.0,
            //     child: SubmitButton(
            //       colorFill: colorGrey,
            //       onTap: () {
            //         Dialoger.showCustomDialog(contextUp: context,
            //             content: InfoDetailsLesson());
            //
            //       },
            //       borderRadius: 10.0,
            //       textButton: 'Подробнее'.tr(),
            //     ),
            //   ),
            // ),
           const Gap(40)
          ],
        ),
      ),
    );
  }

   String _getStatusTime(Lesson lesson){
    final intToDay = DateTime.now().millisecondsSinceEpoch;
    final intTimeLesson = DateTimeParser.getTimeMillisecondEpochByDate(date: lesson.date);
    return intToDay>intTimeLesson?'вчера':intToDay == intTimeLesson?'сегодня':'завтра';
   }
}