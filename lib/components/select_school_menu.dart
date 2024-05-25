

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:virtuozy/presentations/teacher/today_schedule_screen/bloc/today_schedule_state.dart';

import '../resourses/colors.dart';
import '../utils/text_style.dart';

class SelectSchoolMenu extends StatefulWidget{
  const SelectSchoolMenu({super.key, required this.idsSchool, required this.onChange, required this.currentIdSchool, required this.loading});


   final List<String> idsSchool;
  final Function onChange;
  final String currentIdSchool;
  final bool loading;


  @override
  State<SelectSchoolMenu> createState() => _SelectSchoolMenuState();
}

class _SelectSchoolMenuState extends State<SelectSchoolMenu> {


  String? selectedValue= '...';


  @override
  void initState() {
    super.initState();
    selectedValue = widget.currentIdSchool;
    print('Items ${widget.idsSchool}');
  }

  @override
  Widget build(BuildContext context) {
    if(widget.loading){
      return Container(
        alignment: Alignment.center,
        height: 35,
        padding:const EdgeInsets.symmetric(horizontal: 30.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color:Theme.of(context).colorScheme.surfaceVariant,
        ),
        child: Text(
          '...',
          style: TStyle.textStyleVelaSansExtraBolt(Theme.of(context)
              .textTheme.displayMedium!.color!,size: 18.0),
          overflow: TextOverflow.ellipsis,
        ),
      );
    }
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        hint:  Text(selectedValue!,
            textAlign: TextAlign.center,
            style:TStyle.textStyleVelaSansExtraBolt(Theme.of(context)
                .textTheme.displayMedium!.color!,size: 13.0)),
        items: widget.idsSchool
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
            selectedValue = value!;
            widget.onChange.call(selectedValue);
          });
        },
        buttonStyleData: ButtonStyleData(
          width: 75,
          padding:const EdgeInsets.symmetric(horizontal: 13.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color:Theme.of(context).colorScheme.surfaceVariant,
          ),
          //elevation: 2,
        ),
        iconStyleData:  IconStyleData(
          icon: const Icon(
            Icons.arrow_drop_down_rounded,
          ),
          iconSize: 18,
          iconEnabledColor: colorGrey,
          iconDisabledColor: Theme.of(context)
              .textTheme.displayMedium!.color!,
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 300,
          width: 75,
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
    );
  }
}