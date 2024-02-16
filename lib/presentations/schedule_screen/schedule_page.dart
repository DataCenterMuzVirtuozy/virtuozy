


 import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:virtuozy/domain/entities/schedule_lessons.dart';
import 'package:virtuozy/domain/entities/user_entity.dart';
import 'package:virtuozy/presentations/schedule_screen/bloc/schedule_bloc.dart';
import 'package:virtuozy/presentations/schedule_screen/bloc/schedule_event.dart';
import 'package:virtuozy/presentations/schedule_screen/bloc/schedule_state.dart';
import 'package:virtuozy/router/paths.dart';
import 'package:virtuozy/utils/auth_mixin.dart';
import 'package:virtuozy/utils/status_to_color.dart';

import '../../components/box_info.dart';
import '../../components/calendar.dart';
import '../../components/drawing_menu_selected.dart';
import '../../resourses/colors.dart';
import '../../utils/text_style.dart';

class SchedulePage extends StatefulWidget{
   const SchedulePage({super.key, required this.currentMonth});

   final int currentMonth;

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {


  int _selIndexDirection = 0;

  @override
  void initState() {
    super.initState();
    context.read<ScheduleBloc>().add(GetScheduleEvent(
        currentDirIndex: _selIndexDirection,
        month: widget.currentMonth));
  }


  @override
  Widget build(BuildContext context) {

    return BlocConsumer<ScheduleBloc,ScheduleState>(
      listener: (c,s){

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
                  child: DrawingMenuSelected(items:state.user.directions.map((e) => e.name).toList(),
                  onSelected: (index){
                    setState(() {
                      _selIndexDirection = index;
                    });
                  },),
                ),
                const Gap(10.0),
                 Calendar(
                     lessons: state.user.directions[_selIndexDirection].lessons,
                     onMonth: (month){
                       context.read<ScheduleBloc>().add(GetScheduleEvent(
                           currentDirIndex: _selIndexDirection,
                           month: month));
                     },
                     onLesson: (lesson){

                      }),
                const Gap(10.0),
                Column(
                  children: List.generate(1, (index) {
                    return  ItemSchedule(scheduleLessons: state.scheduleLessons,
                    listSchedule: state.schedulesList,
                    nameDirection: state.user.directions[_selIndexDirection].name);
                  }),
                ),

              ],
            ),
          ),
        );
      }
    );

  }


}

 class ItemSchedule extends StatelessWidget{
   const ItemSchedule({super.key, required this.scheduleLessons, required this.nameDirection, required this.listSchedule});

   final ScheduleLessons scheduleLessons;
   final String nameDirection;
   final List<ScheduleLessons> listSchedule;




  @override
  Widget build(BuildContext context) {
    return  Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
    padding: const EdgeInsets.all(20.0),
    width: MediaQuery.sizeOf(context).width,
    decoration: BoxDecoration(
    color: colorBeruzaLight,
    borderRadius: BorderRadius.circular(20.0)),
      child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [
              Text('Уроки на '.tr(),style:TStyle.textStyleVelaSansExtraBolt(colorBlack,size: 18.0)),
              Text(scheduleLessons.month,style:TStyle.textStyleVelaSansExtraBolt(colorBlack,size: 18.0)),
            ],
          ),
          const Gap(10.0),
          ...List.generate(scheduleLessons.lessons.length, (index) {
            return ItemLessons(nameDirection: nameDirection,
            lesson: scheduleLessons.lessons[index]);
          }),
          Visibility(
            visible: listSchedule.length>1,
            child: Center(child: TextButton(onPressed: () {
                GoRouter.of(context).push(pathDetailsSchedule);
            },
                child: Text('Подробное расписание'.tr(),
                        style: TStyle.textStyleVelaSansRegularUnderline(
                            colorBlack,
                            size: 16.0)))),
          ),
        ],
      ),
    );
  }

 }


 class ItemLessons extends StatelessWidget{
  const ItemLessons({super.key, required this.nameDirection, required this.lesson});

  final String nameDirection;
  final Lesson lesson;

  @override
  Widget build(BuildContext context) {
   return Column(
     children: [
       Row(
         children: [
           SizedBox(
             width: 120.0,
             child: Column(
               mainAxisAlignment: MainAxisAlignment.start,
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text(lesson.date,
                     style:TStyle.textStyleVelaSansMedium(colorOrange,size: 14.0)),
                 const Gap(5.0),
                 Text(lesson.timePeriod,
                     style:TStyle.textStyleVelaSansRegular(colorBlack,size: 12.0)),
                 const Gap(5.0),
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
                           style:TStyle.textStyleVelaSansRegular(colorBlack,size: 10.0)),
                     ),
                   ],
                 )
               ],
             ),
           ),
           Container(
             margin: const EdgeInsets.symmetric(horizontal: 10.0),
             height: 50.0,
             width: 1.0,
             color: colorGrey,
           ),
           Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Text(nameDirection,
                   style:TStyle.textStyleVelaSansRegular(colorBlack,size: 14.0)),

               Row(
                 children: [
                   Text('Аудитория '.tr(),
                       style:TStyle.textStyleVelaSansRegular(colorBlack,size: 14.0)),
                   Text('${lesson.idAuditory}',
                       style:TStyle.textStyleVelaSansRegular(colorBlack,size: 14.0)),
                 ],
               ),
               Text(lesson.nameTeacher,
                   style:TStyle.textStyleVelaSansRegular(colorBlack,size: 14.0)),
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
   );
  }

 }

