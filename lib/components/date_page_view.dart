

  import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:virtuozy/domain/entities/lesson_entity.dart';
import 'package:virtuozy/domain/entities/today_lessons.dart';
import 'package:virtuozy/presentations/teacher/today_schedule_screen/time_line_list.dart';

import '../utils/text_style.dart';
import 'dialogs/dialoger.dart';


  late PageController pageControllerDates;
class DatePageView extends StatefulWidget{
  const DatePageView({super.key,required, required this.lessonsToday, required this.initIndex, required this.onVisibleTodayButton});

  final List<TodayLessons> lessonsToday;
  final int initIndex;
  final Function onVisibleTodayButton;

  @override
  State<DatePageView> createState() => _DatePageViewState();
}




class _DatePageViewState extends State<DatePageView> {


  int page = 0;
  int countLessons = 0;



  @override
  void initState() {
    super.initState();
    pageControllerDates = PageController(initialPage: widget.initIndex);
    pageControllerDates.addListener(() {
      if(widget.lessonsToday[pageControllerDates.page!.toInt()].date=='2024-05-18'){
         widget.onVisibleTodayButton.call(false);
      }else{
        widget.onVisibleTodayButton.call(true);
      }
    });
    page = widget.initIndex;
    countLessons = widget.lessonsToday.length;

  }

  @override
  Widget build(BuildContext context) {
   return                 Container(
       alignment: Alignment.center,
       width: 200.0,
       decoration: BoxDecoration(
           color: Theme.of(context).colorScheme.surfaceVariant,
           borderRadius: BorderRadius.circular(20.0)),
       child: Flex(
         crossAxisAlignment: CrossAxisAlignment.center,
         mainAxisAlignment: MainAxisAlignment.center,
         direction: Axis.horizontal,
         children: [
           Flexible(
               flex: 1,
               child: IconButton(
                   onPressed: () {
                     if(page > 0){
                       page = pageControllerDates.page!.toInt()-1;
                     }

                     if (pageControllerDates.page!.toInt() ==
                         0) {
                       Dialoger.showMessage('Нет записей'.tr(),context: context);
                       return;
                     }
                     pageControllerDates.animateToPage(page,duration: const Duration(milliseconds: 400), curve: Curves.ease);
                     pageControllerTimeList.animateToPage(page,
                         duration: const Duration(milliseconds: 400), curve: Curves.ease);
                   },
                   icon: Icon(
                     Icons.arrow_back_ios_rounded,
                     size: 16,
                     color: Theme.of(context)
                         .textTheme
                         .displayMedium!
                         .color!,
                   ))),
           Flexible(
             flex: 2,
             child: SizedBox(
               height: 20.0,
               child: PageView(
                 physics: const NeverScrollableScrollPhysics(),
                 controller: pageControllerDates,
                 children: [
                   ...List.generate(countLessons, (index) {
                     return Text(parseDate(widget.lessonsToday[index].date),
                         textAlign: TextAlign.center,
                         style:TStyle.textStyleVelaSansExtraBolt(Theme.of(context)
                             .textTheme.displayMedium!.color!,size: 13.0));
                   })

                 ],
               ),
             ),
           ),
           Flexible(
               flex: 1,
               child: IconButton(onPressed: (){
                 if(page < countLessons-1){
                   page = pageControllerDates.page!.toInt()+1;
                 }

                 if (pageControllerDates.page!.toInt() ==
                          countLessons - 1) {
                   Dialoger.showMessage('Нет записей'.tr(),context: context);
                        return;
                      }

                      pageControllerDates.animateToPage(page,duration: const Duration(milliseconds: 400), curve: Curves.ease);
                 pageControllerTimeList.animateToPage(page,
                     duration: const Duration(milliseconds: 400), curve: Curves.ease);
               },
                   icon:  Icon(Icons.arrow_forward_ios_rounded,
                     size: 16,
                     color: Theme.of(context)
                         .textTheme.displayMedium!.color!,))),
         ],
       ));
  }



   String parseDate(String date){
    final d = DateFormat('yyyy-MM-dd').parse(date);
    final m = switch(d.month){
       1=> 'янв.',
      2 => 'февр.',
       3=> 'март',
      4 => 'апрель',
       5=> 'май',
      6 => 'июнь',
      7 => 'июль',
      8 => 'авг.',
      9 => 'сент.',
      10 => 'октяб.',
      11 => 'ноябрь',
      12 => 'дек.',
      int() => throw UnimplementedError(),
    };

     return  '${d.day} $m ${d.year}';
   }

}