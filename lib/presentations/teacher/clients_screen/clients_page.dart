



 import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:virtuozy/components/dialogs/sealeds.dart';
import 'package:virtuozy/domain/entities/lesson_entity.dart';
import 'package:virtuozy/resourses/colors.dart';

import '../../../components/dialogs/dialoger.dart';
import '../../../utils/status_to_color.dart';
import '../../../utils/text_style.dart';

class ClientsPage extends StatefulWidget{
  const ClientsPage({super.key});

  @override
  State<ClientsPage> createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> with TickerProviderStateMixin {

  late TabController _tabController;


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 5,
        child: Column(
          children: [
          TabBar(
                isScrollable: true,
                tabs: [
                  Text('Все'.tr(),style: TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!,size: 14.0)),
                  Text('Клиенты сегодня'.tr(),style: TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!,size: 14.0)),
                  Text('Активные'.tr(),style: TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!,size: 14.0)),
                  Text('Замены'.tr(),style: TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!,size: 14.0)),
                  Text('Архив'.tr(),style: TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!,size: 14.0))
                ],
              ),
          Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height-150,
                  child: TabBarView(
                    children: [
                      ...List.generate(5, (index) {
                        return ListView(
                          children: [
                            ...List.generate(4, (index) {
                             return InkWell(
                               onTap:(){
                                 Dialoger.showModalBottomMenu(title: 'Dan Balacne',
                                     blurred: true,
                                     content: DetailsClient());
                               },
                               child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Column(
                                    children: [
                                      const Gap(10),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(Icons.person,color: colorGreen,size: 18.0),
                                              const Gap(3.0),
                                              Text('Dan Balacne',
                                                  style:TStyle.textStyleVelaSansBold(colorGrey,size: 16.0)),
                                            ],
                                          ),
                                          Visibility(
                                            visible: index != 2,
                                            child: Text('3 из 4',
                                                style:TStyle.textStyleVelaSansExtraBolt(Theme.of(context).textTheme.displayMedium!.color!,
                                                    size: 12.0)),
                                          )
                                        ],
                                      ),
                                      const Gap(3),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('+3(333)63671212',
                                              style:TStyle.textStyleOpenSansRegular(Theme.of(context).textTheme.displayMedium!.color!,size: 14.0)),
                                          Text('Вокал',
                                              style:TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!,
                                                  size: 14.0))
                                        ],
                                      ),
                                      const Gap(5),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Visibility(
                                            visible: index !=2,
                                            child: Column(
                                              children: [
                                                Text('Дата ближ. урока: ',
                                                    style:TStyle.textStyleOpenSansRegular(colorGrey,size: 12.0)),
                                                Text('12.05.2024 10:00',
                                                    style:TStyle.textStyleVelaSansBold(colorGrey,size: 12.0))
                                              ],
                                            ),
                                          ),
                                          const Gap(20),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 2),
                                            decoration:  BoxDecoration(
                                                color:  index!=2?StatusToColor.getColor(
                                                    lessonStatus: LessonStatus.singly):colorRed,
                                                borderRadius: BorderRadius.circular(5)
                                            ),
                                            child: Text(
                                                index!=2?StatusToColor.getNameStatus(LessonStatus.singly):
                                                'неактивный'.tr(),
                                                textAlign: TextAlign.center,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TStyle.textStyleVelaSansBold(Theme.of(context)
                                                    .textTheme
                                                    .displayMedium!
                                                    .color!,
                                                    size: 10.0)),
                                          )
                                        ],
                                      ),
                                      const Gap(10),
                                      Divider(color: colorGrey),
                                    ],
                                  ),
                                ),
                             );
                            })
                          ],
                        );
                      })

                    ],

                  ),
                ),
              ),
          ],
        )


      ),
    );
  }
}