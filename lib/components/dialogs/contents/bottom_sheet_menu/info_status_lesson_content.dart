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

class InfoStatusLessonContent extends StatefulWidget {
  const InfoStatusLessonContent({super.key, required this.lesson, required this.callFromTable});

  final Lesson lesson;
  final bool callFromTable;

  @override
  State<InfoStatusLessonContent> createState() =>
      _InfoStatusLessonContentState();
}

class _InfoStatusLessonContentState extends State<InfoStatusLessonContent> {

  Lesson? _editedLesson;

  @override
  void initState() {
    super.initState();
    _editedLesson = widget.lesson;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height - 200),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Тип занятия:',
                    style:
                        TStyle.textStyleVelaSansMedium(colorGrey, size: 15.0)),
                Row(
                  children: [
                    Text(
                        widget.lesson.type == LessonType.singly
                            ? 'Индивидуальный'
                            : widget.lesson.type == LessonType.group
                                ? 'Групповой'
                                : 'Можно ПУ',
                        style: TStyle.textStyleVelaSansBold(
                            textColorBlack(context),
                            size: 16.0)),
                    const Gap(10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                          color: colorGrey,
                          borderRadius: BorderRadius.circular(5)),
                      child: Text(!widget.lesson.online ? 'offline' : "offline",
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TStyle.textStyleVelaSansBold(
                              Theme.of(context).textTheme.displayMedium!.color!,
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
                    Text(
                        DateTimeParser.getDateFromApi(date: widget.lesson.date),
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
                    Icon(Icons.location_on_outlined,
                        color: colorGreen, size: 16.0),
                    const Gap(5),
                    Text(widget.lesson.idSchool,
                        style: TStyle.textStyleVelaSansMedium(colorGrey,
                            size: 15.0)),
                  ],
                ),
                Visibility(
                  visible: !widget.lesson.type.isTrial,
                  child: Row(
                    children: [
                      Icon(Icons.directions, color: colorGreen, size: 16.0),
                      const Gap(5),
                      Text(widget.lesson.nameDirection,
                          style: TStyle.textStyleVelaSansMedium(colorGrey,
                              size: 15.0)),
                    ],
                  ),
                )
              ],
            ),
            const Gap(5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Аудитория:',
                    style:
                        TStyle.textStyleVelaSansMedium(colorGrey, size: 15.0)),
                Text(widget.lesson.idAuditory,
                    style: TStyle.textStyleVelaSansBold(textColorBlack(context),
                        size: 16.0))
              ],
            ),
            Visibility(
              visible: widget.lesson.type.isGroup,
              child: Column(
                children: [
                  const Gap(5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Группа:',
                          style:
                          TStyle.textStyleVelaSansMedium(colorGrey, size: 15.0)),
                      Text(widget.lesson.nameGroup,
                          style: TStyle.textStyleVelaSansBold(textColorBlack(context),
                              size: 16.0))
                    ],
                  ),
                ],
              ),
            ),
            const Gap(5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Преподаватель:',
                    style:
                        TStyle.textStyleVelaSansMedium(colorGrey, size: 15.0)),
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
                    style:
                        TStyle.textStyleVelaSansMedium(colorGrey, size: 15.0)),
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
                    style:
                        TStyle.textStyleVelaSansMedium(colorGrey, size: 15.0)),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                      color: StatusToColor.getColor(
                          lessonStatus: widget.lesson.status),
                      borderRadius: BorderRadius.circular(5),
                      border: widget.lesson.status == LessonStatus.planned ||
                              widget.lesson.status == LessonStatus.reservation||
                              widget.lesson.status.isComplete
                          ? Border.all(color: textColorBlack(context), width: 1)
                          : null),
                  child: Text(StatusToColor.getNameStatus(widget.lesson.status),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TStyle.textStyleVelaSansBold(
                          color(widget.lesson.status, context),
                          size: 10.0)),
                ),
              ],
            ),
            const Gap(5),
            Divider(
              color: colorGrey,
            ),
            Visibility(
              visible: !widget.lesson.type.isGroup,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Клиент:',
                          style:
                              TStyle.textStyleVelaSansMedium(colorGrey, size: 15.0)),
                      Text(widget.lesson.nameStudent.isEmpty?'...':widget.lesson.nameStudent,
                          style: TStyle.textStyleVelaSansBold(textColorBlack(context),
                              size: 16.0))
                    ],
                  ),
                  const Gap(5),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Статус по времени:',
                    style:
                        TStyle.textStyleVelaSansMedium(colorGrey, size: 15.0)),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                      color: colorGrey, borderRadius: BorderRadius.circular(5)),
                  child: Text(_getStatusTime(widget.lesson),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TStyle.textStyleVelaSansBold(
                          Theme.of(context).textTheme.displayMedium!.color!,
                          size: 12.0)),
                )
              ],
            ),
            const Gap(10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Абонемент:',
                    style:
                        TStyle.textStyleVelaSansMedium(colorGrey, size: 15.0)),
                Expanded(
                  child: Text(widget.lesson.nameSub.isEmpty?'...':widget.lesson.nameSub,
                      textAlign: TextAlign.end,
                      style: TStyle.textStyleVelaSansBold(
                          textColorBlack(context),
                          size: 13.0)),
                )
              ],
            ),
            const Gap(5),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Комментарий:',
                    style:
                        TStyle.textStyleVelaSansMedium(colorGrey, size: 15.0)),
                const Gap(20),
                Expanded(
                  child: Text(widget.lesson.comments.isEmpty?'...':widget.lesson.comments,
                      textAlign: TextAlign.end,
                      style: TStyle.textStyleVelaSansBold(textColorBlack(context),
                          size: 16.0)),
                )
              ],
            ),
            const Gap(30),
            Visibility(
                visible: widget.lesson.status == LessonStatus.complete,
                child: SizedBox(
                  height: 35.0,
                  child: SubmitButton(
                    colorFill: colorGreen,
                    onTap: () {},
                    borderRadius: 10.0,
                    textButton: 'Вернуть и провести'.tr(),
                  ),
                )),
            Visibility(
                visible: widget.lesson.status == LessonStatus.cancel||
                widget.lesson.status.isOut||widget.lesson.status.isTrial,
                child: SizedBox(
                  height: 35.0,
                  child: SubmitButton(
                    colorFill: colorGreen,
                    onTap: () {
                      Dialoger.showToast('В разработке');
                    },
                    borderRadius: 10.0,
                    textButton: 'Добавить урок на это же время'.tr(),
                  ),
                )),
            const Gap(8),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 35.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Visibility(
                        visible:
                  widget.lesson.status == LessonStatus.singly ||
                  widget.lesson.status == LessonStatus.lastLesson ||
                  widget.lesson.status == LessonStatus.firstLesson ||
                  widget.lesson.status == LessonStatus.planned,
                        child: Expanded(
                          child: SubmitButton(
                            colorFill: colorGreen,
                            onTap: () {
                              _editedLesson = _editedLesson?.copyWith(
                                  status: LessonStatus.awaitAccept);
                              Dialoger.showCustomDialog(
                                  contextUp: context,
                                  content: EditStatusLesson(),
                                args: [_editedLesson,widget.callFromTable]);

                            },
                            borderRadius: 10.0,
                            textButton: 'Провести'.tr(),
                          ),
                        ),
                      ),
                      const Gap(8),
                      Visibility(
                        visible:
                        widget.lesson.status == LessonStatus.singly ||
                            widget.lesson.status == LessonStatus.lastLesson ||
                            widget.lesson.status == LessonStatus.firstLesson ||
                            widget.lesson.status == LessonStatus.planned,
                        child: Expanded(
                          child: SubmitButton(
                            colorFill: colorGreen,
                            onTap: () {
                              _editedLesson = _editedLesson?.copyWith(
                                  status: LessonStatus.out);
                              Dialoger.showCustomDialog(
                                  contextUp: context,
                                  content: EditStatusLesson(),
                                  args: [_editedLesson,widget.callFromTable]);

                            },
                            borderRadius: 10.0,
                            textButton: 'Пропуск'.tr(),
                          ),
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
                      Visibility(
                        visible:
                           widget.lesson.status == LessonStatus.singly ||
                            widget.lesson.status == LessonStatus.lastLesson ||
                            widget.lesson.status == LessonStatus.firstLesson ||
                            widget.lesson.status == LessonStatus.planned ||
                           widget.lesson.status.isReservation,
                        child: Expanded(
                          child: SubmitButton(
                            colorFill: colorGreen,
                            onTap: () {
                              _editedLesson = _editedLesson?.copyWith(
                                  status: LessonStatus.reschedule);
                              Dialoger.showCustomDialog(
                                  contextUp: context,
                                  content: EditStatusLesson(),
                                  args: [_editedLesson,widget.callFromTable]);

                            },
                            borderRadius: 10.0,
                            textButton: 'Перенести'.tr(),
                          ),
                        ),
                      ),
                      const Gap(8),
                      Visibility(
                        visible:
                        widget.lesson.status == LessonStatus.singly ||
                            widget.lesson.status == LessonStatus.lastLesson ||
                            widget.lesson.status == LessonStatus.firstLesson ||
                            widget.lesson.status == LessonStatus.planned||
                           widget.lesson.status.isReservation ||
                            widget.lesson.status.isReschedule,
                        child: Expanded(
                          child: SubmitButton(
                            colorFill: colorRed,
                            onTap: () {
                              _editedLesson = _editedLesson?.copyWith(
                                  status: LessonStatus.cancel);
                              Dialoger.showCustomDialog(
                                  contextUp: context,
                                  content: EditStatusLesson(),
                                  args: [_editedLesson,widget.callFromTable]);

                            },
                            borderRadius: 10.0,
                            textButton: 'Отменить'.tr(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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

  Color color(LessonStatus status, BuildContext context) {
    return status == LessonStatus.complete ||
        status == LessonStatus.reservation ||
        status == LessonStatus.planned
        ? colorBlack
        : Theme.of(context).textTheme.displayMedium!.color!;
  }

  String _getStatusTime(Lesson lesson) {
    final daysStatus = ['вчера','сегодня','завтра','прошлое','будущее'];
    final dNow = DateTime.now();
    const d = 86400000;

    final dateStringNow = DateFormat('yyyy-MM-dd').format(dNow);
    final intToDay = DateTimeParser.getTimeMillisecondEpochByDate(date: dateStringNow);
    final intTimeLesson =
    DateTimeParser.getTimeMillisecondEpochByDate(date: lesson.date);
    if(lesson.date==dateStringNow){
      return daysStatus[1];
    }

    if(intToDay>intTimeLesson){
      final d1 = intToDay - intTimeLesson;
      if(d1<=d){
        return daysStatus[0];
      }else if(d1>d){
        return daysStatus[3];
      }
    }else if(intToDay<intTimeLesson){
      final d2 = intTimeLesson - intToDay;
      if(d2<=d){
        return daysStatus[2];
      }else if(d2>d){
        return daysStatus[4];
      }
    }
   return '...';
  }
}
