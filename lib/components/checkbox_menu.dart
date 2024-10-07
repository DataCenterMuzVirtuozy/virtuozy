


import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:virtuozy/resourses/colors.dart';
import 'package:virtuozy/resourses/strings.dart';
import 'package:virtuozy/utils/preferences_util.dart';

import '../utils/text_style.dart';

class MyCheckboxMenu extends StatefulWidget {
  const MyCheckboxMenu({super.key, required this.message});

  final String message;

  @override
  State<MyCheckboxMenu> createState() => _MyCheckboxMenuState();
}

class _MyCheckboxMenuState extends State<MyCheckboxMenu> {
  final FocusNode _buttonFocusNode = FocusNode(debugLabel: 'Menu Button');
  static const SingleActivator _showShortcut =
  SingleActivator(LogicalKeyboardKey.keyS, control: true);
  bool _msk  = false;
  bool _nsk = false;

  @override
  void dispose() {
    _buttonFocusNode.dispose();
    super.dispose();
  }


  @override
  void initState() {
    super.initState();
  final urlSchool = PreferencesUtil.urlSchool;
    if(urlSchool == mskUrl){
      _msk = true;
    }else{
      _nsk = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: <ShortcutActivator, VoidCallback>{
        _showShortcut: () {

        },
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          MenuAnchor(
            alignmentOffset: const Offset(-100.0, 0.0),
            childFocusNode: _buttonFocusNode,
            menuChildren: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Row(
                  children: [
                    Checkbox(
                        side: BorderSide(color: Theme.of(context).textTheme.displayMedium!.color!),
                        checkColor: colorWhite,
                        value: _msk,
                        onChanged: (v) async {
                          setState(() {
                            _msk = v!;
                            if(_msk){
                              _nsk = false;
                            }
                          });
                          await PreferencesUtil.setUrlSchool(mskUrl);
                        }),
                    Text('Москва'.tr(),style: TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!,
                        size: 12.0))

                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Row(
                  children: [
                    Checkbox(
                        side: BorderSide(color: Theme.of(context).textTheme.displayMedium!.color!),
                        checkColor: colorWhite,
                        value: _nsk,
                        onChanged: (v) async {
                          setState(() {
                            _nsk = v!;
                            if(_nsk){
                              _msk = false;
                            }
                          });
                          await PreferencesUtil.setUrlSchool(nskUrl);
                        }),
                    Text('Новосибирск'.tr(),style: TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!,
                        size: 12.0))

                  ],
                ),
              )

            ],
            builder: (BuildContext context, MenuController controller,
                Widget? child) {
              return TextButton(
                focusNode: _buttonFocusNode,
                onPressed: () {
                  if (controller.isOpen) {
                    controller.close();
                  } else {
                    controller.open();
                  }
                },
                child: Icon(Icons.location_on_outlined,color: Theme.of(context).textTheme.displayMedium!.color!,),
              );
            },
          ),
        ],
      ),
    );
  }
}