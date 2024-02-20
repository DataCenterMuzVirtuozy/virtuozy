



import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:virtuozy/components/app_bar.dart';

import '../../resourses/colors.dart';
import '../../utils/text_style.dart';

class ListSubscriptionHistory extends StatelessWidget{
  const ListSubscriptionHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(title: 'История абонементов'.tr()),
      body: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          itemCount: 10,
          itemBuilder: (c,i){
            return ItemSubHistory(
              title:'Вокал',
                body: 'Абонемент утренний',
                time: '22.04.2022',
                quantity: '40000');
          }),
    );
  }


}

class ItemSubHistory extends StatelessWidget{
  const ItemSubHistory({super.key,
    required this.body,
    required this.time,
    required this.quantity,
    required this.title
  });

  final String body;
  final String title;
  final String time;
  final String quantity;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 5.0),
      padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 15.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Theme.of(context).colorScheme.surfaceVariant
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 50.0),
              child: Text(title,style: TStyle.textStyleVelaSansExtraBolt(Theme.of(context).textTheme.displayMedium!.color!,size: 18.0)),
            ),
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                    color: colorOrange.withOpacity(0.2),
                    shape: BoxShape.circle
                ),
                child: Icon(Icons.music_note_rounded,color: colorOrange),
              ),
              const Gap(15.0),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(body,style: TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!,size: 14.0)),
                  Row(
                    children: [
                      Icon(Icons.timelapse_rounded,color: colorBeruza,size: 10.0),
                      const Gap(3.0),
                      Row(
                        children: [
                          Text('Дата окончания'.tr(),style: TStyle.textStyleVelaSansRegular(colorBeruza,size: 10.0)),
                          Text(' $time',style: TStyle.textStyleVelaSansRegular(colorBeruza,size: 10.0))
                        ],
                      ),
                    ],
                  ),
                ],
              )),
            ],
          ),
          const Gap(10.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  Text(quantity,style: TStyle.textStyleVelaSansExtraBolt(Theme.of(context).textTheme.displayMedium!.color!,size: 14.0)),
                  Icon(CupertinoIcons.money_rubl,color: Theme.of(context).textTheme.displayMedium!.color!,size: 16.0)
                ],
              ),
            ],
          )
        ],
      ),
    );

  }

}