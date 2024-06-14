



 import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:virtuozy/domain/entities/lesson_entity.dart';
import 'package:virtuozy/domain/entities/today_lessons.dart';
import 'package:virtuozy/presentations/teacher/today_schedule_screen/bloc/today_schedule_bloc.dart';
import 'package:virtuozy/resourses/colors.dart';
import 'package:virtuozy/utils/auth_mixin.dart';
import 'package:virtuozy/utils/status_to_color.dart';

import '../../../components/dialogs/dialoger.dart';
import '../../../components/dialogs/sealeds.dart';
import '../../../utils/text_style.dart';

class TimelineSchedule extends StatefulWidget{

   const TimelineSchedule({super.key,required this.todayLessons});


   final TodayLessons todayLessons;

  @override
  State<TimelineSchedule> createState() => _TimelineScheduleState();
}

class _TimelineScheduleState extends State<TimelineSchedule> with AuthMixin{


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

   String idSchool = '';



   @override
  void initState() {
    super.initState();

  }


   @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    idSchool = context.watch<TodayScheduleBloc>().state.currentIdSchool;
  }

  (bool,Lesson) indexView(TodayLessons less,String time){
     bool view = false;
     Lesson lesson = Lesson.unknown();
     for(var i in less.lessons){
       if(time == i.timePeriod){
         view =  true;
         lesson = i;
       }
     }
     return (view,lesson);
  }

  @override
  Widget build(BuildContext context) {
   return ListView.builder(
     itemCount: _times.length,
       itemBuilder: (context,index){
       var data = indexView(widget.todayLessons, _times[index]);

       return Stack(
            alignment: Alignment.center,
            children: [
              Visibility(
                visible: data.$1,
                child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
                    width: MediaQuery.sizeOf(context).width,
                    decoration: BoxDecoration(
                      border: Border.all(color: colorOrange,width: 0.5),
                        //color: Theme.of(context).colorScheme.surfaceVariant,
                      color:  Theme.of(context).colorScheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(5.0)),
                    child: IntrinsicHeight(
                      child: Row(
                         children: [
                           Container(
                             width: 5.0,
                             margin: const EdgeInsets.only(right: 10.0),
                             decoration: BoxDecoration(
                               color: StatusToColor.getColor(lessonStatus:data.$2.status),
                               // border: Border.all(
                               //   color: colorOrange,
                               //   width: 1
                               // ),
                               borderRadius: const BorderRadius.only(topLeft: Radius.circular(10.0),bottomLeft: Radius.circular(10.0))
                             ),
                           ),

                           Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10.0,left: 110.0,top: 10.0,bottom: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Text(data.$2.type.isGroup?
                                data.$2.nameGroup:data.$2.nameStudent.isEmpty?'...':data.$2.nameStudent,
                                    style:
                                TStyle.textStyleVelaSansRegular(Theme.of(context)
                                      .textTheme.displayMedium!.color!,size: 14.0)),
                              ),
                              const Gap(5.0),
                             Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon(Icons.directions,
                                            color: colorGrey,size: 14.0),
                                        const Gap(5),
                                        Text(data.$2.nameDirection,
                                            textAlign: TextAlign.end,
                                            style:
                                            TStyle.textStyleVelaSansExtraBolt(
                                                Theme.of(context)
                                                    .textTheme.displayMedium!.color!,
                                                size: 12.0)),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon(Icons.door_back_door_outlined,
                                            color: colorGrey,size: 14.0),
                                        const Gap(5),
                                        Text(data.$2.idAuditory,
                                            textAlign: TextAlign.end,
                                            style:
                                        TStyle.textStyleVelaSansExtraBolt(
                                            Theme.of(context)
                                                .textTheme.displayMedium!.color!,
                                            size: 12.0)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                         ],
                      ),
                    )
                ),
              ),
              InkWell(
                onTap: (){
                  if(data.$1){
                    Dialoger.showModalBottomMenu(
                        blurred: true,
                        title: 'Информация об уроке'.tr(),
                        args: [data.$2,false],
                        content: InfoStatusLesson());
                    return;
                  };

                  Dialoger.showModalBottomMenu(
                      blurred: true,
                      args: [_addLesson(
                          idSchool: idSchool,
                          nameTeacher: '${teacher.firstName} ${teacher.lastName}',
                          idTeacher: teacher.id,
                          timePeriod: _times[index],
                          dateDay: widget.todayLessons.date),true],
                      title: 'Добавить урок'.tr(),
                      content: AddLesson());
                },
                child: Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.symmetric(vertical: 5.0,horizontal: 20.0),
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text(_times[index],
                      style:data.$1?
                      TStyle.textStyleVelaSansExtraBolt(Theme.of(context)
                          .textTheme.displayMedium!.color!,size: 15.0):
                         TStyle.textStyleOpenSansRegular(Theme.of(context)
                             .textTheme.displayMedium!.color!,size: 15.0))),
              ),

            ],
          );
       });
  }

   Lesson _addLesson(
       {required String timePeriod,
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
         idAuditory: '',
         nameTeacher: nameTeacher,
         nameStudent: '',
         status: LessonStatus.firstLesson,
         nameDirection: '',
         online: false);
   }

}