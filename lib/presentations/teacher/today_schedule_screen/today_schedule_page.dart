




  import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:virtuozy/domain/entities/lesson_entity.dart';
import 'package:virtuozy/presentations/teacher/today_schedule_screen/timeline_schedule.dart';

import '../../../components/buttons.dart';
import '../../../components/dialogs/dialoger.dart';
import '../../../resourses/colors.dart';
import '../../../utils/text_style.dart';

class TodaySchedulePage extends StatefulWidget{
  const TodaySchedulePage({super.key});

  @override
  State<TodaySchedulePage> createState() => _TodaySchedulePageState();
}

class _TodaySchedulePageState extends State<TodaySchedulePage> {


  late PageController _pageController1;
  late PageController _pageController2;


  @override
  void initState() {
    super.initState();
    _pageController1 = PageController(initialPage: 0);
    _pageController2 = PageController(initialPage: 0);
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
    Padding(
    padding: const EdgeInsets.only(left: 20.0,bottom: 10.0,top: 20.0),
    child: Text('Мое расписание на сегодня'.tr()
        ,style: TStyle.textStyleGaretHeavy(Theme.of(context)
            .textTheme.displayMedium!.color!,size: 18.0))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 20.0),
          child: SizedBox(
            height: 40.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SelectSchoolMenu(),
                Container(
                  alignment: Alignment.center,
                    width: 200.0,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Flex(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      direction: Axis.horizontal,
                      children: [
                        Flexible(
                            flex: 1,
                            child: IconButton(
                                onPressed: () {
                                  // _pageController1.nextPage(duration: const Duration(milliseconds: 700), curve: Curves.easeIn);
                                  // _pageController2.animateToPage(1,duration: const Duration(milliseconds: 700), curve: Curves.easeIn);
                                },
                                icon: Icon(
                                  Icons.arrow_back_ios_rounded,
                                  size: 16,
                                  color: Theme.of(context)
                                      .textTheme
                                      .displayMedium!
                                      .color!,
                                ))),
                        Flexible(
                          flex: 2,
                          child: SizedBox(
                           height: 20.0,
                            child: PageView(
                              physics: const NeverScrollableScrollPhysics(),
                              controller: _pageController1,
                              children: [
                              Text('8 ноя. 2023',
                              textAlign: TextAlign.center,
                              style:TStyle.textStyleVelaSansExtraBolt(Theme.of(context)
                                  .textTheme.displayMedium!.color!,size: 13.0)),
                                Text('9 ноя. 2023',
                                    style:TStyle.textStyleVelaSansExtraBolt(Theme.of(context)
                                        .textTheme.displayMedium!.color!,size: 13.0)),
                                Text('10 ноя. 2023',
                                    style:TStyle.textStyleVelaSansExtraBolt(Theme.of(context)
                                        .textTheme.displayMedium!.color!,size: 13.0))
                              ],
                            ),
                          ),
                        ),
                        Flexible(
                            flex: 1,
                            child: IconButton(onPressed: (){
                              _pageController1.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeIn);
                              _pageController2.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeIn);
                            },
                                icon:  Icon(Icons.arrow_forward_ios_rounded,
                                size: 16,
                                color: Theme.of(context)
                                    .textTheme.displayMedium!.color!,))),
                      ],
                    )),

                Container(
                  padding: const EdgeInsets.all(2.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Theme.of(context).colorScheme.surfaceVariant,
                  ),
                  child: IconButton(onPressed: () {
                    Dialoger.showSelectDate(context: context, lessons: [
                      const Lesson(
                            id: 1,
                            idSub: 1,
                            idSchool: '',
                            bonus: false,
                            timeAccept: '',
                            date: '2024-03-12',
                            timePeriod: '11:00-12:00',
                            idAuditory: '',
                            nameTeacher: '',
                            nameStudent: '',
                            status: LessonStatus.trial,
                            nameDirection: '')
                      ]);
                  },
                  icon: Icon(Icons.calendar_month,color: Theme.of(context)
                      .textTheme.displayMedium!.color!,size: 18,),),
                )
              ],
            ),
          ),
        ),
        Expanded(child: PageView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          controller: _pageController2,
          itemBuilder: (BuildContext context, int index) {
            return TimelineSchedule();
        },
        )),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 40.0),
          child: SizedBox(
            height: 40.0,
            child: SubmitButton(
              onTap: (){

                // Dialoger.showModalBottomMenu(
                //     blurred: false,
                //     args:[state.firstNotAcceptLesson,
                //       state.directions, state.listNotAcceptLesson,
                //       _allViewDirection],
                //     title:'Подтверждение урока'.tr(),
                //     content: ConfirmLesson());
              },
              //colorFill: Theme.of(context).colorScheme.tertiary,
              colorFill: colorGreen,
              borderRadius: 10.0,
              textButton:
              'Подтвердите прохождение урока'.tr(),
            ),
          ),
        )
      ],
    );
  }


}


class SelectSchoolMenu extends StatefulWidget{
   const SelectSchoolMenu({super.key});

  @override
  State<SelectSchoolMenu> createState() => _SelectSchoolMenuState();
}

class _SelectSchoolMenuState extends State<SelectSchoolMenu> {
  final List<String> items = [
    'мш1',
    'мш2',
    'мш3',
  ];

  String? selectedValue;


  @override
  void initState() {
    super.initState();
    selectedValue = items[0];
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        hint:  Text(selectedValue!,
            textAlign: TextAlign.center,
            style:TStyle.textStyleVelaSansExtraBolt(Theme.of(context)
                .textTheme.displayMedium!.color!,size: 13.0)),
        items: items
            .map((String item) => DropdownMenuItem<String>(
          value: item,
          child: Text(
            item,
            style: TStyle.textStyleVelaSansExtraBolt(Theme.of(context)
                .textTheme.displayMedium!.color!,size: 13.0),
            overflow: TextOverflow.ellipsis,
          ),
        ))
            .toList(),
        value: selectedValue,
        onChanged: (value) {
          setState(() {
            selectedValue = value;
          });
        },
        buttonStyleData: ButtonStyleData(
          width: 75,
          padding:const EdgeInsets.symmetric(horizontal: 13.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color:Theme.of(context).colorScheme.surfaceVariant,
          ),
          //elevation: 2,
        ),
        iconStyleData:  IconStyleData(
          icon: const Icon(
            Icons.arrow_drop_down_rounded,
          ),
          iconSize: 18,
          iconEnabledColor: colorGrey,
          iconDisabledColor: Theme.of(context)
              .textTheme.displayMedium!.color!,
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 300,
          width: 75,
          elevation: 0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: colorGrey,
          ),
          offset: const Offset(0,-10),
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(40),
            thickness: MaterialStateProperty.all(6),
            thumbVisibility: MaterialStateProperty.all(true),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
          padding: EdgeInsets.only(left: 14, right: 14),
        ),
      ),
    );
  }
}