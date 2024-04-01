


  import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:virtuozy/components/app_bar.dart';
import 'package:virtuozy/components/buttons.dart';

import '../../../components/box_info.dart';
import '../../../components/dialogs/dialoger.dart';
import '../../../resourses/colors.dart';
import '../../../utils/text_style.dart';

class ListBonusLessons extends StatelessWidget{
  const ListBonusLessons({super.key});

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      appBar:  AppBarCustom(title: 'Бонусные уроки'.tr(),),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            ...List.generate(1, (index) {
              return const ItemBonusLesson();
            })
          ],
        ),
      )




      // BoxInfo(title: 'У вас нет бонусных уроков'.tr(),
      //     iconData: Icons.list_alt_sharp),
    );
  }

}


class ItemBonusLesson extends StatelessWidget{
  const ItemBonusLesson({super.key});



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){

      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 5.0),
        padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 15.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: Theme.of(context).colorScheme.surfaceVariant
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 47.0),
              child: Text('Бонусный урок',style: TStyle.textStyleVelaSansExtraBolt(Theme.of(context).textTheme.displayMedium!.color!,size: 18.0)),
            ),
            const Gap(5.0),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                      color: colorOrange.withOpacity(0.2),
                      shape: BoxShape.circle
                  ),
                  child: Icon(Icons.electric_bolt,color: colorOrange),
                ),
                const Gap(15.0),
                Expanded(child: Text('Вам доступен бонусный урок в направлении Вокал',style: TStyle.textStyleVelaSansRegular(colorGrey,size: 14.0))),
              ],
            ),
            const Gap(10.0),
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                height: 30,
                width: 170,
                child: SubmitButton(
                  onTap: (){
                    Dialoger.showMessage('Данный функционал находиться в разработке');
                  },
                  borderRadius: 5,
                  textButton: 'Активировать',
                ),
              ),
            )
          ],
        ),
      ),
    );

  }

}