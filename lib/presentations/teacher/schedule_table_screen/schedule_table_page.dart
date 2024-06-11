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
import 'package:virtuozy/utils/auth_mixin.dart';
import 'package:virtuozy/utils/date_time_parser.dart';
import 'package:virtuozy/utils/status_to_color.dart';

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

class _ScheduleTablePageState extends State<ScheduleTablePage> with AuthMixin{
  final themeProvider = locator.get<ThemeProvider>();
  final List<String> _times = [
    '10:00-11:00',
    '11:00-12:00',
    '12:00-13:00',
    '13:00-14:00',
    '14:00-15:00',
    '15:00-16:00',
    '16:00-17:00',
    '17:00-18:00',
    '18:00-19:00',
    '19:00-20:00',
    '20:00-21:00',
    '21:00-22:00',
  ];
  String _dateCurrent = '';
  int _changeIndexDate = -1 ;
  ViewModeTable _modeTable = ViewModeTable.day;

  @override
  void initState() {
    super.initState();
    _dateCurrent =  DateTime.now().toString().split(' ')[0];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<TableBloc>().add( GetInitLessonsEvent(viewMode: ViewModeTable.day,date: _dateCurrent,scrollPage: false));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TableBloc, TableState>(
        listener: (c, s) {
          if(_changeIndexDate<0){
            _changeIndexDate = s.indexByDateNow;
          }

           if(s.addLessonStatus == AddLessonStatus.error){
             Dialoger.showToast('Ошибка добавления урока'.tr());
           }

          if(s.addLessonStatus == AddLessonStatus.success){
            Dialoger.showToast('Урок успешно добавлен'.tr());
          }

          if(s.editLessonStatus == EditLessonStatus.error){
            Dialoger.showToast('Ошибка редактирования урока'.tr());
          }

          if(s.editLessonStatus == EditLessonStatus.success){
            Dialoger.showToast('Статус урока изменен'.tr());
          }




        },
        builder: (context, state) {


          if (state.scheduleStatus == ScheduleStatus.error) {
            return const BoxInfo(
                title: 'Ошибка получения данных', iconData: Icons.error);
          }
         print('Index ${state.indexByDateNow}');

          return Scaffold(
            floatingActionButton: FloatingActionButton(
              mini: true,
              child: Icon(Icons.add, color: colorWhite),
              onPressed: () {
                Dialoger.showModalBottomMenu(
                    blurred: true,
                    args: _addLesson(
                      idSchool: state.currentIdSchool,
                        nameTeacher: '${teacher.firstName} ${teacher.lastName}',
                        idTeacher: teacher.id,
                        timePeriod: '',
                        dateDay: _dateCurrent,
                        idAuditory:''),
                    title: 'Добавить урок'.tr(),
                    content: AddLesson());
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
                          loading: state.status == TableStatus.loading,
                          currentIdSchool: state.currentIdSchool,
                          idsSchool: state.idsSchool.isEmpty?['...']:state.idsSchool,
                          onChange: (id) {
                            context
                                .read<TableBloc>()
                                .add(GetLessonsTableByIdSchool(id: id));
                          },
                        ),
                        const Gap(10.0),
                        DatePageTable(
                          key: ValueKey(_modeTable),
                          dateSelect: (date) {
                            if(_dateCurrent != date){
                              _dateCurrent = date;
                              context.read<TableBloc>().add(
                                  GetLessonsTableByCalendarDateEvent(
                                      date: date,
                                       viewMode: state.modeTable));
                            }

                          },
                          lessons: state.lessons,
                          onChange: (int index) {
                            final date = _parseDate(state.todayLessons[index].date);
                            if(_dateCurrent != date){
                            _dateCurrent = date;
                              _changeIndexDate = index;
                              context.read<TableBloc>().add(GetLessonsTableByDate(
                                  indexDate: index,
                                  viewMode: _modeTable));
                            }

                          },
                          initIndex: _changeIndexDate<0?state.indexByDateNow:_changeIndexDate,
                          lessonsToday: state.todayLessons,
                        ),
                        const Gap(10.0),
                        TableModeMenu(modeView: (ViewModeTable mode) {
                          if (mode == ViewModeTable.week) {
                            _modeTable = ViewModeTable.week;
                            context
                                .read<TableBloc>()
                                .add( GetLessonsTableWeek(viewMode: mode,
                            date: _dateCurrent));
                          } else if (mode == ViewModeTable.day) {
                            _modeTable = ViewModeTable.day;
                            context.read<TableBloc>().add(
                                 GetInitLessonsEvent(viewMode: mode,date: _dateCurrent,scrollPage: true));
                          } else {
                            context.read<TableBloc>().add(
                                 GetMyLessonEvent(weekMode: false,indexDate: state.indexByDateNow));
                          }
                        })
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
                  if (state.titles.isEmpty) ...{
                    const Expanded(
                      child: Center(
                        child: BoxInfo(
                          title: 'Данные не загрузились',
                          iconData: Icons.table_chart_outlined,
                        ),
                      ),
                    )
                  } else ...{
                    Expanded(
                      child: MyTimePlanner(
                        onTapTable: (TableTapLocation locTap) {
                          Dialoger.showModalBottomMenu(
                              blurred: true,
                              args: _addLesson(
                                idSchool: state.currentIdSchool,
                                nameTeacher: '${teacher.firstName} ${teacher.lastName}',
                                idTeacher: teacher.id,
                                  timePeriod: _times[locTap.y],
                                  dateDay: state.titles[locTap.x].dateChoice,
                                  idAuditory:
                                      state.modeTable == ViewModeTable.day
                                          ? state.titles[locTap.x].title
                                          : ''),
                              title: 'Добавить урок'.tr(),
                              content: AddLesson());
                        },
                        colorDividerVertical:
                            themeProvider.themeStatus == ThemeStatus.dark
                                ? colorGrey
                                : Colors.black12,
                        colorDividerHorizontal: colorGrey,
                        modeView: (ViewModeTable mode) {
                        },
                        startHour: 10,
                        endHour: 21,
                        use24HourFormat: true,
                        setTimeOnAxis: false,
                        headers: [
                          ...List.generate(state.titles.length, (index) {
                            return TimePlannerTitle(
                              date: state.titles[index].date.isEmpty
                                  ? index.toString()
                                  : state.titles[index].date,
                              title: state.titles[index].title,
                              titleStyle: TStyle.textStyleVelaSansBold(
                                  Theme.of(context)
                                      .textTheme
                                      .displayMedium!
                                      .color!,
                                  size: 14.0),
                            );
                          })
                        ],
                        // List of task will be show on the time planner
                        tasks: [
                          ...List.generate(state.tasks.length, (index) {
                            return TimePlannerTask(
                              color: state.tasks[index].lesson.alien
                                  ? Colors.grey
                                  : StatusToColor.getColor(
                                      lessonStatus:
                                          state.tasks[index].lesson.status),
                              dateTime: state.tasks[index].timePlannerDateTime,
                              minutesDuration: 60,
                              daysDuration: 1,
                              onTap: () {
                                if (state.tasks[index].lesson.alien&&
                                  !visible(state, index)) {
                                  Dialoger.showToast('Чужой урок'.tr());
                                  return;
                                }
                                Dialoger.showModalBottomMenu(
                                    blurred: true,
                                    title: 'Информация об уроке'.tr(),
                                    args: state.tasks[index].lesson,
                                    content: InfoStatusLesson());
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
                                              color(state, index, context),
                                              size: 12.0)),
                                    ),
                                    Visibility(
                                        visible:
                                        visible(state, index),
                                        child: Icon(Icons.add,
                                            color: color(state, index,
                                                context),
                                            size: 13)),
                                    Visibility(
                                      visible:  !state.tasks[index].lesson.type.isTrial,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(Icons.directions,
                                              color: color(state, index, context),
                                              size: 10.0),
                                          const Gap(3),
                                          SizedBox(
                                            width: 63,
                                            child: Text(
                                                state.tasks[index].lesson
                                                    .nameDirection,
                                                overflow:
                                                    TextOverflow.ellipsis,
                                                style: TStyle
                                                    .textStyleVelaSansMedium(
                                                        color(state, index,
                                                            context),
                                                        size: 12.0)),
                                          ),
                                        ],
                                      ),
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
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                    )
                  }
                }
              ],
            ).animate().fade(duration: const Duration(milliseconds: 400)),
          );
        });
  }

  bool visible(TableState state, int index) {
    return
        state.tasks[index].lesson.status == LessonStatus.cancel ||
        state.tasks[index].lesson.status == LessonStatus.out ||
        state.tasks[index].lesson.type == LessonType.trial;
  }

  Color color(TableState state, int index, BuildContext context) {
    return state.tasks[index].lesson.status == LessonStatus.complete ||
            state.tasks[index].lesson.status == LessonStatus.reservation ||
            state.tasks[index].lesson.status == LessonStatus.planned
        ? colorBlack
        : Theme.of(context).textTheme.displayMedium!.color!;
  }

  Lesson _addLesson(
      {required String timePeriod,
      required String idAuditory,
        required int idTeacher,
        required String idSchool,
        required String nameTeacher,
      required String dateDay}) {
    return Lesson(
      nameGroup: '',
      idStudent: 0,
      idDir: 0,
      comments: '',
         nameSub: '',
         duration: 0,
         idTeacher: idTeacher,
        type: LessonType.unknown,
        alien: false,
        contactValues: [],
        id: 0,
        idSub: 0,
        idSchool: idSchool,
        bonus: false,
        timeAccept: '',
        date: dateDay,
        timePeriod: timePeriod,
        idAuditory: idAuditory,
        nameTeacher: nameTeacher,
        nameStudent: '',
        status: LessonStatus.firstLesson,
        nameDirection: '',
        online: false);
  }

  String _parseDate(String dateCurrent){

    if(dateCurrent.contains('/')){
        return dateCurrent.split('/')[0];
    }
    return dateCurrent;
  }
}
