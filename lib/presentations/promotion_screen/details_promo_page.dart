

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:virtuozy/components/app_bar.dart';
import 'package:virtuozy/components/buttons.dart';
import 'package:virtuozy/resourses/colors.dart';

import '../../utils/text_style.dart';

class DetailsPromoPage extends StatelessWidget{
  const DetailsPromoPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBarCustom(title: title),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Самоучитель игры на гитаре - это теоритеческая база о том как играть на гитаре самостоятельно. Этими знаниями имеет смысл пользоваться, если Вы что-то подзабыли или Вам нужно уточнить на верном ли Вы пути, но не для того, чтобы научиться играть на гитаре самостоятельно с нуля!',
                style: TStyle.textStyleVelaSansRegular(colorBlack,size: 18.0)),
            // const Gap(20.0),
            // SubmitButton(
            //   //todo local
            //   textButton: 'Получить предложения',
            // )
          ],
        ),
      ),
    );
  }

}