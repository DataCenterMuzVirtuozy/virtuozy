



  import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../components/app_bar.dart';
import '../../../components/drawing_menu_selected.dart';
import '../../../domain/entities/lesson_entity.dart';
import '../../../domain/entities/schedule_lessons.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../resourses/colors.dart';
import '../../../utils/date_time_parser.dart';
import '../../../utils/status_to_color.dart';
import '../../../utils/text_style.dart';
import 'bloc/schedule_bloc.dart';
import 'bloc/schedule_event.dart';
import 'bloc/schedule_state.dart';

class DetailsSchedulePage extends StatefulWidget{
  const DetailsSchedulePage({super.key});

  @override
  State<DetailsSchedulePage> createState() => _DetailsSchedulePageState();
}

class _DetailsSchedulePageState extends State<DetailsSchedulePage> {
  int _selIndexDirection = 0;
  List<String> _titlesDirections = [];
  bool _allViewDirection = false;


  @override
  void initState() {
    super.initState();
    context.read<ScheduleBloc>().add(GetDetailsScheduleEvent(
      refreshDirection: true,
        allViewDir: false,
        currentDirIndex: _selIndexDirection));
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBarCustom(title: 'Подробное расписание'.tr()),
     body: BlocConsumer<ScheduleBloc,ScheduleState>(
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

         return Padding(
           padding: const EdgeInsets.symmetric(horizontal: 10.0),
           child: SingleChildScrollView(
             child: Column(
               children: [
                 Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 10.0),
                   child: DrawingMenuSelected(items: _titlesDirections,
                   onSelected: (index){
                     _selIndexDirection = index;
                     if(index == _titlesDirections.length-1){
                       _allViewDirection = true;
                     }else{
                       _allViewDirection = false;
                     }
                     context.read<ScheduleBloc>().add(GetDetailsScheduleEvent(
                       refreshDirection: false,
                         allViewDir: _allViewDirection,
                         currentDirIndex: _selIndexDirection));
                   },),
                 ),
                 const Gap(10.0),
                 Column(
                   children: List.generate(state.schedulesList.length, (index) {
                     return  ItemScheduleDetails(scheduleLessons: state.schedulesList[index],
                         allViewDirections: _allViewDirection,
                         listSchedule: state.schedulesList);
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
    const ItemScheduleDetails({super.key, required this.scheduleLessons, required this.listSchedule,
    required this.allViewDirections});


    final ScheduleLessons scheduleLessons;
    final List<ScheduleLessons> listSchedule;
    final bool allViewDirections;


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
              return ItemLessonsDetails(
                allViewDirections: allViewDirections,
                lastItem: index == (scheduleLessons.lessons.length-1),
                  lesson: scheduleLessons.lessons[index]);
            }),
          ],
        ),
      );
    }

  }

  class ItemLessonsDetails extends StatelessWidget{
    const ItemLessonsDetails({super.key, required this.lastItem, required this.lesson,required this.allViewDirections});


    final Lesson lesson;
    final bool lastItem;
    final bool allViewDirections;

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
                    Text(DateTimeParser.getDateFromApi(date: lesson.date),
                        style:TStyle.textStyleVelaSansMedium(colorOrange,size: 14.0)),
                    const Gap(5.0),
                    Text(lesson.timePeriod,
                        style:TStyle.textStyleVelaSansRegular(Theme.of(context).textTheme.displayMedium!.color!,size: 12.0)),
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
                              style:TStyle.textStyleVelaSansRegular(Theme.of(context).textTheme.displayMedium!.color!,size: 10.0)),
                        ),
                      ],
                    ),
                    const Gap(5.0),
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
                  Visibility(
                    visible: allViewDirections,
                    child: Text(lesson.nameDirection,
                        style:TStyle.textStyleVelaSansRegular(Theme.of(context).textTheme.displayMedium!.color!,size: 14.0)),
                  ),
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

