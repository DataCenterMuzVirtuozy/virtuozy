import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:virtuozy/components/dialogs/sealeds.dart';
import 'package:virtuozy/components/drop_menu.dart';
import 'package:virtuozy/utils/date_time_parser.dart';

import '../../../../domain/entities/lesson_entity.dart';
import '../../../../resourses/colors.dart';
import '../../../../utils/text_style.dart';
import '../../../buttons.dart';
import '../../dialoger.dart';

String _selectedTypeLesson = '';

PageController pageController = PageController();

class AddLessonContent extends StatefulWidget {
  const AddLessonContent({super.key, required this.initLesson});

  final Lesson initLesson;

  @override
  State<AddLessonContent> createState() => _AddLessonContentState();
}

class _AddLessonContentState extends State<AddLessonContent> {
  final List<double> _heightBody = [200.0, 800.0];
  int _stepIndex = 0;
  Lesson lesson = Lesson.unknown();


  @override
  void initState() {
    super.initState();
  lesson = widget.initLesson;

  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: _heightBody[_stepIndex],
      duration: const Duration(milliseconds: 700),
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height - 200),
      child: PageView.builder(
          controller: pageController,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return [
              Step1(
                onNext: (selected) {
                  setState(() {
                    _stepIndex = 1;
                    _selectedTypeLesson = selected;
                  lesson =  lesson.copyWith(
                        type: selected == 'Индивидуальные'
                            ? LessonType.singly
                            : selected == 'Групповой'
                            ? LessonType.group
                            : selected == 'Можно ПУ'
                            ? LessonType.trial
                            : LessonType.unknown);

                  });
                },
              ),
              Step2(
                lesson: lesson,
                key: ValueKey(_selectedTypeLesson),
              )
            ][index];
          }),
    );
  }
}

class Step1 extends StatefulWidget {
  const Step1({super.key, required this.onNext});

  final Function onNext;

  @override
  State<Step1> createState() => _Step1State();
}

class _Step1State extends State<Step1> {
  String? selectedValue = '...';

  final List<String> items = [
    'Индивидуальные',
    'Можно ПУ',
    'Групповой',
  ];

  @override
  void initState() {
    super.initState();
    selectedValue = items[0];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Тип занятия'.tr(),
            style: TStyle.textStyleVelaSansBold(textColorBlack(context),
                size: 20)),
        const Gap(10),
        DropMenu(
          alignment: Alignment.center,
          items: items,
          onChange: (value) {
            selectedValue = value;
          },
        ),
        const Gap(20),
        InkWell(
          onTap: () {
            widget.onNext.call(selectedValue);
            pageController.animateToPage(1,
                duration: const Duration(milliseconds: 700),
                curve: Curves.ease);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Сохранить и продолжить'.tr(),
                  style: TStyle.textStyleVelaSansBold(colorGreen, size: 16)),
              const Gap(8),
              Icon(
                Icons.arrow_forward_rounded,
                color: colorGreen,
              )
            ],
          ),
        ),
        const Gap(15),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Закрыть'.tr(),
              style: TStyle.textStyleVelaSansMedium(colorRed, size: 16),
            )),
      ],
    );
  }
}

class Step2 extends StatefulWidget {
  const Step2({super.key, required this.lesson});

  final Lesson lesson;

  @override
  State<Step2> createState() => _Step2State();
}

class _Step2State extends State<Step2> {

  final TextEditingController _editingControllerReview = TextEditingController();

  final List<String> itemsStudyes = [
    'Индивидуальные',
    'Можно ПУ',
    'Групповой',
  ];

  final List<String> itemsSubs = [
    'Не выбрано',
    'Абик 1',
    'Абик 2',
    'Абик 3',
  ];

  final List<String> itemsCountLess = [
    '',
    '3',
    '10',
    '5',
  ];

  final List<String> itemsTeacher = [
    'Кристина Евженко',
    'Анастасия Перова',
    'Александр Трапезников',
  ];

  final List<String> itemsDir = [
    'Не выбрано',
    'Вокал',
    'Хор',
    'Гитара',
  ];

  final List<String> itemsDuration = [
    'Не выбрано',
    '30',
    '60',
  ];

  final List<String> itemsTimesStart = [
    'Не выбрано',
    '10:00',
    '11:00',
    '12:00',
    '13:00',
    '14:00',
    '15:00',
    '16:00',
    '17:00',
    '18:00',
    '19:00',
    '20:00',
    '21:00',
    '22:00'
  ];

  final List<String> itemsRemote = [
    'online',
    'offline',
  ];

  final List<String> itemsLocation = [
    'мш1',
    'мш2',
  ];

  final List<String> itemsAuditory = [
    'Не выбрано',
    'Свинг',
    'Авангард',
    'Опера',
    'Блюз',
    'Эстрада'
  ];

  final List<String> itemsClient = [
    'Мананкова Маргарита',
    'Иванов Богдан',
  ];

  final List<String> itemsGroup = [
     'Не выбрано',
    'Группа 1',
    'Группа 2',
    'Группа 3'
  ];

  String selectedValueLesson = '';
  String selectedValueSubs = 'Не выбрано';
  String selectedValueTeacher = '';
  String selectedValueDir = '';
  String selectedValueDur = '';
  String selectedValueTimeStart = '';
  String selectedValueRemote = '';
  String selectedValueLocation = '';
  String selectedValueAuditory = '';
  String selectedValueStudent = '';
  String selectedValueGroup = '';
  String selectedValueDate = '';
  bool errorSubs = false;
  bool errorDir = false;
  bool errorDur = false;
  bool errorTimeStart = false;
  bool errorAuditory = false;
  bool errorGroup = false;

  final double _h1 = 8.0;
  final double _h2 = 15.0;
  late Lesson addedLesson;

  @override
  void initState() {
    super.initState();
    addedLesson = widget.lesson;
    selectedValueLesson = _selectedTypeLesson;
    selectedValueTeacher = widget.lesson.nameTeacher;
    selectedValueLocation = widget.lesson.idSchool;
    selectedValueAuditory = widget.lesson.idAuditory.isEmpty
        ? itemsAuditory[0]
        : widget.lesson.idAuditory;
    selectedValueDate = widget.lesson.date.isEmpty
        ?  DateTime.now().toString().split(' ')[0].tr()
        :  widget.lesson.date;
    selectedValueTimeStart = widget.lesson.timePeriod.isNotEmpty
        ? itemsTimesStart.firstWhere(
            (element) => element == widget.lesson.timePeriod.split('-')[0])
        : '10:00';
    addedLesson = addedLesson.copyWith(nameStudent: itemsClient[0],idStudent: 1,
        date: selectedValueDate);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text('Тип занятия'.tr(),
                  style: TStyle.textStyleVelaSansBold(textColorBlack(context),
                      size: 16)),
            ),
          ),
          Gap(_h1),
          DropMenu(
            items: itemsStudyes,
            selectedValue: selectedValueLesson,
            onChange: (value) {
              setState(() {
                selectedValueLesson = value;
                addedLesson = addedLesson.copyWith(
                    type: selectedValueLesson == itemsStudyes[0]
                        ? LessonType.singly
                        : selectedValueLesson == itemsStudyes[2]
                        ? LessonType.group
                        : selectedValueLesson == itemsStudyes[1]
                        ? LessonType.trial
                        : LessonType.unknown);
              });
            },
          ),

          Visibility(
            visible: addedLesson.type.isSingly,
            child: Column(
              children: [
                Gap(_h2),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text('Клиент'.tr(),
                        style: TStyle.textStyleVelaSansBold(textColorBlack(context),
                            size: 16)),
                  ),
                ),
                Gap(_h1),
                DropMenu(
                  items: itemsClient,
                  onChange: (value) {
                    selectedValueStudent = value;
                    addedLesson =
                        addedLesson.copyWith(idStudent: addedLesson.idStudent,nameStudent: selectedValueStudent);
                  },
                ),
              ],
            ),
          ),
          // InkWell(
          //   onTap: (){
          //     Dialoger.showToast('В разработке');
          //   },
          //   child: Container(
          //     width: MediaQuery.of(context).size.width,
          //     padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          //     decoration:  BoxDecoration(
          //       borderRadius: BorderRadius.circular(50),
          //       border: Border.all(
          //         color: colorGrey,
          //         width: 1.0,
          //       ),
          //     ),
          //     child: Text('Поиск...'.tr(),
          //         style: TStyle.textStyleOpenSansRegular(colorGrey,
          //             size: 14)),
          //   ),
          // ),
          Visibility(
            visible: addedLesson.type.isSingly||addedLesson.type.isGroup,
            child: Column(
              children: [
                Gap(_h2),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text('Абонемент'.tr(),
                        style: TStyle.textStyleVelaSansBold(textColorBlack(context),
                            size: 16)),
                  ),
                ),
                Gap(_h1),
                Row(
                  children: [
                    Expanded(
                      child: DropMenu(
                        items: itemsSubs,
                        onChange: (value) {
                          setState(() {
                            errorSubs = false;
                            selectedValueSubs = value;
                            addedLesson = addedLesson.copyWith(
                                idDir: 1, nameSub: selectedValueSubs);
                          });
                        },
                      ),
                    ),
                    Visibility(
                        visible: errorSubs,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Icon(Icons.error, color: colorRed),
                        ))
                  ],
                ),
                Visibility(
                  visible: selectedValueSubs != 'Не выбрано',
                  child: Column(
                    children: [
                      const Gap(5),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Row(
                            children: [
                              Text('Осталось уроков:'.tr(),
                                  style: TStyle.textStyleVelaSansBold(colorGrey,
                                      size: 12)),
                              const Gap(8),
                              Text(
                                  itemsCountLess[
                                      itemsSubs.indexOf(selectedValueSubs)],
                                  style: TStyle.textStyleVelaSansBold(
                                      textColorBlack(context),
                                      size: 12))
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ).animate().fade(duration: const Duration(milliseconds: 400)),
              ],
            ),
          ),
          Gap(_h2),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text('Преподаватель'.tr(),
                  style: TStyle.textStyleVelaSansBold(textColorBlack(context),
                      size: 16)),
            ),
          ),
          Gap(_h1),
          DropMenu(
            selectedValue: selectedValueTeacher,
            items: itemsTeacher,
            onChange: (value) {
              selectedValueTeacher = value;
              addedLesson = addedLesson.copyWith(
                  idTeacher: 1, nameTeacher: selectedValueTeacher);
            },
          ),
          Visibility(
            visible: addedLesson.type.isSingly||addedLesson.type.isGroup,
            child: Column(
              children: [
                Gap(_h2),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text('Направление'.tr(),
                        style: TStyle.textStyleVelaSansBold(textColorBlack(context),
                            size: 16)),
                  ),
                ),
                Gap(_h1),
                Row(
                  children: [
                    Expanded(
                      child: DropMenu(
                        items: itemsDir,
                        onChange: (value) {
                          setState(() {
                            errorDir = false;
                            selectedValueDir = value;
                            addedLesson = addedLesson.copyWith(
                                idDir: 1, nameDirection: selectedValueDir);
                          });
                        },
                      ),
                    ),
                    Visibility(
                        visible: errorDir,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Icon(Icons.error, color: colorRed),
                        ))
                  ],
                ),
              ],
            ),
          ),
          Visibility(
            visible: addedLesson.type.isGroup,
            child: Column(
              children: [
                Gap(_h2),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text('Группа'.tr(),
                        style: TStyle.textStyleVelaSansBold(textColorBlack(context),
                            size: 16)),
                  ),
                ),
                Gap(_h1),
                Row(
                  children: [
                    Expanded(
                      child: DropMenu(
                        items: itemsGroup,
                        onChange: (value) {
                         setState(() {
                           errorGroup = false;
                           selectedValueGroup = value;
                           addedLesson =
                               addedLesson.copyWith(nameGroup: selectedValueGroup);
                         });
                        },
                      ),
                    ),
                    Visibility(
                        visible: errorGroup,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Icon(Icons.error, color: colorRed),
                        ))

                  ],
                ),
              ],
            ),
          ),
          Gap(_h2),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text('Длительность'.tr(),
                  style: TStyle.textStyleVelaSansBold(textColorBlack(context),
                      size: 16)),
            ),
          ),
          Gap(_h1),
          Row(
            children: [
              Expanded(
                child: DropMenu(
                  items: itemsDuration,
                  onChange: (value) {
                    setState(() {
                      errorDur = false;
                      selectedValueDur = value;
                      addedLesson = addedLesson.copyWith(
                          duration: int.parse(selectedValueDur),
                          timePeriod: timeToLesson());
                    });
                  },
                ),
              ),
              Visibility(
                  visible: errorDur,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Icon(Icons.error, color: colorRed),
                  ))
            ],
          ),
          Gap(_h2),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text('Дата и время начала'.tr(),
                  style: TStyle.textStyleVelaSansBold(textColorBlack(context),
                      size: 16)),
            ),
          ),
          Gap(_h1),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    Dialoger.showSelectDate(
                        context: context,
                        lessons: [],
                        onDate: (String date) {
                          setState(() {
                            selectedValueDate = date;
                            addedLesson = addedLesson.copyWith(date: date);
                          });
                        });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: colorGrey,
                        width: 1.0,
                      ),
                    ),
                    child: Text(DateTimeParser.getDateFromApi(date:selectedValueDate),
                        style: TStyle.textStyleOpenSansRegular(colorGrey,
                            size: 14)),
                  ),
                ),
              ),
              const Gap(10),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: DropMenu(
                        widthDrop: 100,
                        selectedValue: selectedValueTimeStart,
                        items: itemsTimesStart,
                        onChange: (value) {
                          setState(() {
                            selectedValueTimeStart = value;
                            errorTimeStart = false;
                            if (selectedValueDur.isNotEmpty) {
                              addedLesson = addedLesson.copyWith(
                                  timePeriod: timeToLesson());
                            }
                          });
                        },
                      ),
                    ),
                    Visibility(
                        visible: errorTimeStart,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Icon(Icons.error, color: colorRed),
                        ))
                  ],
                ),
              ),
            ],
          ),

          Visibility(
            visible: addedLesson.type.isSingly,
            child: Column(
              children: [
                Gap(_h2),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text('Тип проведения занятия'.tr(),
                        style: TStyle.textStyleVelaSansBold(textColorBlack(context),
                            size: 16)),
                  ),
                ),
                Gap(_h1),
                DropMenu(
                  selectedValue: itemsRemote[1],
                  items: itemsRemote,
                  onChange: (value) {
                    selectedValueRemote = value;
                    addedLesson = addedLesson.copyWith(
                        online: selectedValueRemote == 'online' ? true : false);
                  },
                ),
              ],
            ),
          ),

          Gap(_h2),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text('Локация'.tr(),
                  style: TStyle.textStyleVelaSansBold(textColorBlack(context),
                      size: 16)),
            ),
          ),
          Gap(_h1),
          DropMenu(
            selectedValue: selectedValueLocation,
            items: itemsLocation,
            onChange: (value) {
              selectedValueLocation = value;
              addedLesson = addedLesson.copyWith(idSchool: selectedValueLocation);
            },
          ),

          Gap(_h2),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text('Аудитория'.tr(),
                  style: TStyle.textStyleVelaSansBold(textColorBlack(context),
                      size: 16)),
            ),
          ),
          Gap(_h1),
          Row(
            children: [
              Expanded(
                child: DropMenu(
                  selectedValue: selectedValueAuditory,
                  items: itemsAuditory,
                  onChange: (value) {
                    setState(() {
                      errorAuditory = false;
                      selectedValueAuditory = value;
                      addedLesson = addedLesson.copyWith(idAuditory: selectedValueAuditory);
                    });
                  },
                ),
              ),
              Visibility(
                  visible: errorAuditory,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Icon(Icons.error, color: colorRed),
                  ))
            ],
          ),

          Gap(_h2),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text('Комментарий'.tr(),
                  style: TStyle.textStyleVelaSansBold(textColorBlack(context),
                      size: 16)),
            ),
          ),
          Gap(_h1),
          TextField(
            maxLines: 3,
            textAlign: TextAlign.start,
            controller: _editingControllerReview,
            style: TextStyle(
                color: Theme.of(context).textTheme.displayMedium!.color!),
            cursorColor: colorBeruza,
            decoration: InputDecoration(
                filled: true,
                fillColor: Theme.of(context).colorScheme.background,
                hintText: 'Ваш комментарий'.tr(),
                hintStyle:
                    TStyle.textStyleVelaSansMedium(colorGrey.withOpacity(0.4)),
                contentPadding: const EdgeInsets.only(
                    left: 20, right: 20, top: 12, bottom: 12),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: colorGrey,
                    width: 1.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: colorBeruza,
                    width: 1.0,
                  ),
                )),
          ),

          const Gap(30),

          SizedBox(
            height: 35.0,
            child: SubmitButton(
              colorFill: colorGreen,
              onTap: () {
                if (!_checkData()) {
                  return;
                }
                addedLesson = addedLesson.copyWith(status: LessonStatus.planned);
                Dialoger.showCustomDialog(
                    args: addedLesson,
                    contextUp: context,
                    content: AddNewLesson());
              },
              borderRadius: 10.0,
              textButton: 'Сохранить'.tr(),
            ),
          ),
          const Gap(5),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Закрыть'.tr(),
                style: TStyle.textStyleVelaSansMedium(colorRed, size: 16),
              )),
        ],
      ),
    );
  }

  String timeToLesson() {
    int duration = int.parse(selectedValueDur);
    if (duration == 30) {
      final h = selectedValueTimeStart.split(':')[0];
      return '$selectedValueTimeStart-$h:${duration.toString()}';
    } else {
      final h = int.parse(selectedValueTimeStart.split(':')[0]);
      return '$selectedValueTimeStart-${h + 1}:00';
    }
  }




  bool _checkData() {
    bool res = true;

    if(_editingControllerReview.text.isNotEmpty){
      addedLesson = addedLesson.copyWith(comments: _editingControllerReview.text);
    }

    if (addedLesson.type.isGroup) {
      if (selectedValueGroup == 'Не выбрано' || selectedValueGroup.isEmpty) {
            setState(() {
              errorGroup = true;
              res = false;
            });
          }
    }

    if (selectedValueSubs == 'Не выбрано' || selectedValueSubs.isEmpty) {
      if(addedLesson.type.isSingly||addedLesson.type.isGroup){
        setState(() {
          errorSubs = true;
          res = false;
        });
      }

    }

    if (selectedValueDir.isEmpty || selectedValueDir == 'Не выбрано') {
      setState(() {

        if (addedLesson.type.isSingly||addedLesson.type.isGroup) {
          errorDir = true;
          res = false;
        }
      });
    }
    if (selectedValueDur.isEmpty) {
      setState(() {
        errorDur = true;
        res = false;
      });
    }
    if (selectedValueTimeStart.isEmpty ||
        selectedValueTimeStart == 'Не выбрано') {
      setState(() {
        errorTimeStart = true;
        res = false;
      });
    }

    if (selectedValueAuditory.isEmpty) {
      setState(() {
        errorAuditory = true;
        res = false;
      });
    }

    if (!res) {
      Dialoger.showToast('Не все данные заполненны'.tr());
    }

    return res;
  }
}
