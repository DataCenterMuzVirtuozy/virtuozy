


 import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:virtuozy/domain/entities/schedule_lessons.dart';
import 'package:virtuozy/domain/entities/user_entity.dart';
import 'package:virtuozy/router/paths.dart';
import 'package:virtuozy/utils/auth_mixin.dart';
import 'package:virtuozy/utils/date_time_parser.dart';
import 'package:virtuozy/utils/status_to_color.dart';
import '../../../components/box_info.dart';
import '../../../components/calendar/calendar.dart';
import '../../../components/dialogs/dialoger.dart';
import '../../../components/dialogs/sealeds.dart';
import '../../../components/drawing_menu_selected.dart';
import '../../../components/title_page.dart';
import '../../../domain/entities/lesson_entity.dart';
import '../../../resourses/colors.dart';
import '../../../utils/text_style.dart';
import '../subscription_screen/subscription_page.dart';
import 'bloc/schedule_bloc.dart';
import 'bloc/schedule_event.dart';
import 'bloc/schedule_state.dart';



class SchedulePage extends StatefulWidget{
   const SchedulePage({super.key, required this.currentMonth});

   final int currentMonth;

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> with AuthMixin{


  int _selIndexDirection = 0;
  List<String> _titlesDirections = [];
  bool _allViewDirection = false;

  @override
  void initState() {
    super.initState();
    context.read<ScheduleBloc>().add(GetScheduleEvent(
      refreshMonth: false,
      allViewDir: false,
      refreshDirection: true,
        currentDirIndex: _selIndexDirection,
        month: widget.currentMonth));
  }


  @override
  Widget build(BuildContext context) {

    return BlocConsumer<ScheduleBloc,ScheduleState>(
      listener: (c,s){
        if(s.status == ScheduleStatus.loaded){
          int length = s.user.directions.length;
          _titlesDirections = s.user.directions.map((e) => e.name).toList();
          if(length>1){
            _titlesDirections.insert(length, 'Все направления'.tr());
          }
        }



      },
      builder: (context,state) {

        if(state.status == ScheduleStatus.loading){
          return Center(
            child: CircularProgressIndicator(color: colorOrange),
          );
        }

        if(state.user.userStatus.isModeration || state.user.userStatus.isNotAuth){
          return Center(
            child: BoxInfo(
                buttonVisible: state.user.userStatus.isNotAuth,
                title: state.user.userStatus.isModeration?'Ваш аккаунт на модерации'.tr():'Расписание недоступно'.tr(),
                description: state.user.userStatus.isModeration?'На период модерации работа с расписанием недоступна'.tr():
                'Для работы с расписанием необходимо авторизироваться'.tr(),
                iconData: Icons.calendar_month),
          );
        }






        if(state.user.directions.isEmpty && state.status == ScheduleStatus.loaded){
          return Center(
            child: BoxInfo(
                buttonVisible:false,
                title: 'Список пуст'.tr(),
                description: 'У вас нет направлений обучения'.tr(),
                iconData: CupertinoIcons.music_note_list),
          );
        }





        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: DrawingMenuSelected(items:_titlesDirections,
                  onSelected: (index){
                    _selIndexDirection = index;
                    if(index == _titlesDirections.length-1){
                      _allViewDirection = true;
                    }else{
                      _allViewDirection = false;
                    }
                    context.read<ScheduleBloc>().add(GetScheduleEvent(
                        refreshMonth: false,
                        allViewDir: _allViewDirection,
                        currentDirIndex: _selIndexDirection,
                        month: globalCurrentMonthCalendar,
                        refreshDirection: false));
                  },),
                ),
                const Gap(10.0),
                 Calendar(
                   onDate: (date){},
                   colorFill: Theme.of(context).colorScheme.surfaceVariant,
                   clickableDay: true,
                     lessons: state.lessons,
                     onMonth: (month){
                     if(globalCurrentMonthCalendar == month){
                       return;
                     }
                       globalCurrentMonthCalendar = month;
                       context.read<ScheduleBloc>().add(GetScheduleEvent(
                           refreshMonth: true,
                           currentDirIndex: _selIndexDirection,
                           month: month,
                           refreshDirection: false,
                           allViewDir: _allViewDirection));
                     },
                     onLesson: (lessons){
                       Dialoger.showModalBottomMenu(
                           blurred: false,
                           title: 'Урок №${lessons[0].id} из ${lessons[0].id+5}',
                           args: [lessons,state.user.directions],
                           content: DetailsLesson());
                      }),
                const Gap(10.0),


                  ValueListenableBuilder<List<ScheduleLessons>>(
                      valueListenable: listScheduleNotifier,
                      builder: (context,schedules,child) {
                        if(schedules.isNotEmpty){
                          return Column(
                            children: List.generate(schedules.length, (index) {

                              if(schedules[index].lessons.isEmpty){
                                return  Padding(
                                  padding: const EdgeInsets.only(top: 40.0),
                                  child: Center(
                                      child: BoxInfo(
                                          buttonVisible: false,
                                          title: 'График пуст'.tr(),
                                          description: 'У вас нет занятий на текущий месяц'.tr(),
                                          iconData: CupertinoIcons.calendar_badge_plus)),
                                );
                              }

                              return  ItemSchedule(lengthSchedule: state.schedulesLength,
                                  scheduleLessons: schedules[index],
                                user: user);
                            }),
                          );
                        }

                        return const CircularProgressIndicator();

                      }
                  )



              ],
            ),
          ),
        );
      }
    );

  }


}

 class ItemSchedule extends StatelessWidget{
   const ItemSchedule({super.key, required this.scheduleLessons,required this.lengthSchedule, required this.user});

   final ScheduleLessons scheduleLessons;
   final int lengthSchedule;
   final UserEntity user;




  @override
  Widget build(BuildContext context) {
    return  Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
    padding: const EdgeInsets.all(20.0),
    width: MediaQuery.sizeOf(context).width,
    decoration: BoxDecoration(
    color: Theme.of(context).colorScheme.surfaceVariant,
    borderRadius: BorderRadius.circular(20.0)),
      child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [
              Text('Уроки на '.tr(),style:TStyle.textStyleVelaSansExtraBolt(Theme.of(context).textTheme.displayMedium!.color!,size: 18.0)),
              Text(scheduleLessons.month,style:TStyle.textStyleVelaSansExtraBolt(Theme.of(context).textTheme.displayMedium!.color!,size: 18.0)),
            ],
          ),
          const Gap(10.0),
          ...List.generate(scheduleLessons.lessons.length, (index) {
            return ItemLessons(
              user: user,
            lesson: scheduleLessons.lessons[index]);
          }),
          Visibility(
            visible: lengthSchedule>1,
            child: Center(child: TextButton(onPressed: () {
                GoRouter.of(context).push(pathDetailsSchedule);
            },
                child: Text('Подробное расписание'.tr(),
                        style: TStyle.textStyleVelaSansRegularUnderline(
                            Theme.of(context).textTheme.displayMedium!.color!,
                            size: 16.0)))),
          ),
        ],
      ),
    );
  }

 }


 class ItemLessons extends StatelessWidget{
  const ItemLessons({super.key,required this.lesson, required this.user});


  final Lesson lesson;
  final UserEntity user;

  @override
  Widget build(BuildContext context) {
   return GestureDetector(
     onTap: (){
       if(lesson.status == LessonStatus.awaitAccept){
         Dialoger.showModalBottomMenu(
             blurred: false,
             title: 'Урок #${lesson.id}'.tr(),
             args: [[lesson],user.directions],
             content: DetailsLesson());
       }

     },
     child: Column(
       children: [
         Row(
           children: [
             SizedBox(
               width: 120.0,
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.start,
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text(DateTimeParser.getDateFromApi(date: lesson.date),
                       style:TStyle.textStyleVelaSansMedium(colorOrange,size: 14.0)),
                   const Gap(5.0),
                   Text(lesson.timePeriod,
                       style:TStyle.textStyleVelaSansRegular(Theme.of(context).textTheme.displayMedium!.color!,size: 12.0)),
                   const Gap(5),
                   Row(
                     children: [
                       Container(
                         decoration: BoxDecoration(
                           shape: BoxShape.circle,
                           color: StatusToColor.getColor(lessonStatus: lesson.status)
                         ),
                         width: 5.0,
                         height: 5.0,
                       ),
                       const Gap(5.0),
                       Expanded(
                         child: Text(StatusToColor.getNameStatus(lesson.status),
                             maxLines: 2,
                             style:TStyle.textStyleVelaSansRegular(Theme.of(context).textTheme.displayMedium!.color!,size: 10.0)),
                       ),
                     ],
                   )
                 ],
               ),
             ),
             Container(
               margin: const EdgeInsets.symmetric(horizontal: 10.0),
               height: 70.0,
               width: 1.0,
               color: colorGrey,
             ),
             Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text(lesson.nameDirection,
                     style:TStyle.textStyleVelaSansRegular(Theme.of(context).textTheme.displayMedium!.color!,size: 14.0)),
                 Row(
                   children: [
                     Text('Аудитория '.tr(),
                         style:TStyle.textStyleVelaSansRegular(Theme.of(context).textTheme.displayMedium!.color!,size: 14.0)),
                     Text(lesson.idAuditory,
                         style:TStyle.textStyleVelaSansRegular(Theme.of(context).textTheme.displayMedium!.color!,size: 14.0)),
                   ],
                 ),
                 Text(lesson.nameTeacher,
                     style:TStyle.textStyleVelaSansRegular(Theme.of(context).textTheme.displayMedium!.color!,size: 14.0)),
                 Row(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Padding(
                       padding: const EdgeInsets.only(top: 3),
                       child: Icon(Icons.school_outlined,
                           color: colorOrange,size: 12.0),
                     ),
                     const Gap(5),
                     Text(lesson.idSchool,
                         maxLines: 2,
                         overflow: TextOverflow.ellipsis,
                         style: TStyle.textStyleVelaSansRegular( Theme.of(context).textTheme.displayMedium!.color!, size: 12.0)),
                   ],
                 ),
               ],
             ),
           ],
         ),
         Container(
           margin: const EdgeInsets.symmetric(vertical: 5.0),
           height: 1.0,
           color: colorGrey,
         )
       ],
     ),
   );
  }

 }

