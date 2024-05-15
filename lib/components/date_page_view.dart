

  import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:virtuozy/domain/entities/lesson_entity.dart';
import 'package:virtuozy/domain/entities/today_lessons.dart';

import '../utils/text_style.dart';

class DatePageView extends StatefulWidget{
  const DatePageView({super.key,required, required this.lessonsToday, required this.onChangePage});

  final List<TodayLessons> lessonsToday;
  final Function onChangePage;

  @override
  State<DatePageView> createState() => _DatePageViewState();
}




class _DatePageViewState extends State<DatePageView> {


  late PageController _pageController;
  int page = 0;
  int countLessons = 0;



  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
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
                       page--;
                     }
                     widget.onChangePage.call(page);
                     _pageController.animateToPage(page,duration: const Duration(milliseconds: 400), curve: Curves.easeIn);

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
                 controller: _pageController,
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
                   page++;
                 }
                 widget.onChangePage.call(page);
                 _pageController.animateToPage(page,duration: const Duration(milliseconds: 400), curve: Curves.easeIn);
               },
                   icon:  Icon(Icons.arrow_forward_ios_rounded,
                     size: 16,
                     color: Theme.of(context)
                         .textTheme.displayMedium!.color!,))),
         ],
       ));
  }


  //'8 ноя. 2023'
   String parseDate(String date){
    print('Date $date');
    final y = date.split('-')[0];
    final d = date.split('-')[1].split('-')[0];
    final m = switch(date.split('-')[1].split('-')[0]){
      '01' => 'янв.',
      '02' => 'февр.',
      '03' => 'март',
      '04' => 'апрель',
      '05' => 'май',
      '06' => 'июнь',
      '07' => 'июль',
      '08' => 'авг.',
      '09' => 'сент.',
      '10' => 'октяб.',
      '11' => 'ноябрь',
      '12' => 'дек.',
      String() => throw UnimplementedError(),
    };

     return  '$d $m $y';
   }

}