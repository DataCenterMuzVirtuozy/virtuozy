import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:virtuozy/components/drop_menu.dart';

import '../../../../resourses/colors.dart';
import '../../../../utils/text_style.dart';
import '../../../buttons.dart';
import '../../dialoger.dart';

String _selectedTypeLesson = '';
PageController pageController = PageController();

class AddLessonContent extends StatefulWidget {
  const AddLessonContent({super.key});

  @override
  State<AddLessonContent> createState() => _AddLessonContentState();
}

class _AddLessonContentState extends State<AddLessonContent> {
  final List<double> _heightBody = [200.0, 800.0];
  int _stepIndex = 0;

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
                  });
                },
              ),
               Step2(
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
    'Не выбрано',
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
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text('Тип занятия'.tr(),
                style: TStyle.textStyleVelaSansBold(textColorBlack(context),
                    size: 20)),
          ),
        ),
        const Gap(10),
        DropMenu(
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
  const Step2({super.key});

  @override
  State<Step2> createState() => _Step2State();
}

class _Step2State extends State<Step2> {
  final List<String> itemsStudyes = [
    'Не выбрано',
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

  final List<String> itemsTeacher = [
    'Не выбрано',
    'Вася Пупкин',
    'Петя Иванов',
    'Анатолий Петров',
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
    'Не выбрано',
    'online',
    'offline',
  ];

  final List<String> itemsLocation = [
    'Не выбрано',
    'мш1',
    'мш2',
  ];

  final List<String> itemsAuditory = [
    'Не выбрано',
    'Опера',
    'Классика',
    'Авангард',
    'Шансонье',
  ];


  String selectedValueLesson = '...';
  String selectedValueSubs = '...';
  String selectedValueTeacher = '...';
  String selectedValueDir = '...';
  String selectedValueDur = '...';
  String selectedValueTimeStart = '...';
  String selectedValueRemote = '...';
  String selectedValueLocation = '...';
  String selectedValueAuditory = '...';

  final double _h1 = 8.0;
  final double _h2 = 15.0;

  @override
  void initState() {
    super.initState();
    selectedValueLesson = _selectedTypeLesson;
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
              selectedValueLesson = value;
            },
          ),
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
          InkWell(
            onTap: (){
              Dialoger.showToast('В разработке');
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
              decoration:  BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: colorGrey,
                  width: 1.0,
                ),
              ),
              child: Text('Поиск...'.tr(),
                  style: TStyle.textStyleOpenSansRegular(colorGrey,
                      size: 14)),
            ),
          ),
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
          DropMenu(
            items: itemsSubs,
            onChange: (value) {
              selectedValueSubs = value;
            },
          ),
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
                  Text('20',
                      style: TStyle.textStyleVelaSansBold(textColorBlack(context),
                          size: 12))
                ],
              ),
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
            items: itemsTeacher,
            onChange: (value) {
              selectedValueTeacher = value;
            },
          ),
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
          DropMenu(
            items: itemsDir,
            onChange: (value) {
              selectedValueDir = value;
            },
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
          DropMenu(
            items: itemsDuration,
            onChange: (value) {
              selectedValueDur = value;
            },
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
                  onTap: (){
                    Dialoger.showSelectDate(context: context, lessons: [],
                        onDate: (String date){

                        });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                    decoration:  BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: colorGrey,
                        width: 1.0,
                      ),
                    ),
                    child: Text(DateTime.now().toString().split(' ')[0].tr(),
                        style: TStyle.textStyleOpenSansRegular(colorGrey,
                            size: 14)),
                  ),
                ),
              ),
              const Gap(10),
              Expanded(
                child: DropMenu(
                  widthDrop: 100,
                  items: itemsTimesStart,
                  onChange: (value) {
                    selectedValueTimeStart = value;
                  },
                ),
              ),
            ],
          ),

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
            items: itemsRemote,
            onChange: (value) {
              selectedValueRemote = value;
            },
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
            items: itemsLocation,
            onChange: (value) {
              selectedValueLocation = value;
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
          DropMenu(
            items: itemsAuditory,
            onChange: (value) {
              selectedValueAuditory = value;
            },
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
            //controller: _editingControllerReview,
            style: TextStyle(
                color:
                Theme.of(context).textTheme.displayMedium!.color!),
            cursorColor: colorBeruza,
            decoration: InputDecoration(
                filled: true,
                fillColor: Theme.of(context).colorScheme.background,
                hintText: 'Ваш комментарий'.tr(),
                hintStyle: TStyle.textStyleVelaSansMedium(
                    colorGrey.withOpacity(0.4)),
                contentPadding: const EdgeInsets.only(
                    left: 20, right: 20, top: 12, bottom: 12),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: colorGrey ,
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
            height: 40.0,
            child: SubmitButton(
              colorFill: colorGreen,
              onTap: () {},
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
}
