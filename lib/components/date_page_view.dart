

  import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/text_style.dart';

class DatePageView extends StatefulWidget{
  const DatePageView({super.key});

  @override
  State<DatePageView> createState() => _DatePageViewState();
}




class _DatePageViewState extends State<DatePageView> {


  late PageController _pageController;


  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
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
                     // _pageController1.nextPage(duration: const Duration(milliseconds: 700), curve: Curves.easeIn);
                     // _pageController2.animateToPage(1,duration: const Duration(milliseconds: 700), curve: Curves.easeIn);
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
                   Text('8 ноя. 2023',
                       textAlign: TextAlign.center,
                       style:TStyle.textStyleVelaSansExtraBolt(Theme.of(context)
                           .textTheme.displayMedium!.color!,size: 13.0)),
                   Text('9 ноя. 2023',
                       style:TStyle.textStyleVelaSansExtraBolt(Theme.of(context)
                           .textTheme.displayMedium!.color!,size: 13.0)),
                   Text('10 ноя. 2023',
                       style:TStyle.textStyleVelaSansExtraBolt(Theme.of(context)
                           .textTheme.displayMedium!.color!,size: 13.0))
                 ],
               ),
             ),
           ),
           Flexible(
               flex: 1,
               child: IconButton(onPressed: (){
                 // _pageController1.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeIn);
                 // _pageController2.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeIn);
               },
                   icon:  Icon(Icons.arrow_forward_ios_rounded,
                     size: 16,
                     color: Theme.of(context)
                         .textTheme.displayMedium!.color!,))),
         ],
       ));
  }
}