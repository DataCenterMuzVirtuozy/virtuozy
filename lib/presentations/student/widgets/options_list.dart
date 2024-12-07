

  import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:virtuozy/domain/entities/subscription_entity.dart';

import '../../../resourses/colors.dart';
import '../../../utils/date_time_parser.dart';
import '../../../utils/text_style.dart';

class OptionsList extends StatelessWidget{
  const OptionsList({super.key, required this.subscription});

  final SubscriptionEntity subscription;

  @override
  Widget build(BuildContext context) {
   return                     Visibility(
     visible: subscription.options.isNotEmpty, //subscription.options.isNotEmpty
     child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         const Gap(10.0),
         Text('Опции:'.tr(),
             style:TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!,
                 size: 13.0)),
         ...List.generate(subscription.options.length, (index){

           return                           Row(
             children: [
               Icon(subscription.options[index].status == OptionStatus.freezing?Icons.icecream:
               Icons.free_breakfast_outlined,color: colorGreen,size: 10),
               const Gap(5),
               Text(subscription.options[index].status == OptionStatus.freezing?
               'Заморозка, активировано '.tr():
               subscription.options[index].status == OptionStatus.holiday?'Каникулы, активировано '.tr():
               subscription.options[index].status == OptionStatus.prolongation?'Продление, активировано '.tr():
               'Справка, активировано '.tr(),
                   style: TStyle.textStyleVelaSansMedium(colorGrey,
                       size: 13.0)),
               Text(DateTimeParser.getDateFromApi(date:subscription.options[index].dateEnd),
                   style: TStyle.textStyleVelaSansMedium(colorGrey,
                       size: 13.0)),
             ],
           );
         }),
         const Gap(10.0),
       ],
     ),
   );
  }


}