import 'dart:async';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:time_planner/src/config/global_config.dart' as config;
import 'package:time_planner/time_planner.dart';
import 'package:virtuozy/domain/entities/table_tap_location_entity.dart';
import 'package:virtuozy/presentations/teacher/schedule_table_screen/table/task_lesson.dart';
import 'package:virtuozy/presentations/teacher/schedule_table_screen/table/titles_table_planner.dart';

import '../../../../di/locator.dart';
import '../../../../resourses/colors.dart';
import '../../../../utils/text_style.dart';
import '../../../../utils/theme_provider.dart';
import '../bloc/table_state.dart';

class MyTimePlanner extends StatefulWidget {
  /// Time start from this, it will start from 0
  final int startHour;
  final Color colorDividerVertical;
  final Color colorDividerHorizontal;

  /// Time end at this hour, max value is 23
  final int endHour;

  /// Create days from here, each day is a TimePlannerTitle.
  ///
  /// you should create at least one day
  final List<TitlesTablePlanner> headers;

  /// List of widgets on time planner
  final List<TaskLesson>? tasks;

  /// Style of time planner
  final TimePlannerStyle? style;

  /// When widget loaded scroll to current time with an animation. Default is true
  final bool? currentTimeAnimation;

  /// Whether time is displayed in 24 hour format or am/pm format in the time column on the left.
  final bool use24HourFormat;
  final Function onTapTable;

  //Whether the time is displayed on the axis of the tim or on the center of the timeblock. Default is false.
  final bool setTimeOnAxis;
  final Function modeView;

  /// Time planner widget
  const MyTimePlanner({
    Key? key,
    required this.colorDividerHorizontal,
    required this.colorDividerVertical,
    required this.startHour,
    required this.endHour,
    required this.headers,
    required this.onTapTable,
    this.tasks,
    this.style,
    this.use24HourFormat = false,
    this.setTimeOnAxis = false,
    this.currentTimeAnimation,
    required this.modeView,
  }) : super(key: key);

  @override
  _MyTimePlannerState createState() => _MyTimePlannerState();
}

class _MyTimePlannerState extends State<MyTimePlanner> {
  ScrollController mainHorizontalController = ScrollController();
  ScrollController mainVerticalController = ScrollController();
  ScrollController dayHorizontalController = ScrollController();
  ScrollController timeVerticalController = ScrollController();
  TimePlannerStyle style = TimePlannerStyle();
  List<TaskLesson> tasks = [];
  TableTapLocation tableTapLocation = TableTapLocation.unknown();
  bool? isAnimated = true;
  int yTap = 0;
  int xTap = 0;
  List<List<int>> listIndexByHour = [];
  List<List<int>> listIndexByDays = [];
  final listHourInt = [10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21];
  List<int> listDaysInt = [];
  int countEmptyTask = 0;

  /// check input value rules
  void _checkInputValue() {
    if (widget.startHour > widget.endHour) {
      throw FlutterError("Start hour should be lower than end hour");
    } else if (widget.startHour < 0) {
      throw FlutterError("Start hour should be larger than 0");
    } else if (widget.endHour > 23) {
      throw FlutterError("Start hour should be lower than 23");
    } else if (widget.headers.isEmpty) {
      throw FlutterError("header can't be empty");
    }
  }

  /// create local style
  void _convertToLocalStyle() {
    style.backgroundColor = widget.style?.backgroundColor;
    style.cellHeight = widget.style?.cellHeight ?? 80;
    style.cellWidth = widget.style?.cellWidth ?? 90;
    style.horizontalTaskPadding = widget.style?.horizontalTaskPadding ?? 0;
    style.borderRadius = widget.style?.borderRadius ??
        const BorderRadius.all(Radius.circular(8.0));
    style.dividerColor = widget.style?.dividerColor;
    style.showScrollBar = widget.style?.showScrollBar ?? false;
    style.interstitialOddColor = widget.style?.interstitialOddColor;
    style.interstitialEvenColor = widget.style?.interstitialEvenColor;
  }

  /// store input data to static values
  void _initData() {
    _checkInputValue();
    _convertToLocalStyle();
    config.horizontalTaskPadding = style.horizontalTaskPadding;
    config.cellHeight = style.cellHeight;
    config.cellWidth = style.cellWidth;
    config.totalHours = (widget.endHour - widget.startHour).toDouble();
    config.totalDays = widget.headers.length;
    config.startHour = widget.startHour;
    config.use24HourFormat = widget.use24HourFormat;
    config.setTimeOnAxis = widget.setTimeOnAxis;
    config.borderRadius = style.borderRadius;
    isAnimated = widget.currentTimeAnimation;
    tasks = widget.tasks ?? [];
    final days = widget.headers.length;
    countEmptyTask = 12 * days;
    listDaysInt = List.generate(days, (index) => index);
    for (var i = 0; i < listHourInt.length; i++) {
      listIndexByHour.add(List<int>.generate(days, (index) {
        return (days * (i + 1)) - (days - index);
      }));
    }

    for (var i = 0; i < listDaysInt.length; i++) {
      listIndexByDays.add(List<int>.generate(listHourInt.length, (index) {
        return (listDaysInt.length * index) + i;
      }));
    }
  }

  @override
  void initState() {
    _initData();
    super.initState();
    Future.delayed(Duration.zero).then((_) {
      int hour = DateTime.now().hour;
      if (isAnimated != null && isAnimated == true) {
        if (hour > widget.startHour) {
          double scrollOffset =
              (hour - widget.startHour) * config.cellHeight!.toDouble();
          mainVerticalController.animateTo(
            scrollOffset,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutCirc,
          );
          timeVerticalController.animateTo(
            scrollOffset,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutCirc,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // we need to update the tasks list in case the tasks have changed
    tasks = widget.tasks ?? [];
    mainHorizontalController.addListener(() {
      dayHorizontalController.jumpTo(mainHorizontalController.offset);
    });
    mainVerticalController.addListener(() {
      timeVerticalController.jumpTo(mainVerticalController.offset);
    });
    return Container(
      color: style.backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SingleChildScrollView(
            controller: dayHorizontalController,
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: widget.headers[0].date!.isEmpty ? 30 : 50,
                  width: 60,
                  // child: SelectModeCalendar(
                  //   modeView: (mode){
                  //     widget.modeView.call(mode);
                  //   },
                  // ),
                ),
                for (int i = 0; i < config.totalDays; i++) widget.headers[i],
              ],
            ),
          ),
          Container(
            height: 1,
            color: style.dividerColor ?? Theme.of(context).primaryColor,
          ),
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context)
                      .copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: timeVerticalController,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            //first number is start hour and second number is end hour
                            for (int i = widget.startHour;
                                i <= widget.endHour;
                                i++)
                              Padding(
                                // we need some additional padding horizontally if we're showing in am/pm format
                                padding: EdgeInsets.symmetric(
                                  horizontal: !config.use24HourFormat ? 4 : 0,
                                ),
                                child: MyTimePlannerTime(
                                  // this returns the formatted time string based on the use24HourFormat argument.
                                  time: formattedTime(i),
                                  setTimeOnAxis: config.setTimeOnAxis,
                                ),
                              ),
                            //todo test
                            SizedBox(
                              height: config.cellHeight!.toDouble() - 1,
                              width: 60,
                            )
                          ],
                        ),
                        Container(
                          height: (config.totalHours * config.cellHeight!) + 68,
                          //+config.cellHeight!.toDouble()-1,
                          width: 1,
                          color: style.dividerColor ??
                              Theme.of(context).primaryColor,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: buildMainBody(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMainBody() {
    if (style.showScrollBar!) {
      return Scrollbar(
        controller: mainVerticalController,
        thumbVisibility: false,
        trackVisibility: false,
        interactive: false,
        child: SingleChildScrollView(
          controller: mainVerticalController,
          child: SingleChildScrollView(
            controller: mainHorizontalController,
            scrollDirection: Axis.horizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      height: (config.totalHours * config.cellHeight!) + 80,
                      width: (config.totalDays * config.cellWidth!).toDouble(),
                      child: Stack(
                        children: <Widget>[
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              for (var i = 0; i < 12; i++) ...{
                                GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onDoubleTap: () {
                                    yTap = i;
                                    tableTapLocation = tableTapLocation
                                        .copyWith(x: xTap, y: yTap);
                                    widget.onTapTable.call(tableTapLocation);
                                  },
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Container(
                                        color: i.isOdd
                                            ? style.interstitialOddColor
                                            : style.interstitialEvenColor,
                                        height:
                                            (config.cellHeight! - 1).toDouble(),
                                      ),
                                      // The horizontal lines tat divides the rows
                                      Divider(
                                        height: 1,
                                        color: widget.colorDividerHorizontal,
                                      ),
                                    ],
                                  ),
                                )
                              },
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              for (var i = 0; i < config.totalDays; i++)
                                GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onPanDown: (d) {
                                    xTap = i;
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      SizedBox(
                                        width:
                                            (config.cellWidth! - 1).toDouble(),
                                      ),
                                      // The vertical lines that divides the columns
                                      Container(
                                        width: 0.3,
                                        height: (config.totalHours *
                                                config.cellHeight!) +
                                            config.cellHeight!,
                                        color: widget.colorDividerVertical,
                                      )
                                    ],
                                  ),
                                )
                            ],
                          ),

                          ///LONG PRESSED
                          ///
                          ...List.generate(countEmptyTask, (i) {
                            return TaskEmpty(
                              onTableTapLocation: (TableTapLocation value) {
                                widget.onTapTable.call(value);
                              },
                              index: i,
                              listIndexByHour: listIndexByHour,
                              listHourInt: listHourInt,
                              listDaysInt: listDaysInt,
                              listIndexByDays: listIndexByDays,
                              mainVerticalController: mainVerticalController,
                            );
                          }),

                          for (int i = 0; i < tasks.length; i++) tasks[i],
                        ],
                      ),
                    ),
                  ],
                ),

                ///bottom space
                Padding(
                  padding: const EdgeInsets.only(right: 3.5),
                  child: Row(
                    children: [
                      for (var i = 0; i < config.totalDays; i++)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              height: 1,
                              color: widget.colorDividerHorizontal,
                              width: (config.cellWidth! - 1).toDouble(),
                            ),
                            Container(
                              width: 0.3,
                              height: 80,
                              color: widget.colorDividerVertical,
                            )
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      controller: mainVerticalController,
      child: SingleChildScrollView(
        controller: mainHorizontalController,
        scrollDirection: Axis.horizontal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: (config.totalHours * config.cellHeight!) + 80,
                  width: (config.totalDays * config.cellWidth!).toDouble(),
                  child: Stack(
                    children: <Widget>[
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          for (var i = 0; i < config.totalHours; i++)
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                SizedBox(
                                  height: (config.cellHeight! - 1).toDouble(),
                                ),
                                Divider(
                                  height: 0.3,
                                  color: widget.colorDividerHorizontal,
                                ),
                              ],
                            )
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          for (var i = 0; i < config.totalDays; i++)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                SizedBox(
                                  width: (config.cellWidth! - 1).toDouble(),
                                ),
                                Container(
                                  width: 0.3,
                                  height:
                                      (config.totalHours * config.cellHeight!) +
                                          config.cellHeight!,
                                  color: widget.colorDividerVertical,
                                )
                              ],
                            )
                        ],
                      ),
                      for (int i = 0; i < tasks.length; i++) tasks[i],
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String formattedTime(int hour) {
    /// this method formats the input hour into a time string
    /// modifing it as necessary based on the use24HourFormat flag .
    if (config.use24HourFormat) {
      // we use the hour as-is
      return '$hour:00 ${hour + 1}:00';
    } else {
      // we format the time to use the am/pm scheme
      if (hour == 0) return "12:00 am";
      if (hour < 12) return "$hour:00 am";
      if (hour == 12) return "12:00 pm";
      return "${hour - 12}:00 pm";
    }
  }
}

class TaskEmpty extends StatefulWidget {
  const TaskEmpty(
      {super.key,
      required this.index,
      required this.listIndexByHour,
      required this.listHourInt,
      required this.listIndexByDays,
      required this.listDaysInt,
      required this.onTableTapLocation,
      required this.mainVerticalController});

  final int index;
  final ScrollController mainVerticalController;
  final Function onTableTapLocation;
  final List<List<int>> listIndexByHour;
  final List<int> listHourInt;
  final List<List<int>> listIndexByDays;
  final List<int> listDaysInt;

  @override
  State<TaskEmpty> createState() => _TaskEmptyState();
}

class _TaskEmptyState extends State<TaskEmpty> {
  double widthBorder = 0.0;
  Color colorChoiceTable = Colors.transparent;


  int yLocation(int index) {
    int y = 0;
    for (var h in widget.listIndexByHour) {
      if (h.contains(index)) {
        y = widget.listHourInt[widget.listIndexByHour.indexOf(h)];
      }
    }
    return y;
  }

  int xLocation(int index) {
    int x = 0;
    for (var h in widget.listIndexByDays) {
      if (h.contains(index)) {
        x = widget.listDaysInt[widget.listIndexByDays.indexOf(h)];
      }
    }

    return x;
  }

  int indexX(int index) {
    for (var h in widget.listIndexByDays) {
      if (h.contains(index)) {
        return widget.listIndexByDays.indexOf(h);
      }
    }
    return -1;
  }

  int indexY(int index) {
    for (var h in widget.listIndexByHour) {
      if (h.contains(index)) {
        return widget.listIndexByHour.indexOf(h);
      }
    }
    return -1;
  }

  bool longPress = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var x = xLocation(widget.index);
    var y = yLocation(widget.index);

    return Positioned(
      top: ((config.cellHeight! * (y - config.startHour)) +
              ((0 * config.cellHeight!) / 60))
          .toDouble(),
      left: config.cellWidth! * x.toDouble(),
      child: GestureDetector(
        onDoubleTap: () {
          widget.onTableTapLocation.call(TableTapLocation(
              y: indexY(widget.index), x: indexX(widget.index)));
        },

        onTapDown: (f){
          setState(() {
            colorChoiceTable = colorOrange;
            widthBorder = 1.5;
          });
        },
        onPanCancel: () {
          if (!longPress) {
            setState(() {
              colorChoiceTable = Colors.transparent;
              widthBorder = 0.0;
            });
          }
        },

        onTapUp: (d) {
          setState(() {
            colorChoiceTable = Colors.transparent;
            widthBorder = 0.0;

          });
        },
        onLongPress: (){
    setState(() {
        colorChoiceTable = colorOrange;
        widthBorder = 1.5;
      });
        },
        onLongPressEnd: (d) {
          setState(() {
            colorChoiceTable = Colors.transparent;
            widthBorder = 0.0;
          });
        },
        onLongPressUp: () {
          setState(() {
            widget.onTableTapLocation.call(TableTapLocation(
                y: indexY(widget.index), x: indexX(widget.index)));
            colorChoiceTable = Colors.transparent;
            widthBorder = 0.0;

          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 89,
          height: 80,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: colorChoiceTable, width: widthBorder)),
        ),
      ),
    );
  }
}

class MyTimePlannerTime extends StatelessWidget {
  /// Text it will be show as hour
  final String? time;
  final bool? setTimeOnAxis;

  /// Show the hour for each row of time planner
  const MyTimePlannerTime({
    Key? key,
    this.time,
    this.setTimeOnAxis,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: config.cellHeight!.toDouble() - 1,
      width: 60,
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: setTimeOnAxis!
            ? Text(
                time!,
                style: TStyle.textStyleVelaSansMedium(
                    Theme.of(context).textTheme.displayMedium!.color!,
                    size: 12.0),
              )
            : Center(
                child: Text(
                time!,
                style: TStyle.textStyleVelaSansMedium(
                    Theme.of(context).textTheme.displayMedium!.color!,
                    size: 12.0),
              )),
      ),
    );
  }
}

class SelectModeCalendar extends StatefulWidget {
  const SelectModeCalendar({super.key, required this.modeView});

  final Function modeView;

  @override
  State<SelectModeCalendar> createState() => _SelectModeCalendarState();
}

class _SelectModeCalendarState extends State<SelectModeCalendar> {
  final themeProvider = locator.get<ThemeProvider>();
  final List<String> items = [
    'День',
    'Неделя',
    'Мое расписание',
  ];

  String? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = items[0];
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        // hint: Text(selectedValue!,
        //     textAlign: TextAlign.center,
        //     style: TStyle.textStyleVelaSansExtraBolt(Theme
        //         .of(context)
        //         .textTheme
        //         .displayMedium!
        //         .color!, size: 13.0)),
        items: items
            .map((String item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: TStyle.textStyleVelaSansExtraBolt(
                        Theme.of(context).textTheme.displayMedium!.color!,
                        size: 13.0),
                    overflow: TextOverflow.ellipsis,
                  ),
                ))
            .toList(),
        value: selectedValue,
        onChanged: (value) {
          setState(() {
            selectedValue = value;
            widget.modeView.call(selectedValue == 'День'
                ? ViewModeTable.day
                : selectedValue == 'Неделя'
                    ? ViewModeTable.week
                    : ViewModeTable.my);
          });
        },
        buttonStyleData: ButtonStyleData(
          width: 100,
          padding: const EdgeInsets.symmetric(horizontal: 13.0),
          // decoration: BoxDecoration(
          //   borderRadius: BorderRadius.circular(20.0),
          //   color: Theme
          //       .of(context)
          //       .colorScheme
          //       .surfaceVariant,
          // ),
          //elevation: 2,
        ),
        iconStyleData: IconStyleData(
          icon: const Icon(
            Icons.table_chart_outlined,
          ),
          iconSize: 18,
          iconEnabledColor: Theme.of(context).textTheme.displayMedium!.color!,
          iconDisabledColor: colorGrey,
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 300,
          width: 150,
          elevation: 2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: themeProvider.themeStatus == ThemeStatus.dark
                ? colorBlack
                : colorBeruza2,
          ),
          offset: const Offset(20, -10),
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
