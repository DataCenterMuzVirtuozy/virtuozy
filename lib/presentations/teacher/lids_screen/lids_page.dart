

  import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:virtuozy/components/box_info.dart';
import 'package:virtuozy/domain/entities/lids_entity.dart';
import 'package:virtuozy/presentations/teacher/lids_screen/bloc/lids_bloc.dart';
import 'package:virtuozy/presentations/teacher/lids_screen/bloc/lids_event.dart';
import 'package:virtuozy/presentations/teacher/lids_screen/bloc/lids_state.dart';
import 'package:virtuozy/utils/auth_mixin.dart';
import 'package:virtuozy/utils/date_time_parser.dart';

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

class _LidsPageState extends State<LidsPage> with TickerProviderStateMixin,AuthMixin{

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    context.read<LidsBloc>().add(GetListEvent(idTeacher: teacher.id));

  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<LidsBloc,LidsState>(
        listener: (c,s){},
        builder: (context,state) {

          if(state.status.isError){
            return Center(
              child: BoxInfo(title: 'Ошибка загрузки данных'.tr(), iconData: Icons.error),
            );
          }

          if(state.status.isLoading){
            return Center(
              child: CircularProgressIndicator(color: colorOrange),
            );
          }
          return DefaultTabController(
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
                      ListView(
                      children: [
                      ...List.generate(state.lidsMy.length, (index) {
                        return ItemMyLids(lid: state.lidsMy[index]);
                      })
                      ],
                    ),
                    ListView(
                      children: [
                        ...List.generate(state.lidsTrial.length, (index) {
                          return ItemTrialLids(lid: state.lidsTrial[index]);
                        })
                      ],
                    ),
                    ListView(
                      children: [
                        ...List.generate(state.lids.length, (index) {
                          return ItemLids(lid: state.lids[index]);
                        })
                      ],
                    )

                        ],

                      ),
                    ),
                  ),
                ],
              )


          );
        }
      ),
    );

  }
}

class ItemMyLids extends StatelessWidget{
  const ItemMyLids({super.key, required this.lid});

  final LidsEntity lid;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:(){
        Dialoger.showToast('В карту клиента');

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
                    Text(lid.name,
                        style:TStyle.textStyleVelaSansBold(colorGrey,size: 16.0)),
                  ],
                ),
                Text(lid.nameDir,
                    style:TStyle.textStyleVelaSansExtraBolt(Theme.of(context).textTheme.displayMedium!.color!,
                        size: 14.0))
              ],
            ),
            const Gap(8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Дата создания: ',
                    style:TStyle.textStyleOpenSansRegular(colorGrey,size: 12.0)),
                Text('${DateTimeParser.getDateFromApi(date: lid.dateCreated.split('/')[0])}/${lid.dateCreated.split('/')[1]}',
                    style:TStyle.textStyleVelaSansBold(colorGrey,size: 12.0)),
              ],
            ),
            const Gap(8),
            Divider(color: colorGrey),
          ],
        ),
      ),
    );

  }

}

  class ItemTrialLids extends StatelessWidget{
    const ItemTrialLids({super.key, required this.lid});
    final LidsEntity lid;
    @override
    Widget build(BuildContext context) {
      return InkWell(
        onTap:(){

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
                      Text(lid.name,
                          style:TStyle.textStyleVelaSansBold(colorGrey,size: 16.0)),
                    ],
                  ),
                  const Gap(10),
                  Text(lid.nameDir,
                      style:TStyle.textStyleVelaSansExtraBolt(Theme.of(context).textTheme.displayMedium!.color!,
                          size: 14.0))
                ],
              ),
              const Gap(8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Дата создания: ',
                      style:TStyle.textStyleOpenSansRegular(colorGrey,size: 12.0)),
                  Text('${DateTimeParser.getDateFromApi(date: lid.dateCreated.split('/')[0])}/${lid.dateCreated.split('/')[1]}',
                      style:TStyle.textStyleVelaSansBold(colorGrey,size: 12.0)),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Дата ПУ: ',
                      style:TStyle.textStyleOpenSansRegular(colorGrey,size: 12.0)),
                  Text('${DateTimeParser.getDateFromApi(date: lid.dateTrial.split('/')[0])}/${lid.dateTrial.split('/')[1]}',
                      style:TStyle.textStyleVelaSansBold(colorGrey,size: 12.0)),
                ],
              ),
              const Gap(8),
              Divider(color: colorGrey),
            ],
          ),
        ),
      );

    }

  }

  class ItemLids extends StatelessWidget{
    const ItemLids({super.key, required this.lid});
    final LidsEntity lid;
    @override
    Widget build(BuildContext context) {
      return InkWell(
        onTap:(){

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
                      Text(lid.name,
                          style:TStyle.textStyleVelaSansBold(colorGrey,size: 16.0)),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
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
                            Text(lid.idSchool,
                                style:TStyle.textStyleVelaSansMedium(Theme.of(context).textTheme.displayMedium!.color!,
                                    size: 10.0)),
                          ],
                        ),
                      ),
                      const Gap(10),
                      Text(lid.nameDir,
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
                  Text('${DateTimeParser.getDateFromApi(date: lid.dateCreated.split('/')[0])}/${lid.dateCreated.split('/')[1]}',
                      style:TStyle.textStyleVelaSansBold(colorGrey,size: 12.0)),
                ],
              ),
              Visibility(
                visible: lid.dateTrial.isNotEmpty,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Дата ПУ: ',
                        style:TStyle.textStyleOpenSansRegular(colorGrey,size: 12.0)),
                    Text('${DateTimeParser.getDateFromApi(date: lid.dateTrial.isEmpty?'':
                    lid.dateTrial.split('/')[0])}/${lid.dateTrial.isEmpty?'':lid.dateTrial.split('/')[1]}',
                        style:TStyle.textStyleVelaSansBold(colorGrey,size: 12.0)),
                  ],
                ),
              ),
              const Gap(8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Дата последнего урока: ',
                          style:TStyle.textStyleOpenSansRegular(colorGrey,size: 12.0)),
                      Text('${DateTimeParser.getDateFromApi(date: lid.dateLastLesson.split('/')[0])}/${lid.dateLastLesson.split('/')[1]}',
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
                        StatusToColor.getNameStatus(lid.lessonLastStatus),
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
              Divider(color: colorGrey),
            ],
          ),
        ),
      );

    }

  }