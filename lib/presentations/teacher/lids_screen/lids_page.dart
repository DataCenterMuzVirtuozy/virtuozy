

  import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';

import '../../../components/dialogs/dialoger.dart';
import '../../../domain/entities/lesson_entity.dart';
import '../../../resourses/colors.dart';
import '../../../utils/status_to_color.dart';
import '../../../utils/text_style.dart';

class LidsPage extends StatefulWidget{
  const LidsPage({super.key});

  @override
  State<LidsPage> createState() => _LidsPageState();
}

class _LidsPageState extends State<LidsPage> with TickerProviderStateMixin{

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
          length: 3,
          child: Column(
            children: [
              TabBar(
                isScrollable: true,
                tabs: [
                  Text('Мои Лиды'.tr(),style: TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!,size: 14.0)),
                  Text('ПУ - Назначен'.tr(),style: TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!,size: 14.0)),
                  Text('Все'.tr(),style: TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!,size: 14.0)),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height-150,
                  child: TabBarView(
                    children: [
                      ...List.generate(3, (i) {
                        return ListView(
                          children: [
                            ...List.generate(4, (index) {
                              return InkWell(
                                onTap:(){
                                  if(i==0){
                                    Dialoger.showToast('В карту клиента');
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Column(
                                    children: [
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
                                          Row(
                                            children: [
                                              Visibility(
                                                visible: i == 2,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(5),
                                                    color: colorGreyLight
                                                  ),
                                                  padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 3),
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.location_on_outlined,size: 10,color:
                                                      Theme.of(context).textTheme.displayMedium!.color!),
                                                      const Gap(2),
                                                      Text('мш1',
                                                          style:TStyle.textStyleVelaSansMedium(Theme.of(context).textTheme.displayMedium!.color!,
                                                              size: 10.0)),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const Gap(10),
                                              Text('Вокал',
                                                  style:TStyle.textStyleVelaSansExtraBolt(Theme.of(context).textTheme.displayMedium!.color!,
                                                      size: 14.0)),
                                            ],
                                          )
                                        ],
                                      ),
                                      const Gap(8),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Дата создания: ',
                                              style:TStyle.textStyleOpenSansRegular(colorGrey,size: 12.0)),
                                          Text('12.05.2024 10:00',
                                              style:TStyle.textStyleVelaSansBold(colorGrey,size: 12.0)),
                                        ],
                                      ),
                                      Visibility(
                                        visible: i>0,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Дата ПУ: ',
                                                style:TStyle.textStyleOpenSansRegular(colorGrey,size: 12.0)),
                                            Text('12.05.2024 10:00',
                                                style:TStyle.textStyleVelaSansBold(colorGrey,size: 12.0)),
                                          ],
                                        ),
                                      ),
                                      const Gap(8),
                                      Visibility(
                                        visible: i>1,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text('Дата последнего урока: ',
                                                    style:TStyle.textStyleOpenSansRegular(colorGrey,size: 12.0)),
                                                Text('12.05.2024 10:00',
                                                    style:TStyle.textStyleVelaSansBold(textColorBlack(context),size: 12.0)),
                                              ],
                                            ),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 2),
                                              decoration:  BoxDecoration(
                                                  color:  StatusToColor.getColor(
                                                      lessonStatus: LessonStatus.cancel),
                                                  borderRadius: BorderRadius.circular(5)
                                              ),
                                              child: Text(
                                                 StatusToColor.getNameStatus(LessonStatus.cancel),
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
                                      ),
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