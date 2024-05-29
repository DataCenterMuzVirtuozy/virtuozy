


 import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';

import '../../../../resourses/colors.dart';
import '../../../../utils/text_style.dart';
import '../../../buttons.dart';


  PageController pageController = PageController();

class AddLessonContent extends StatefulWidget{
  const AddLessonContent({super.key});

  @override
  State<AddLessonContent> createState() => _AddLessonContentState();
}

class _AddLessonContentState extends State<AddLessonContent> {


  final List<double> _heightBody = [200.0, 800.0];
  int _stepIndex = 0;

  @override
  Widget build(BuildContext context) {
   return AnimatedContainer(
     padding: const EdgeInsets.symmetric(horizontal: 20),
     height: _heightBody[_stepIndex],
     duration: const Duration(milliseconds: 700),
     constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height-200),
     child: PageView.builder(
       controller: pageController,
         physics: const NeverScrollableScrollPhysics(),
         itemBuilder: (context,index){
        return [Step1(onNext: () {
          setState(() {
            _stepIndex = 1;
          });
        },),Step2()][index];
     }),
   );
  }
}


  class Step1 extends StatefulWidget{
  const Step1({super.key, required this.onNext});

  final VoidCallback onNext;

  @override
  State<Step1> createState() => _Step1State();
}

class _Step1State extends State<Step1> {

  String? selectedValue= '...';

  final List<String> items = [
    'Не выбрано',
    'Индивидуальные',
    'Можно ПУ',
    'Групповой',
  ];
  bool _openMenu = false;


  @override
  void initState() {
    super.initState();
   selectedValue = items[0];


  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
       children: [
         Align(
           alignment: Alignment.centerLeft,
           child: Padding(
             padding: const EdgeInsets.only(left: 20),
             child: Text('Тип занятия'.tr(),
                 style: TStyle.textStyleVelaSansBold(textColorBlack(context),size: 20)),
           ),
         ),
    const Gap(10),
    DropdownButtonHideUnderline(
    child: DropdownButton2<String>(
      isExpanded: true,
      hint:  Text(selectedValue!,
          textAlign: TextAlign.center,
          style:TStyle.textStyleVelaSansExtraBolt(Theme.of(context)
              .textTheme.displayMedium!.color!,size: 13.0)),
      items: items
          .map((String item) => DropdownMenuItem<String>(
        value: item,
        child: Text(
          item,
          style: TStyle.textStyleVelaSansExtraBolt(Theme.of(context)
              .textTheme.displayMedium!.color!,size: 13.0),
          overflow: TextOverflow.ellipsis,
        ),
      ))
          .toList(),
      value: selectedValue,
      onChanged: (value) {
        setState(() {
          selectedValue = value;
        });
      },
      onMenuStateChange: (open){
        setState(() {
          _openMenu = open;
        });
      },
      buttonStyleData: ButtonStyleData(
        width: MediaQuery.of(context).size.width-40,
        padding:const EdgeInsets.symmetric(horizontal: 20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color:Theme.of(context).colorScheme.surfaceVariant,
        ),
        //elevation: 2,
      ),
      iconStyleData:  IconStyleData(
        icon: RotatedBox(
          quarterTurns: _openMenu?4:2,
          child: const Icon(
            Icons.arrow_drop_down_rounded,
          ),
        ),
        iconSize: 18,
        iconEnabledColor: colorGrey,
        iconDisabledColor: Theme.of(context)
            .textTheme.displayMedium!.color!,
      ),
      dropdownStyleData: DropdownStyleData(
        maxHeight: 400,
        width:   MediaQuery.of(context).size.width-40,
        elevation: 0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: colorGrey,
        ),
        offset: const Offset(0,-10),
        scrollbarTheme: ScrollbarThemeData(
          radius: const Radius.circular(40),
          thickness: MaterialStateProperty.all(6),
          thumbVisibility: MaterialStateProperty.all(true),
        ),
      ),
      menuItemStyleData: const MenuItemStyleData(
        height: 40,
        padding: EdgeInsets.only(left: 14, right: 14),
      ),
    ),
    ),

         const Gap(20),
       InkWell(
         onTap: (){
           widget.onNext.call();
           pageController.animateToPage(1,
               duration: const Duration(milliseconds: 700),
               curve: Curves.ease);
         },
         child: Row(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             Text('Сохранить и продолжить'.tr(),
               style: TStyle.textStyleVelaSansBold(colorGreen,size: 16)),
            const Gap(8),
            Icon(Icons.arrow_forward_rounded,color: colorGreen,)
           ],
         ),
       ),
         TextButton(onPressed: (){
           Navigator.pop(context);
         }, child: Text('Закрыть'.tr(),
           style: TStyle.textStyleVelaSansMedium(colorRed,size: 16),)),
       ],
    );
  }
}

 class Step2 extends StatelessWidget{
   @override
   Widget build(BuildContext context) {
     // TODO: implement build
     throw UnimplementedError();
   }
 }