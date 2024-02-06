


 import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:virtuozy/router/paths.dart';
import 'package:virtuozy/utils/auth_mixin.dart';

import '../../components/box_info.dart';
import '../../components/calendar.dart';
import '../../components/drawing_menu_selected.dart';
import '../../resourses/colors.dart';
import '../../utils/text_style.dart';

class SchedulePage extends StatefulWidget{
   const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> with AuthMixin{
  @override
  Widget build(BuildContext context) {

    if(notAuthorized){
      return Center(
        child: BoxInfo(title: 'Расписание недоступно'.tr(),
            description: 'Для работы с расписанием необходимо авторизироваться'.tr(),
            iconData: Icons.calendar_month),
      );
    }


    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            //todo local
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: DrawingMenuSelected(items: [
                'Вокал'.tr(),
                'Академический вокал'.tr(),
                'Фортепиано'.tr(),
                'Все направления'.tr()
              ], onSelected: (index){

              },),
            ),
            const Gap(10.0),
            const Calendar(),
            const Gap(10.0),
            Column(
              children: List.generate(1, (index) {
                return  ItemSchedule();
              }),
            ),

          ],
        ),
      ),
    );

  }
}

 class ItemSchedule extends StatelessWidget{
   ItemSchedule({super.key});


  final List<Map<String,String>> lessonsTest = [
    {
   'date':'01.11.23',
   'time_period':'10:00 - 10:55',
   'name_direction':'Вокал',
   'name_audience':'122',
      'name_teacher':'Иванов И.И.'
    },
    {
      'date':'01.11.23',
      'time_period':'14:00 - 14:55',
      'name_direction':'Вокал',
      'name_audience':'122',
      'name_teacher':'Иванов И.И.'
    },
    {
      'date':'01.11.23',
      'time_period':'15:00 - 15:55',
      'name_direction':'Вокал',
      'name_audience':'122',
      'name_teacher':'Иванов И.И.'
    },
    {
      'date':'01.11.23',
      'time_period':'17:00 - 17:55',
      'name_direction':'Вокал',
      'name_audience':'1224',
      'name_teacher':'Иванов И.И.'
    },

  ];

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
          //todo local
          Text('Уроки в ноябре',style:TStyle.textStyleVelaSansExtraBolt(colorBlack,size: 18.0)),
          const Gap(10.0),
          ...List.generate(lessonsTest.length, (index) {
            return ItemLessons(map: lessonsTest[index]);
          }),
          Center(child: TextButton(onPressed: () {
              GoRouter.of(context).push(pathDetailsSchedule);
          },
              child: Text('Подробное расписание'.tr(),
                      style: TStyle.textStyleVelaSansRegularUnderline(
                          colorBlack,
                          size: 16.0)))),
        ],
      ),
    );
  }

 }


 class ItemLessons extends StatelessWidget{
  const ItemLessons({super.key, required this.map});

  final Map<String,String> map;

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
                 Text(map['date']!,
                     style:TStyle.textStyleVelaSansMedium(colorOrange,size: 14.0)),
                 const Gap(5.0),
                 Text(map['time_period']!,
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
               Text(map['name_direction']!,
                   style:TStyle.textStyleVelaSansRegular(colorBlack,size: 14.0)),
               //todo local
               Text('Аудитория ${map['name_audience']!}',
                   style:TStyle.textStyleVelaSansRegular(colorBlack,size: 14.0)),
               Text(map['name_teacher']!,
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

