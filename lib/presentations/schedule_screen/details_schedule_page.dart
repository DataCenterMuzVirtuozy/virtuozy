



  import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:virtuozy/presentations/schedule_screen/schedule_page.dart';

import '../../components/app_bar.dart';
import '../../components/drawing_menu_selected.dart';
import '../../resourses/colors.dart';
import '../../router/paths.dart';
import '../../utils/text_style.dart';

class DetailsSchedulePage extends StatelessWidget{
  const DetailsSchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBarCustom(title: 'Подробное расписание'.tr()),
     body: Padding(
       padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
             Column(
               children: List.generate(10, (index) {
                 return  ItemScheduleDetails();
               }),
             ),

           ],
         ),
       ),
     ),
   );
  }

}


  class ItemScheduleDetails extends StatelessWidget{
    ItemScheduleDetails({super.key});


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
              return ItemLessonsDetails(
                lastItem: index == (lessonsTest.length-1),
                  map: lessonsTest[index]);
            }),
          ],
        ),
      );
    }

  }

  class ItemLessonsDetails extends StatelessWidget{
    const ItemLessonsDetails({super.key, required this.map, required this.lastItem});

    final Map<String,String> map;
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

