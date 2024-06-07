

  import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../di/locator.dart';
import '../resourses/colors.dart';
import '../utils/text_style.dart';
import '../utils/theme_provider.dart';

class DropMenu extends StatefulWidget{
  const DropMenu({super.key, required this.items, required this.onChange,
  this.selectedValue = '',
  this.width = 0.0,
    this.widthDrop = 0.0,  this.alignment = Alignment.centerLeft});

  final List<String> items;
  final Function onChange;
  final String selectedValue;
  final double width;
  final double widthDrop;
  final Alignment alignment;

  @override
  State<DropMenu> createState() => _DropMenuState();
}

class _DropMenuState extends State<DropMenu> {


  bool _openMenu = false;
  String? selectedValue = '...';
  final themeProvider = locator.get<ThemeProvider>();
  double width = 0.0;
  double widthDrop = 0.0;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.selectedValue.isEmpty?widget.items[0]:widget.selectedValue;

  }


  @override
  Widget build(BuildContext context) {

    width = widget.width == 0.0?MediaQuery
        .of(context)
        .size
        .width - 40:widget.width;

   widthDrop = widget.widthDrop == 0.0?width:widget.widthDrop;


    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        hint: Text(selectedValue!,
            textAlign: TextAlign.center,
            style: TStyle.textStyleVelaSansExtraBolt(Theme
                .of(context)
                .textTheme
                .displayMedium!
                .color!, size: 13.0)),
        items: widget.items
            .map((String item) =>
            DropdownMenuItem<String>(
              value: item,
              child: Align(
                alignment: widget.alignment,
                child: Text(
                  item,
                  style: TStyle.textStyleVelaSansExtraBolt(Theme
                      .of(context)
                      .textTheme
                      .displayMedium!
                      .color!, size: 13.0),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ))
            .toList(),
        value: selectedValue,
        onChanged: (value) {
          setState(() {
            selectedValue = value;
            widget.onChange.call(selectedValue);
          });
        },
        onMenuStateChange: (open) {
          setState(() {
            _openMenu = open;
          });
        },
        buttonStyleData: ButtonStyleData(
          width: width,
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Theme
                .of(context)
                .colorScheme
                .surfaceVariant,
          ),
          //elevation: 2,
        ),
        iconStyleData: IconStyleData(
          icon: RotatedBox(
            quarterTurns: _openMenu ? 4 : 2,
            child: const Icon(
              Icons.arrow_drop_down_rounded,
            ),
          ),
          iconSize: 18,
          iconEnabledColor: colorGrey,
          iconDisabledColor: Theme
              .of(context)
              .textTheme
              .displayMedium!
              .color!,
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 400,
          width: widthDrop,
          elevation: 0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: themeProvider.themeStatus == ThemeStatus.dark?colorBlack:colorBeruza2,
          ),
          offset: const Offset(-10, -10),
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