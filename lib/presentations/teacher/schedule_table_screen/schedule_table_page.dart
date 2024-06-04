import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:time_planner/time_planner.dart';
import 'package:virtuozy/components/box_info.dart';
import 'package:virtuozy/components/dialogs/sealeds.dart';
import 'package:virtuozy/components/select_auditory_menu.dart';
import 'package:virtuozy/components/table_mode_menu.dart';
import 'package:virtuozy/domain/entities/lesson_entity.dart';
import 'package:virtuozy/domain/entities/table_tap_location_entity.dart';
import 'package:virtuozy/presentations/teacher/schedule_table_screen/table/my_time_planner.dart';
import 'package:virtuozy/resourses/colors.dart';
import 'package:virtuozy/utils/status_to_color.dart';


import '../../../components/calendar_caller.dart';
import '../../../components/date_page_table.dart';
import '../../../components/dialogs/dialoger.dart';
import '../../../components/select_school_menu.dart';
import '../../../di/locator.dart';
import '../../../utils/text_style.dart';
import '../../../utils/theme_provider.dart';

import 'bloc/table_bloc.dart';
import 'bloc/table_event.dart';
import 'bloc/table_state.dart';

class ScheduleTablePage extends StatefulWidget {
  const ScheduleTablePage({super.key});

  @override
  State<ScheduleTablePage> createState() => _ScheduleTablePageState();
}

class _ScheduleTablePageState extends State<ScheduleTablePage> {
  final themeProvider = locator.get<ThemeProvider>();

  @override
  void initState() {
    super.initState();
    context.read<TableBloc>().add(const GetInitLessonsEvent(weekMode: false));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TableBloc, TableState>(
        listener: (c, s) {},
        builder: (context, state) {
          if (state.scheduleStatus == ScheduleStatus.loading) {
            return Center(child: CircularProgressIndicator(color: colorOrange));
          }

          if (state.scheduleStatus == ScheduleStatus.error) {
            return const BoxInfo(
                title: 'Ошибка получения данных', iconData: Icons.error);
          }

          return Scaffold(
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add,color: colorWhite),
              onPressed: (){
                Dialoger.showModalBottomMenu(
                    blurred: true,
                    title: 'Добавить урок'.tr(), content: AddLesson());
              },
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0, top: 10.0),
                  child: SizedBox(
                    height: 30.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SelectSchoolMenu(
                          key: ValueKey(state.idsSchool),
                          loading: state.status == TableStatus.loading,
                          currentIdSchool: state.currentIdSchool,
                          idsSchool: state.idsSchool,
                          onChange: (id) {
                            context
                                .read<TableBloc>()
                                .add(GetLessonsTableByIdSchool(id: id));
                          },
                        ),
                        const Gap(10.0),
                        DatePageTable(
                            dateSelect: (date) {
                              context.read<TableBloc>().add(
                                  GetLessonsTableByCalendarDateEvent(
                                      date: date,
                                      weekMode:
                                      state.modeTable == ViewModeTable.week));
                            },
                            lessons: state.lessons,
                          onChange: (index) {
                            context.read<TableBloc>().add(GetLessonsTableByDate(
                                indexDate: index,
                                weekMode: state.modeTable == ViewModeTable.week));
                          },
                          initIndex: state.indexByDateNow,
                          lessonsToday: state.todayLessons,
                        ),
                        const Gap(10.0),
                        TableModeMenu(
                           modeView: (ViewModeTable mode) {
                             if (mode == ViewModeTable.week) {
                               context
                                   .read<TableBloc>()
                                   .add(const GetLessonsTableWeek(weekMode: true));
                             } else if (mode == ViewModeTable.day) {
                               context
                                   .read<TableBloc>()
                                   .add(const GetInitLessonsEvent(weekMode: false));
                             } else {
                               context
                                   .read<TableBloc>()
                                   .add(const GetInitLessonsEvent(weekMode: false));
                             }
                           }
                       )
                      ],
                    ),
                  ),
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(visible: false, child: SelectAuditoryMenu()),
                  ],
                ),
                const Gap(10.0),
                if (state.status == TableStatus.loading) ...{
                  Expanded(
                    child: Center(
                        child: CircularProgressIndicator(color: colorOrange)),
                  )
                } else if (state.status == TableStatus.loaded) ...{
                  Expanded(
                    child: MyTimePlanner(
                      onTapTable: (TableTapLocation locTap){
                        print('TAP x = ${locTap.x} y = ${locTap.y}');
                      },
                      colorDividerVertical:
                          themeProvider.themeStatus == ThemeStatus.dark
                              ? colorGrey
                              : Colors.black12,
                      colorDividerHorizontal: colorGrey,
                      modeView: (ViewModeTable mode) {
                        if (mode == ViewModeTable.week) {
                          context
                              .read<TableBloc>()
                              .add(const GetLessonsTableWeek(weekMode: true));
                        } else if (mode == ViewModeTable.day) {
                          context
                              .read<TableBloc>()
                              .add(const GetInitLessonsEvent(weekMode: false));
                        } else {
                          context
                              .read<TableBloc>()
                              .add(const GetInitLessonsEvent(weekMode: false));
                        }
                      },
                      startHour: 10,
                      endHour: 21,
                      use24HourFormat: true,
                      setTimeOnAxis: false,
                      headers: [
                        ...List.generate(state.titles.length, (index) {
                          return TimePlannerTitle(
                            date: state.titles[index].date.isEmpty?
                            index.toString():state.titles[index].date,
                            title: state.titles[index].title,
                            titleStyle: TStyle.textStyleVelaSansBold(
                                Theme.of(context).textTheme.displayMedium!.color!,
                                size: 14.0),
                          );
                        })
                      ],
                      // List of task will be show on the time planner
                      tasks: [
                        ...List.generate(state.tasks.length, (index) {
                          return TimePlannerTask(
                            color: StatusToColor.getColor(
                                lessonStatus: state.tasks[index].lesson.status),
                            dateTime: state.tasks[index].timePlannerDateTime,
                            minutesDuration: 60,
                            daysDuration: 1,
                            onTap: () {
                              Dialoger.showModalBottomMenu(
                                  blurred: true,
                                  title: 'Информация об уроке'.tr(),
                                  args: state.tasks[index].lesson,
                                  content: InfoStatusLesson(
                              ));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(7.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Text(
                                        state.tasks[index].lesson.nameStudent,
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TStyle.textStyleVelaSansBold(
                                            state.tasks[index].lesson.status ==
                                                        LessonStatus.complete ||
                                                    state.tasks[index].lesson
                                                            .status ==
                                                        LessonStatus
                                                            .reservation ||
                                                    state.tasks[index].lesson
                                                            .status ==
                                                        LessonStatus.planned
                                                ? colorBlack
                                                : Theme.of(context)
                                                    .textTheme
                                                    .displayMedium!
                                                    .color!,
                                            size: 12.0)),
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Icon(Icons.directions,
                                          color: state.tasks[index].lesson
                                                          .status ==
                                                      LessonStatus.complete ||
                                                  state.tasks[index].lesson
                                                          .status ==
                                                      LessonStatus.reservation ||
                                                  state.tasks[index].lesson
                                                          .status ==
                                                      LessonStatus.planned
                                              ? colorBlack
                                              : Theme.of(context)
                                                  .textTheme
                                                  .displayMedium!
                                                  .color!,
                                          size: 10.0),
                                      const Gap(3),
                                      Expanded(
                                        child: Text(
                                            state.tasks[index].lesson
                                                .nameDirection,
                                            overflow: TextOverflow.ellipsis,
                                            style: TStyle.textStyleVelaSansMedium(
                                                state.tasks[index].lesson
                                                                .status ==
                                                            LessonStatus
                                                                .complete ||
                                                        state.tasks[index].lesson
                                                                .status ==
                                                            LessonStatus
                                                                .reservation ||
                                                        state.tasks[index].lesson
                                                                .status ==
                                                            LessonStatus.planned
                                                    ? colorBlack
                                                    : Theme.of(context)
                                                        .textTheme
                                                        .displayMedium!
                                                        .color!,
                                                size: 12.0)),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        })
                      ],
                      style: TimePlannerStyle(
                        //backgroundColor: Theme.of(context).colorScheme.background,
                        dividerColor:
                            themeProvider.themeStatus == ThemeStatus.dark
                                ? colorGrey
                                : Colors.black,
                        interstitialEvenColor:
                            themeProvider.themeStatus == ThemeStatus.dark
                                ? Theme.of(context).colorScheme.surfaceVariant
                                : Colors.grey[50],
                        interstitialOddColor:
                            themeProvider.themeStatus == ThemeStatus.dark
                                ? Theme.of(context).colorScheme.background
                                : Colors.grey[200],
                        showScrollBar: true,
                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                      ),
                    ),
                  )
                }
              ],
            ).animate().fade(duration: const Duration(milliseconds: 400)),
          );
        });
  }
}
