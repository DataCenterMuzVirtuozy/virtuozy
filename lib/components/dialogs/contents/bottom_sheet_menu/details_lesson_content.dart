import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';
import 'package:virtuozy/components/dialogs/contents/bottom_sheet_menu/steps_confirm_lesson_content.dart';
import 'package:virtuozy/components/teacher_contacts.dart';
import 'package:virtuozy/domain/entities/user_entity.dart';
import 'package:virtuozy/utils/date_time_parser.dart';

import '../../../../domain/entities/lesson_entity.dart';
import '../../../../domain/entities/subscription_entity.dart';
import '../../../../resourses/colors.dart';
import '../../../../utils/status_to_color.dart';
import '../../../../utils/text_style.dart';
import '../../../buttons.dart';
import '../../dialoger.dart';
import '../../sealeds.dart';

class DetailsLessonContent extends StatefulWidget {
  const DetailsLessonContent(
      {super.key, required this.lessons, required this.directions});

  final List<Lesson> lessons;
  final List<DirectionLesson> directions;

  @override
  State<DetailsLessonContent> createState() => _DetailsLessonContentState();
}

class _DetailsLessonContentState extends State<DetailsLessonContent> {
  final double _heightBox = 390.0;
   int selectedPage = 0;
  late final PageController _pageController;
  List<SubscriptionEntity> _lastAllSubscribtion = [];

  DirectionLesson _getDirectionByLesson({required Lesson lessonEntity}) {
    try {
      return widget.directions
          .firstWhere((element) => element.name == lessonEntity.nameDirection);
    } catch (e) {
      return DirectionLesson.unknown();
    }
  }


  String _maxNumberLessonFromSubs({required int idSub, required List<SubscriptionEntity> subs}){
    try{
      return 'из ${subs.firstWhere((s)=>s.id == idSub).maxLessonsCount.toString()}';
    }catch (e){
      return ' ';
    }



  }

  @override
  void initState() {
    _pageController = PageController(initialPage: selectedPage);
  for(var list in widget.directions){
    _lastAllSubscribtion.addAll(list.lastSubscriptions);
  }
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        currentDayNotifi.value = 0;
        Navigator.of(context).pop();
      },
      child: SizedBox(
        height: _heightBox,
        child: Column(
          children: [
            Container(
              height: 45.0,
              padding: const EdgeInsets.only(
                  top: 5.0, right: 15.0, left: 20.0),
              decoration: BoxDecoration(
                  color: colorGrey,
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20.0),
                      topLeft: Radius.circular(20.0),
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Урок № ${widget.lessons[selectedPage].number} ${_maxNumberLessonFromSubs(idSub: widget.lessons[selectedPage].idSub, subs:_lastAllSubscribtion)}',
                    style: TStyle.textStyleGaretHeavy(colorWhite,
                        size: 16.0),
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.close_rounded,
                          color: colorWhite)),
                ],
              ),
            ),
            const Gap(10.0),
            Expanded(
              child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (page) {
                    setState(() {
                      selectedPage = page;
                    });
                  },
                  itemCount: widget.lessons.length,
                  itemBuilder: (context, index) {
                    return ItemDetailsLesson(
                        lesson: widget.lessons[index],
                        direction: _getDirectionByLesson(
                            lessonEntity: widget.lessons[index]));
                  }),
            ),
            Visibility(
              visible: widget.lessons.length > 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: PageViewDotIndicator(
                  size: const Size(8.0, 8.0),
                  currentItem: selectedPage,
                  count: widget.lessons.length,
                  unselectedColor: colorGrey,
                  selectedColor:
                      Theme.of(context).textTheme.displayMedium!.color!,
                  duration: const Duration(milliseconds: 200),
                  boxShape: BoxShape.circle,
                  onItemClicked: (index) {
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
              ),
            ),
            const Gap(10.0)
          ],
        ),
      ),
    );
  }
}

class ItemDetailsLesson extends StatelessWidget {
  const ItemDetailsLesson(
      {super.key, required this.lesson, required this.direction});

  final Lesson lesson;
  final DirectionLesson direction;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
      margin: EdgeInsets.only(
          bottom: lesson.status == LessonStatus.awaitAccept ? 20.0 : 90.0),
      width: double.infinity,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(10.0)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.calendar_month,
                      color: Theme.of(context).textTheme.displayMedium!.color!,
                      size: 15.0),
                  const Gap(5.0),
                  Text(DateTimeParser.getDateFromApi(date: lesson.date),
                      style: TStyle.textStyleVelaSansMedium(
                          Theme.of(context).textTheme.displayMedium!.color!,
                          size: 16.0)),
                ],
              ),
              Visibility(
                visible: lesson.timePeriod.isNotEmpty,
                child: Row(
                  children: [
                    Icon(Icons.timelapse_rounded,
                        color:
                            Theme.of(context).textTheme.displayMedium!.color!,
                        size: 15.0),
                    const Gap(5.0),
                    Text(lesson.timePeriod,
                        style: TStyle.textStyleVelaSansMedium(
                            Theme.of(context).textTheme.displayMedium!.color!,
                            size: 16.0)),
                  ],
                ),
              ),
            ],
          ),
          const Gap(10.0),
          Row(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.directions, color: colorGrey, size: 16.0),
                  const Gap(5),
                  Text('Направление: '.tr(),
                      style: TStyle.textStyleVelaSansMedium(colorGrey,
                          size: 15.0)),
                ],
              ),
              Text(lesson.nameDirection,
                  style: TStyle.textStyleVelaSansBold(
                      Theme.of(context).textTheme.displayMedium!.color!,
                      size: 16.0)),
            ],
          ),
          Row(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.school_outlined, color: colorGrey, size: 16.0),
                  const Gap(5),
                  Text('Школа: '.tr(),
                      style: TStyle.textStyleVelaSansMedium(colorGrey,
                          size: 15.0)),
                ],
              ),
              Text(lesson.nameSchool,
                  style: TStyle.textStyleVelaSansBold(
                      Theme.of(context).textTheme.displayMedium!.color!,
                      size: 16.0)),
            ],
          ),
          Row(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.door_back_door_outlined,
                      color: colorGrey, size: 16.0),
                  const Gap(5),
                  Text('Кабинет: '.tr(),
                      style: TStyle.textStyleVelaSansMedium(colorGrey,
                          size: 15.0)),
                ],
              ),
              Text(lesson.nameAuditory,
                  style: TStyle.textStyleVelaSansBold(
                      Theme.of(context).textTheme.displayMedium!.color!,
                      size: 16.0)),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.type_specimen_outlined, color: colorGrey, size: 16.0),
              const Gap(5),
              Text('Тип занятия:',
                  style: TStyle.textStyleVelaSansMedium(colorGrey, size: 15.0)),
              const Gap(5),
              Row(
                children: [
                  Text(
                      lesson.type == LessonType.INDEPENDENT_TYPE
                          ? 'Самостоятельный'
                          : lesson.type == LessonType.GROUP_TYPE
                              ? 'Групповой'
                              : lesson.type == LessonType.CAN_PU_TYPE
                                  ? 'Можно ПУ'
                                  : lesson.type == LessonType.PU_TYPE
                                      ? "Пробный урок"
                                      : lesson.type ==
                                              LessonType.INDIVIDUAL_TYPE
                                          ? "Индивидуальный"
                                          : "Резерв",
                      style: TStyle.textStyleVelaSansBold(
                          textColorBlack(context),
                          size: 16.0)),
                  // const Gap(10),
                  // Container(
                  //   padding: const EdgeInsets.symmetric(
                  //       horizontal: 8, vertical: 2),
                  //   decoration: BoxDecoration(
                  //       color: colorGrey,
                  //       borderRadius: BorderRadius.circular(5)),
                  //   child: Text(lesson.online ? 'offline' : "offline",
                  //       textAlign: TextAlign.center,
                  //       maxLines: 2,
                  //       overflow: TextOverflow.ellipsis,
                  //       style: TStyle.textStyleVelaSansBold(
                  //           Theme.of(context).textTheme.displayMedium!.color!,
                  //           size: 10.0)),
                  // )
                ],
              )
            ],
          ),
          const Gap(10),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(lesson.nameTeacher,
                        style: TStyle.textStyleVelaSansBold(
                            Theme.of(context).textTheme.displayMedium!.color!,
                            size: 18.0)),
                  ),
                  TeacherContacts(
                    contacts: lesson.contactValues,
                    size: 30,
                  )
                ],
              ),
              const Gap(5),
              Row(
                children: [
                  Container(
                    //margin: const EdgeInsets.only(left: 10.0),
                    width: 10.0,
                    height: 10.0,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: lesson.status == LessonStatus.planned
                                ? colorBlack
                                : StatusToColor.getColor(
                                    lesson: lesson),
                            width: 0.5),
                        color: StatusToColor.getColor(
                            lesson: lesson
                        )),
                  ),
                  const Gap(10.0),
                  Text(StatusToColor.getNameStatus(lesson.status),
                      style: TStyle.textStyleVelaSansRegular(colorGrey,
                          size: 14.0)),
                ],
              ),
            ],
          ),
          Visibility(
            visible: lesson.status == LessonStatus.complete &&
                lesson.timeAccept.isNotEmpty,
            child: Column(
              children: [
                Divider(color: colorGrey),
                const Gap(5.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Icon(Icons.timelapse_rounded, color: colorGrey, size: 13.0),
                    // const Gap(5.0),
                    Text('Дата подтверждения:'.tr(),
                        style: TStyle.textStyleVelaSansRegular(colorGrey,
                            size: 13.0)),
                    const Gap(5.0),
                    Text(DateTimeParser.getDateFromApi(date: lesson.timeAccept),
                        style: TStyle.textStyleVelaSansBold(colorGrey,
                            size: 13.0)),
                  ],
                ),
              ],
            ),
          ),
          Visibility(
              visible: lesson.status == LessonStatus.awaitAccept,
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: SizedBox(
                  height: 40.0,
                  child: SubmitButton(
                    onTap: () async {
                      Navigator.pop(context);
                      Dialoger.showModalBottomMenu(
                          blurred: false,
                          args: [
                            lesson,
                            [direction],
                            [lesson],
                            false
                          ],
                          title: 'Подтверждение урока'.tr(),
                          content: ConfirmLesson());
                    },
                    //colorFill: Theme.of(context).colorScheme.tertiary,
                    colorFill: colorGreen,
                    borderRadius: 10.0,
                    textButton: 'Подтвердите прохождение урока'.tr(),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
