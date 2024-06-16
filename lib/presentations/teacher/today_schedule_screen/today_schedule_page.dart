




  import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:virtuozy/components/calendar_caller.dart';
import 'package:virtuozy/domain/entities/lesson_entity.dart';
import 'package:virtuozy/presentations/teacher/today_schedule_screen/bloc/today_schedule_bloc.dart';
import 'package:virtuozy/presentations/teacher/today_schedule_screen/bloc/today_schedule_event.dart';
import 'package:virtuozy/presentations/teacher/today_schedule_screen/bloc/today_schedule_state.dart';
import 'package:virtuozy/presentations/teacher/today_schedule_screen/time_line_list.dart';
import 'package:virtuozy/presentations/teacher/today_schedule_screen/timeline_schedule.dart';
import 'package:virtuozy/utils/theme_provider.dart';

import '../../../components/box_info.dart';
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



  bool _onlyWithLesson = false;
  bool _visibleTodayButton = false;



  @override
  void initState() {
    super.initState();
    context.read<TodayScheduleBloc>().add(const GetTodayLessonsEvent());

  }


  @override
  void dispose() {
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodayScheduleBloc,TodayScheduleState>(
      listener: (c,s){
         _visibleTodayButton = s.visibleTodayButton;

         if(s.addScheduleStatus == AddScheduleStatus.error){
           Dialoger.showToast('Ошибка добавления урока'.tr());
         }

         if(s.addScheduleStatus == AddScheduleStatus.loaded){
           Dialoger.showToast('Урок успешно добавлен'.tr());
         }

         if(s.editScheduleStatus == EditScheduleStatus.error){
           Dialoger.showToast('Ошибка редактирования урока'.tr());
         }

         if(s.editScheduleStatus == EditScheduleStatus.loaded){
           Dialoger.showToast('Статус урока изменен'.tr());
         }

      },
      builder: (context,state) {

        // if(state.status == TodayScheduleStatus.loading){
        //   return Center(child: CircularProgressIndicator(color: colorOrange));
        // }

        if(state.todayLessons.isEmpty&&state.status  == TodayScheduleStatus.loaded){
          return  BoxInfo(title: 'Нет данных'.tr(), iconData: Icons.table_chart_outlined,);
        }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                  padding: const EdgeInsets.only(left: 20.0,bottom: 10.0,top: 20.0),
                  child: Text('Мое расписание'.tr()
                      ,style: TStyle.textStyleGaretHeavy(Theme.of(context)
                          .textTheme.displayMedium!.color!,size: 18.0))),
              Padding(
                padding: const EdgeInsets.only(right: 20,left: 20,top: 10),
                child: SizedBox(
                  height: 30.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DatePageView(
                        loading: state.status == TodayScheduleStatus.loading,
                        onVisibleTodayButton: (visible){
                          setState(() {
                            _visibleTodayButton = visible;
                          });

                        },
                        initIndex: state.indexByDateNow,
                        lessonsToday: state.todayLessons,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20,left: 30,right: 30),
                child: SizedBox(
                  height: 35,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SelectSchoolMenu(
                        key: ValueKey(state.idsSchool),
                        loading: state.status == TodayScheduleStatus.loading,
                        currentIdSchool: state.currentIdSchool,
                        idsSchool: state.idsSchool,
                        onChange: (id){
                          context.read<TodayScheduleBloc>().add(GetLessonsByIdSchoolEvent(id));
                        },
                      ),
                      CalendarCaller(
                          dateSelect: (date){
                            _onlyWithLesson = false;
                            context.read<TodayScheduleBloc>().add(GetLessonsBySelDateEvent(date: date));
                          },
                          lessons: state.lessons),

                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: _onlyWithLesson?colorOrange:
                              Colors.transparent,width:1.5),
                          color: Theme.of(context).colorScheme.surfaceVariant,),
                        child: IconButton(
                            icon: Icon(Icons.school_outlined,
                                color: Theme.of(context).textTheme.displayMedium!.color!,size: 18),
                            onPressed: (){
                              if(_onlyWithLesson){
                                _onlyWithLesson =  false;
                              }else{
                                Dialoger.showToast('Показать дни только с уроками'.tr());
                                _onlyWithLesson = true;
                              }
                              context.read<TodayScheduleBloc>().add(GetLessonsByModeViewEvent(onlyWithLesson: _onlyWithLesson));
                            }).animate().fade(duration: const Duration(milliseconds: 400)),
                      ),

                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: !_visibleTodayButton?colorOrange:
                          Colors.transparent,width:1.5),
                            color: Theme.of(context).colorScheme.surfaceVariant,),
                        child: IconButton(
                            icon: Icon(Icons.today_outlined,
                                color: Theme.of(context).textTheme.displayMedium!.color!,size: 18),
                            onPressed: (){
                              if(!_visibleTodayButton){
                                return;
                              }
                              Dialoger.showToast('Вернуться в сегодняшний день'.tr());
                              _onlyWithLesson = false;
                              final date  = DateTime.now().toString().split(' ')[0];
                              context.read<TodayScheduleBloc>().add(GetLessonsBySelDateEvent(date: date));
                            }).animate().fade(duration: const Duration(milliseconds: 400)),
                      )

                    ],
                  ),
                ),
              ),
              const Gap(20),
              if(state.status == TodayScheduleStatus.loading)...{
                 Expanded(
                   child: Center(child: CircularProgressIndicator(color: colorOrange)),
                 )
              }else...{
                TimeLineList(
                  initIndex: state.indexByDateNow,
                  todayLessons: state.todayLessons,
                )
              }


              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 40.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.end,
              //     children: [
              //       // SizedBox(
              //       //   width: MediaQuery.of(context).size.width-100,
              //       //   height: 40.0,
              //       //   child: SubmitButton(
              //       //     onTap: (){
              //       //
              //       //       // Dialoger.showModalBottomMenu(
              //       //       //     blurred: false,
              //       //       //     args:[state.firstNotAcceptLesson,
              //       //       //       state.directions, state.listNotAcceptLesson,
              //       //       //       _allViewDirection],
              //       //       //     title:'Подтверждение урока'.tr(),
              //       //       //     content: ConfirmLesson());
              //       //     },
              //       //     //colorFill: Theme.of(context).colorScheme.tertiary,
              //       //     colorFill: colorGreen,
              //       //     borderRadius: 10.0,
              //       //     textButton:
              //       //     'Подтвердите прохождение урока'.tr(),
              //       //   ),
              //       // ),
              //
              //
              //     ],
              //   ),
              // ),
            ],
          ).animate().fade(duration: const Duration(milliseconds: 400));


      }
    );
  }


}


