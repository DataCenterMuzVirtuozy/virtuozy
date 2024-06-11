



 import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:virtuozy/components/app_bar.dart';
import 'package:virtuozy/components/buttons.dart';
import 'package:virtuozy/resourses/colors.dart';

import '../../../di/locator.dart';
import '../../../utils/preferences_util.dart';
import '../../../utils/text_style.dart';
import '../../../utils/theme_provider.dart';


class ThemePage extends StatefulWidget{
  const ThemePage({super.key});

  @override
  State<ThemePage> createState() => _ThemePageState();
}

class _ThemePageState extends State<ThemePage> {


  final _themeProvider = locator.get<ThemeProvider>();
  ThemeStatus _themeStatus = ThemeStatus.first;
  late Color? _selectColor;
  bool _isSelect = false;
  static const List<Color> _colors = [
   Color.fromRGBO(31, 162, 184, 1.0),
   Color.fromRGBO(31, 162, 184, 0.1),
    Color.fromRGBO(233, 250, 69, 1.0),
  Color.fromRGBO(247, 196, 94, 1.0),
  Color.fromRGBO(0, 148, 77, 1.0),
    Color.fromRGBO(15, 99, 72, 1.0),
    Color.fromRGBO(76, 140, 244, 1.0),
    Color.fromRGBO(162, 41, 162, 1.0),
    Color.fromRGBO(180, 76, 244, 1.0),
    Color.fromRGBO(241, 76, 244, 1.0),
    Color.fromRGBO(228, 96, 54, 1.0),
    Color.fromRGBO(186,12,0, 1.0),
    Color.fromRGBO(250, 138, 69,1.0),
    Color.fromRGBO(69, 250, 221, 1.0),
    Color.fromRGBO(37, 116, 103, 1.0),
    Color.fromRGBO(37, 103, 116, 1.0),
    Color.fromRGBO(41, 104, 162, 1.0),


    //dark and light theme
    Color.fromRGBO(134, 152, 149, 1.0),
    Colors.black,
  ];


  @override
  void initState() {
    super.initState();
   //_themeStatus=PreferencesUtil.getTheme;
    _themeStatus = _themeProvider.themeStatus;
    if(_themeStatus == ThemeStatus.dark){
      _selectColor = _colors[_colors.length-1];
    }else if(_themeStatus == ThemeStatus.first){
      _selectColor = _colors[_colors.length-2];
    }else{
       _selectColor = PreferencesUtil.getColorScheme;
    }


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        title: 'Выбери свой стиль'.tr(),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    ItemColor(
                        color: colorGrey,
                        title: 'Светлая тема'.tr(),
                        selected: _selectColor!.value == _colors[_colors.length-2].value,
                        index: 0,
                        onChange: (color) {
                          setState(()  {
                            _selectColor = _colors[_colors.length-2];
                            _themeStatus = ThemeStatus.first;
                            _isSelect = true;

                          });
                        }),
                    const Gap(20.0),
                    ItemColor(
                        color: colorBlack,
                        title: 'Темная тема'.tr(),
                        selected: _selectColor!.value == _colors[_colors.length-1].value,
                        index: 0,
                        onChange: (color) {
                            setState(()  {
                               _selectColor = _colors[_colors.length-1];
                               _isSelect = true;
                               _themeStatus = ThemeStatus.dark;
                            });
                        }),
                  ],
                ),
              ),
              const Gap(30.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text('Цветовая схема'.tr(),
                  style: TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!,
                      size: 18.0),),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.only(right: 20.0,bottom: 100.0),
                  itemCount: _colors.length - 2,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // number of items in each row
                  mainAxisSpacing: 0.0, // spacing between rows
                  crossAxisSpacing: 0.0, // spacing between columns
                ),
                    itemBuilder: (child,index){
                       return ItemColor(
                          color: _colors[index],
                          title: '',
                          selected: _selectColor!.value == _colors[index].value,
                          index: index,
                          onChange: (color) {
                               setState(() {
                                    _selectColor = color;
                                    _isSelect = true;
                                    _themeStatus = ThemeStatus.color;
                               });
                          });
                    }),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Visibility(
              visible: _isSelect,
              child: SubmitButton(
                onTap: () async {
                  await _saveTheme(status: _themeStatus,
                      selectColor: _selectColor!);
                },
                textButton: 'Применить стиль'.tr(),
              ).animate().fadeIn(),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _saveTheme({required ThemeStatus status,required Color selectColor}) async {
    await PreferencesUtil.setTheme(themeStatus: status);
    await PreferencesUtil.setColorScheme(color: selectColor);
    _themeProvider.setTheme(themeStatus: status,color: selectColor);
  }
}

 class ItemColor extends StatelessWidget{
   const ItemColor(
      {super.key,
      required this.color,
      required this.title,
      required this.selected,
      required this.index,
      required this.onChange});

  final Color color;
  final String title;
  final bool selected;
  final int index;
  final Function onChange;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        onChange.call(color);
      },
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            padding: const EdgeInsets.all(10.0),
            alignment: Alignment.center,
            width: 100.0,
            height: 100.0,
            decoration: BoxDecoration(
              color: color,
              border: Border.all(color: colorOrange,width: 1.0),
              borderRadius: BorderRadius.circular(20.0)
            ),
            child: Text(title,
                textAlign: TextAlign.center,
                style: TStyle.textStyleVelaSansBold(colorWhite,size: 14.0)),
          ),
          Visibility(
            visible: selected,
            child: Container(
              decoration: BoxDecoration(
                color: colorOrange,
                borderRadius: const BorderRadius.only(bottomRight: Radius.circular(20.0),topLeft: Radius.circular(20.0)),
              ),
              child: Icon(Icons.check_outlined,color: colorWhite),
            ),
          )
        ],
      ),
    );
  }

 }