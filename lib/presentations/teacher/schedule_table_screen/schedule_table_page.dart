



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:time_planner/time_planner.dart';
import 'package:virtuozy/components/select_auditory_menu.dart';
import 'package:virtuozy/domain/entities/lesson_entity.dart';
import 'package:virtuozy/presentations/teacher/schedule_table_screen/table/my_time_planner.dart';
import 'package:virtuozy/resourses/colors.dart';
import 'package:virtuozy/utils/status_to_color.dart';

import '../../../components/calendar_caller.dart';
import '../../../components/date_page_view.dart';
import '../../../components/select_school_menu.dart';
import '../../../utils/text_style.dart';

class ScheduleTablePage extends StatefulWidget{
  const ScheduleTablePage({super.key});

  @override
  State<ScheduleTablePage> createState() => _ScheduleTablePageState();
}

class _ScheduleTablePageState extends State<ScheduleTablePage> {
 late List<TimePlannerTask> tasks;


  @override
  void initState() {
    super.initState();

  }


 @override
  void didChangeDependencies() {
   super.didChangeDependencies();
   tasks = [
     TimePlannerTask(
       // background color for task
       color: StatusToColor.getColor(lessonStatus: LessonStatus.trial),
       // day: Index of header, hour: Task will be begin at this hour
       // minutes: Task will be begin at this minutes
       dateTime: TimePlannerDateTime(day: 0, hour: 14, minutes: 00),
       // Minutes duration of task
       minutesDuration: 60,
       // Days duration of task (use for multi days task)
       daysDuration: 1,
       onTap: () {},
       child: Text(
           'Сидоров Иван Петрович',
           textAlign: TextAlign.center,
           style:
           TStyle.textStyleVelaSansRegular(Theme.of(context)
               .textTheme.displayMedium!.color!,size: 14.0)),
     ),
     TimePlannerTask(
       // background color for task
       color: StatusToColor.getColor(lessonStatus: LessonStatus.cancel),
       // day: Index of header, hour: Task will be begin at this hour
       // minutes: Task will be begin at this minutes
       dateTime: TimePlannerDateTime(day: 3, hour: 10, minutes: 00),
       // Minutes duration of task
       minutesDuration: 60,
       // Days duration of task (use for multi days task)
       daysDuration: 1,
       onTap: () {},
       child: Text(
           'Сидоров Иван Петрович',
           textAlign: TextAlign.center,
           style:
           TStyle.textStyleVelaSansRegular(Theme.of(context)
               .textTheme.displayMedium!.color!,size: 14.0)),
     ),
     TimePlannerTask(
       // background color for task
       color: StatusToColor.getColor(lessonStatus: LessonStatus.complete),
       // day: Index of header, hour: Task will be begin at this hour
       // minutes: Task will be begin at this minutes
       dateTime: TimePlannerDateTime(day: 2, hour: 17, minutes: 00),
       // Minutes duration of task
       minutesDuration: 60,
       // Days duration of task (use for multi days task)
       daysDuration: 1,
       onTap: () {},
       child: Text(
           'Сидоров Иван Петрович',
           textAlign: TextAlign.center,
           style:
           TStyle.textStyleVelaSansRegular(Theme.of(context)
               .textTheme.displayMedium!.color!,size: 14.0)),
     ),
   ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 10.0,top: 10.0),
          child: SizedBox(
            height: 30.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DatePageView(),
                Gap(20.0),
                CalendarCaller(lessons: [Lesson(
                  contactValues: [],
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
                    nameDirection: '')])
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 30.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SelectSchoolMenu(),
              Gap(20.0),
              SelectAuditoryMenu(),
            ],
          ),
        ),
        const Gap(10.0),
        Expanded(
          child: MyTimePlanner(
            // time will be start at this hour on table
            startHour: 10,
            // time will be end at this hour on table
            endHour: 21,
            use24HourFormat: true,
            setTimeOnAxis: false,
            // each header is a column and a day
            headers: [
              TimePlannerTitle(
                date: "3",
                title: "Пн",
                titleStyle:  TStyle.textStyleVelaSansBold(Theme.of(context)
                    .textTheme.displayMedium!.color!,size: 14.0),
              ),
              TimePlannerTitle(
                date: "4",
                title: "Вт",
                titleStyle:  TStyle.textStyleVelaSansBold(Theme.of(context)
                    .textTheme.displayMedium!.color!,size: 14.0),
              ),
              TimePlannerTitle(
                date: "5",
                title: "Ср",
                titleStyle:  TStyle.textStyleVelaSansBold(Theme.of(context)
                    .textTheme.displayMedium!.color!,size: 14.0),
              ),
              TimePlannerTitle(
                date: "6",
                title: "Чт",
                titleStyle:  TStyle.textStyleVelaSansBold(Theme.of(context)
                    .textTheme.displayMedium!.color!,size: 14.0),
              ),
              TimePlannerTitle(
                date: "7",
                title: "Пт",
                titleStyle:  TStyle.textStyleVelaSansBold(Theme.of(context)
                    .textTheme.displayMedium!.color!,size: 14.0),
              ),
              TimePlannerTitle(
                date: "8",
                title: "Сб",
                titleStyle:  TStyle.textStyleVelaSansBold(Theme.of(context)
                    .textTheme.displayMedium!.color!,size: 14.0),
              ),
              TimePlannerTitle(
                date: "9",
                title: "Вс",
                titleStyle:  TStyle.textStyleVelaSansBold(Theme.of(context)
                    .textTheme.displayMedium!.color!,size: 14.0),
              ),
            ],
            // List of task will be show on the time planner
            tasks: tasks,
            style: TimePlannerStyle(
              backgroundColor: Theme.of(context).colorScheme.background,
              //cellHeight: 60,
              //cellWidth: 60,
              dividerColor: Colors.black,
              interstitialEvenColor: Colors.grey[50],
              interstitialOddColor: Colors.grey[200],
              showScrollBar: true,
              //horizontalTaskPadding: 5,
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
          ),
        ),
      ],
    );
  }
}