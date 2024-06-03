

import 'package:flutter/material.dart';

import '../presentations/teacher/schedule_table_screen/table/my_time_planner.dart';

class TableModeMenu extends StatelessWidget{
  const TableModeMenu({super.key, required this.modeView});
  final Function modeView;

  @override
  Widget build(BuildContext context) {
    return  Container(
      width: 50,
      alignment: Alignment.center,
      padding: const EdgeInsets.only(right: 3.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Theme.of(context).colorScheme.surfaceVariant,
      ),
      child: SelectModeCalendar(
        modeView: (mode){
          modeView.call(mode);
        },
      ),
    );

  }



}