

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:virtuozy/components/dialogs/sealeds.dart';

import '../utils/text_style.dart';
import 'dialogs/dialoger.dart';

class PhoneNum extends StatelessWidget{
  const PhoneNum({super.key, required this.phone});

  final String phone;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Dialoger.showModalBottomMenu(
            title: phone,
            args: phone,
            content: PhoneCaller());
      },
      child: Text(phone,
          style: TStyle.textStyleOpenSansRegular(
              Theme.of(context).textTheme.displayMedium!.color!,
              size: 14.0)),
    );
  }

}