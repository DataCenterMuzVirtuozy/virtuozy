




  import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:virtuozy/components/calendar_caller.dart';
import 'package:virtuozy/domain/entities/lesson_entity.dart';
import 'package:virtuozy/presentations/teacher/today_schedule_screen/bloc/today_schedule_bloc.dart';
import 'package:virtuozy/presentations/teacher/today_schedule_screen/bloc/today_schedule_event.dart';
import 'package:virtuozy/presentations/teacher/today_schedule_screen/bloc/today_schedule_state.dart';
import 'package:virtuozy/presentations/teacher/today_schedule_screen/timeline_schedule.dart';

import '../../../components/buttons.dart';
import '../../../components/date_page_view.dart';
import '../../../components/dialogs/dialoger.dart';
import '../../../components/select_school_menu.dart';
import '../../../resourses/colors.dart';
import '../../../utils/text_style.dart';

class TodaySchedulePage extends StatefulWidget{
  const TodaySchedulePage({super.key});

  @override
  State<TodaySchedulePage> createState() => _TodaySchedulePageState();
}

class _TodaySchedulePageState extends State<TodaySchedulePage> {


  late PageController _pageController;



  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    context.read<TodayScheduleBloc>().add(GetTodayLessonsEvent());


  }


  @override
  void dispose() {
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodayScheduleBloc,TodayScheduleState>(
      listener: (c,s){

      },
      builder: (context,state) {
        if(state.status == TodayScheduleStatus.loadingIdsSchool){
          return Center(child: CircularProgressIndicator(color: colorOrange));
        }

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
                height: 30.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SelectSchoolMenu(
                      idsSchool: state.idsSchool,
                      onChange: (id){
                        context.read<TodayScheduleBloc>().add(GetLessonsByIdSchoolEvent(id));
                      },
                    ),
                    DatePageView(
                      initIndex: state.indexByDateNow,
                      onChangePage: (page){
                        _pageController.animateToPage(page,duration: const Duration(milliseconds: 400), curve: Curves.easeIn);
                      },
                      lessonsToday: state.todayLessons,
                    ),
                   CalendarCaller(lessons: state.lessons)
                  ],
                ),
              ),
            ),
            Expanded(child: PageView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.todayLessons.length,
              controller: _pageController,
              itemBuilder: (BuildContext context, int index) {
                return TimelineSchedule(
                  todayLessons: state.todayLessons[index],
                );
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
    );
  }


}


