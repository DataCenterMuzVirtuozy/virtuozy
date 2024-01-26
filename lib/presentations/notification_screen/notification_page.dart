



 import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:virtuozy/components/app_bar.dart';
import 'package:virtuozy/components/box_info.dart';
import 'package:virtuozy/resourses/colors.dart';
import 'package:virtuozy/utils/text_style.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final List<Map<String,String>> testNotifi = [
    {'body':'Подтвердите прохождение урока, состоявшегося 10.10.23','time':'10.10.2023/12:45'},
    {'body':'На вашем балансе осталось 544 рубля. Не забудьте купить новый абонемент.3','time':'10.10.2023/12:45'},
    {'body':'Счет пополнен на 8999 рублей. Куплен абонемент на 4 занятия.','time':'10.10.2023/12:45'},
    {'body':'Урок, назначенный на 01.09.23 перенесен на 03.10.23, 14:00.','time':'10.10.2023/12:45'}
  ];

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBarCustom(title: 'Уведомления'.tr()),
     body: testNotifi.isNotEmpty?ListView.builder(
       itemCount: testNotifi.length,
         itemBuilder: (context,index){
         return  ItemNotification(
           body: testNotifi[index]['body']!,
           time: testNotifi[index]['time']!,
         );
     }):BoxInfo(title: 'У вас нет уведомлений'.tr(), iconData: CupertinoIcons.music_note_list),
   );
  }
}

 class ItemNotification extends StatelessWidget{
  const ItemNotification({super.key, required this.body, required this.time});

  final String body;
  final String time;

  @override
  Widget build(BuildContext context) {
       return Container(
     margin: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 5.0),
     padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 15.0),
     decoration: BoxDecoration(
         borderRadius: BorderRadius.circular(15.0),
         color: colorBeruzaLight
     ),
     child: Column(
       children: [
         Row(
           children: [
             Container(
               padding: const EdgeInsets.all(5.0),
               decoration: BoxDecoration(
                   color: colorOrange.withOpacity(0.2),
                   shape: BoxShape.circle
               ),
               child: Icon(Icons.notifications_none_rounded,color: colorOrange),
             ),
             const Gap(15.0),
             Expanded(child: Text(body,style: TStyle.textStyleVelaSansBold(colorBlack,size: 14.0))),
           ],
         ),
         const Gap(10.0),
         Align(
             alignment: Alignment.centerRight,
             child: Row(
               crossAxisAlignment: CrossAxisAlignment.center,
               mainAxisAlignment: MainAxisAlignment.end,
               children: [
                 Icon(Icons.timelapse_rounded,color: colorBeruza,size: 12.0),
                 const Gap(3.0),
                 Text(time,style: TStyle.textStyleVelaSansRegular(colorBeruza,size: 12.0)),
               ],
             ))
       ],
     ),
   );

  }

 }