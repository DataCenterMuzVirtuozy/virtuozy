



import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:virtuozy/components/app_bar.dart';
import 'package:virtuozy/utils/date_time_parser.dart';

import '../../../components/box_info.dart';
import '../../../domain/entities/subscription_entity.dart';
import '../../../resourses/colors.dart';
import '../../../utils/text_style.dart';


class ListSubscriptionHistory extends StatefulWidget{
  const ListSubscriptionHistory({super.key, required this.listExpiredSubscriptions});

  final List<SubscriptionEntity> listExpiredSubscriptions;

  @override
  State<ListSubscriptionHistory> createState() => _ListSubscriptionHistoryState();
}

class _ListSubscriptionHistoryState extends State<ListSubscriptionHistory> {






  @override
  void didChangeDependencies() {
   super.didChangeDependencies();

  }


  @override
  void initState() {
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(title: 'История абонементов'.tr()),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if(widget.listExpiredSubscriptions.isEmpty)...{
            BoxInfo(title: 'Список пуст'.tr(),
    iconData: Icons.list_alt_sharp)

          }else...{
            Expanded(
              child:  ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  itemCount: widget.listExpiredSubscriptions.length,
                  itemBuilder: (c,i){
                    return ItemSubHistory(
                       subscriptionEntity: widget.listExpiredSubscriptions[i]);
                  }),
            )

          }

        ],
      ),
    );
  }


}

class ItemSubHistory extends StatelessWidget{
  const ItemSubHistory({super.key,
    required this.subscriptionEntity
  });


  final SubscriptionEntity subscriptionEntity;

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
              child: Text(subscriptionEntity.nameDir,
                  style: TStyle.textStyleVelaSansExtraBolt(Theme.of(context).textTheme.displayMedium!.color!,size: 18.0)),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                  Text(subscriptionEntity.name,
                      style: TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!,size: 14.0)),
                  const Gap(5.0),
                  Row(
                    children: [
                      Icon(Icons.timelapse_rounded,color: colorBeruza,size: 10.0),
                      const Gap(3.0),
                      Row(
                        children: [
                          Text('Дата покупки'.tr(),style: TStyle.textStyleVelaSansRegular(colorBeruza,size: 10.0)),
                          Text(' ${DateTimeParser.getDateFromApi(date: subscriptionEntity.dateBay)}',style: TStyle.textStyleVelaSansBold(colorBeruza,size: 10.0))
                        ],
                      ),
                    ],

                  ),
                  Visibility(
                    visible: subscriptionEntity.status != StatusSub.planned,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Row(
                        children: [
                          Icon(Icons.timelapse_rounded,color: colorBeruza,size: 10.0),
                          const Gap(3.0),
                          Row(
                            children: [
                              Text('Дата начала'.tr(),style: TStyle.textStyleVelaSansRegular(colorBeruza,size: 10.0)),
                              Text(' ${DateTimeParser.getDateFromApi(date: subscriptionEntity.dateStart)}',style: TStyle.textStyleVelaSansBold(colorBeruza,size: 10.0))
                            ],
                          ),
                        ],

                      ),
                    ),
                  ),
                  Visibility(
                    visible: subscriptionEntity.status != StatusSub.planned,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Row(
                        children: [
                          Icon(Icons.timelapse_rounded,color: colorBeruza,size: 10.0),
                          const Gap(3.0),
                          Row(
                            children: [
                              Text('Дата окончания'.tr(),style: TStyle.textStyleVelaSansRegular(colorBeruza,size: 10.0)),
                              Text(' ${DateTimeParser.getDateFromApi(date: subscriptionEntity.dateEnd)}',style: TStyle.textStyleVelaSansBold(colorBeruza,size: 10.0))
                            ],
                          ),
                        ],


                      ),
                    ),
                  ),
                  Container(
                    width: 100.0,
                    margin: const EdgeInsets.only(top: 10.0),
                    padding: const EdgeInsets.only(right: 8.0,left:8.0,bottom: 2.0),
                    decoration: BoxDecoration(
                        color: subscriptionEntity.status == StatusSub.inactive||
                            subscriptionEntity.status == StatusSub.planned?colorRed:
                        colorGreen,
                        borderRadius: BorderRadius.circular(10.0)),
                    alignment: Alignment.center,
                    child: Text(subscriptionEntity.status == StatusSub.inactive?'неактивный'.tr():
                    subscriptionEntity.status == StatusSub.planned?'запланирован'.tr():'активный'.tr(),
                        style: TStyle.textStyleVelaSansBold(colorWhite,
                            size: 10.0)),
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
                  Text(subscriptionEntity.price.toString(),
                      style: TStyle.textStyleVelaSansExtraBolt(Theme.of(context).textTheme.displayMedium!.color!,size: 14.0)),
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