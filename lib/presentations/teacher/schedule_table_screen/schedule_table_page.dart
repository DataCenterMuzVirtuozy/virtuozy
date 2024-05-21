



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:time_planner/time_planner.dart';
import 'package:virtuozy/components/select_auditory_menu.dart';
import 'package:virtuozy/domain/entities/lesson_entity.dart';
import 'package:virtuozy/presentations/teacher/bloc/table_event.dart';
import 'package:virtuozy/presentations/teacher/schedule_table_screen/table/my_time_planner.dart';
import 'package:virtuozy/resourses/colors.dart';
import 'package:virtuozy/utils/status_to_color.dart';

import '../../../components/calendar_caller.dart';
import '../../../components/date_page_table.dart';
import '../../../components/date_page_view.dart';
import '../../../components/select_school_menu.dart';
import '../../../utils/text_style.dart';
import '../bloc/table_bloc.dart';
import '../bloc/table_state.dart';

class ScheduleTablePage extends StatefulWidget{
  const ScheduleTablePage({super.key});

  @override
  State<ScheduleTablePage> createState() => _ScheduleTablePageState();
}

class _ScheduleTablePageState extends State<ScheduleTablePage> {



  @override
  void initState() {
    super.initState();
   context.read<TableBloc>().add(GetInitLessonsEvent());

  }


 @override
  void didChangeDependencies() {
   super.didChangeDependencies();

  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TableBloc,TableState>(
      listener: (c,s){},
      builder: (context,state) {

        if(state.status == TableStatus.loading){
          return Center(child: CircularProgressIndicator(color: colorOrange));
        }
        return Column(
          children: [
              Padding(
              padding: const EdgeInsets.only(bottom: 10.0,top: 10.0),
              child: SizedBox(
                height: 30.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SelectSchoolMenu(
                      currentIdSchool: state.currentIdSchool,
                      idsSchool: state.idsSchool,
                      onChange: (id){
                          context.read<TableBloc>().add(GetLessonsTableByIdSchool(id: id));
                      },
                    ),
                    const Gap(20.0),
                     DatePageTable(
                       onChange: (index){
                         context.read<TableBloc>().add(GetLessonsTableByDate(indexDate: index));
                       },
                       weekMode: true,
                      initIndex: state.indexByDateNow,
                      lessonsToday: state.todayLessons,
                    ),
                    const Gap(20.0),
                    CalendarCaller(
                      dateSelect: (date){},
                        lessons: state.lessons)
                  ],
                ),
              ),
            ),
             Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 const Visibility(
                   visible: false,
                     child: SelectAuditoryMenu()),
               ],
             ),
            const Gap(10.0),
           if(state.status == TableStatus.loadingTable)...{
             Center(
               child: CircularProgressIndicator(color: colorOrange),
             )
           }else if(state.status == TableStatus.loadedTable
               || state.status == TableStatus.loaded)...{
             Expanded(
               child: MyTimePlanner(
                 modeView: (ViewModeTable mode){
                   if(mode == ViewModeTable.week){
                     context.read<TableBloc>().add(GetLessonsTableWeek());
                   }else if(mode == ViewModeTable.day){
                     context.read<TableBloc>().add(GetInitLessonsEvent());
                   }else{
                     //my shedule
                   }
                 },
                 startHour: 10,
                 endHour: 21,
                 use24HourFormat: true,
                 setTimeOnAxis: false,
                 headers: [

                   ...List.generate(state.titles.length, (index) {
                     return                   TimePlannerTitle(
                       date: state.titles[index].date,
                       title: state.titles[index].title,
                       titleStyle:  TStyle.textStyleVelaSansBold(Theme.of(context)
                           .textTheme.displayMedium!.color!,size: 14.0),
                     );
                   })

                 ],
                 // List of task will be show on the time planner
                 tasks: [
                   ...List.generate(state.tasks.length, (index){
                     return TimePlannerTask(

                       color: StatusToColor.getColor(lessonStatus: state.tasks[index].lesson.status),
                       dateTime: state.tasks[index].timePlannerDateTime,
                       // Minutes duration of task
                       minutesDuration: 60,
                       // Days duration of task (use for multi days task)
                       daysDuration: 1,
                       onTap: () {

                       },
                       child: Padding(
                         padding: const EdgeInsets.all(5.0),
                         child: Text(
                             state.tasks[index].lesson.nameStudent,
                             textAlign: TextAlign.start,
                             maxLines: 3,
                             overflow: TextOverflow.ellipsis,
                             style:
                             TStyle.textStyleVelaSansBold(Theme.of(context)
                                 .textTheme.displayMedium!.color!,size: 12.0)),
                       ),
                     );
                   })
                 ],
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
             )
           }
          ],
        );
      }
    );
  }
}