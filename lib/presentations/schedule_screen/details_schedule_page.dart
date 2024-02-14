



  import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:virtuozy/presentations/schedule_screen/schedule_page.dart';

import '../../components/app_bar.dart';
import '../../components/drawing_menu_selected.dart';
import '../../domain/entities/schedule_lessons.dart';
import '../../domain/entities/user_entity.dart';
import '../../resourses/colors.dart';
import '../../router/paths.dart';
import '../../utils/text_style.dart';
import 'bloc/schedule_bloc.dart';
import 'bloc/schedule_state.dart';

class DetailsSchedulePage extends StatefulWidget{
  const DetailsSchedulePage({super.key});

  @override
  State<DetailsSchedulePage> createState() => _DetailsSchedulePageState();
}

class _DetailsSchedulePageState extends State<DetailsSchedulePage> {
  int _selIndexDirection = 0;

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBarCustom(title: 'Подробное расписание'.tr()),
     body: BlocConsumer<ScheduleBloc,ScheduleState>(
       listener: (c,s){

       },
       builder: (context,state) {
         return Padding(
           padding: const EdgeInsets.symmetric(horizontal: 10.0),
           child: SingleChildScrollView(
             child: Column(
               children: [
                 Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 10.0),
                   child: DrawingMenuSelected(items: state.user.directions.map((e) => e.name).toList(),
                   onSelected: (index){
                     setState(() {
                       _selIndexDirection = index;
                     });
                   },),
                 ),
                 const Gap(10.0),
                 Column(
                   children: List.generate(1, (index) {
                     return  ItemScheduleDetails(scheduleLessons: state.scheduleLessons,
                         listSchedule: state.schedulesList,
                         nameDirection: state.user.directions[_selIndexDirection].name);
                   }),
                 ),

               ],
             ),
           ),
         );
       }
     ),
   );
  }
}


  class ItemScheduleDetails extends StatelessWidget{
    const ItemScheduleDetails({super.key, required this.scheduleLessons, required this.nameDirection, required this.listSchedule});


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
              return ItemLessonsDetails(
                lastItem: index == (scheduleLessons.lessons.length-1),
                  lesson: scheduleLessons.lessons[index], nameDirection: nameDirection);
            }),
          ],
        ),
      );
    }

  }

  class ItemLessonsDetails extends StatelessWidget{
    const ItemLessonsDetails({super.key,  required this.lastItem, required this.nameDirection, required this.lesson});

    final String nameDirection;
    final Lesson lesson;
    final bool lastItem;

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
          Visibility(
            visible: !lastItem,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 5.0),
              height: 1.0,
              color: colorGrey,
            ),
          )
        ],
      );
    }

  }

