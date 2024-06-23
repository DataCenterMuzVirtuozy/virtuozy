

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:virtuozy/components/dialogs/sealeds.dart';
import 'package:virtuozy/domain/entities/client_entity.dart';
import 'package:virtuozy/domain/entities/lesson_entity.dart';
import 'package:virtuozy/presentations/teacher/clients_screen/bloc/clients_event.dart';
import 'package:virtuozy/resourses/colors.dart';
import 'package:virtuozy/utils/date_time_parser.dart';

import '../../../components/box_info.dart';
import '../../../components/dialogs/dialoger.dart';
import '../../../utils/status_to_color.dart';
import '../../../utils/text_style.dart';
import 'bloc/clients_bloc.dart';
import 'bloc/clients_state.dart';

class ClientsPage extends StatefulWidget {
  const ClientsPage({super.key});

  @override
  State<ClientsPage> createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    context.read<ClientsBloc>().add(GetClientsEvent());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ClientsBloc, ClientsState>(
          listener: (c, s) {},
          builder: (context, state) {
            if (state.status.isError) {
              return Center(
                child: BoxInfo(
                    title: 'Ошибка загрузки данных'.tr(),
                    iconData: Icons.error),
              );
            }

            if (state.status.isLoading) {
              return Center(
                child: CircularProgressIndicator(color: colorOrange),
              );
            }

            return DefaultTabController(
                length: 5,
                child: Column(
                  children: [
                    TabBar(
                      isScrollable: true,
                      tabs: [
                        Text('Все'.tr(),
                            style: TStyle.textStyleVelaSansBold(
                                Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .color!,
                                size: 14.0)),
                        Text('Клиенты сегодня'.tr(),
                            style: TStyle.textStyleVelaSansBold(
                                Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .color!,
                                size: 14.0)),
                        Text('Активные'.tr(),
                            style: TStyle.textStyleVelaSansBold(
                                Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .color!,
                                size: 14.0)),
                        Text('Замены'.tr(),
                            style: TStyle.textStyleVelaSansBold(
                                Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .color!,
                                size: 14.0)),
                        Text('Архив'.tr(),
                            style: TStyle.textStyleVelaSansBold(
                                Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .color!,
                                size: 14.0))
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height - 150,
                        child: TabBarView(
                          children: [
                            ListView(
                              children: [
                                if (state.all.isEmpty) ...{
                                  Padding(
                                    padding:  EdgeInsets.only(top:
                                    MediaQuery.of(context).size.height/2.8),
                                    child:                                   BoxInfo(
                                        title: 'Список клиентов пуст'.tr(),
                                        iconData: Icons.list_rounded)
                                    ,
                                  )
                                } else ...{
                                  ...List.generate(state.all.length, (index) {
                                    return ItemAll(
                                      client: state.all[index],
                                    );
                                  }),
                                },
                              ],
                            ),
                            ListView(
                              children: [
                                if (state.today.isEmpty) ...{
                                  Padding(
                                    padding:  EdgeInsets.only(top:
                                    MediaQuery.of(context).size.height/2.8),
                                    child:                                   BoxInfo(
                                        title: 'Список клиентов пуст'.tr(),
                                        iconData: Icons.list_rounded)
                                    ,
                                  )
                                } else ...{
                                  ...List.generate(state.today.length, (index) {
                                    return ItemToday(
                                      client: state.today[index],
                                    );
                                  }),
                                }
                              ],
                            ),
                            ListView(
                              children: [
                                if(state.action.isEmpty)...{
                                  Padding(
                                    padding:  EdgeInsets.only(top:
                                    MediaQuery.of(context).size.height/2.8),
                                    child:                                   BoxInfo(
                                        title: 'Список клиентов пуст'.tr(),
                                        iconData: Icons.list_rounded)
                                    ,
                                  )
                                }else...{
                                  ...List.generate(state.action.length, (index) {
                                    return ItemAction(
                                      client: state.action[index],
                                    );
                                  }),
                                }
                              ],
                            ),
                            ListView(
                              children: [
                                if(state.replacement.isEmpty)...{
                                  Padding(
                                    padding:  EdgeInsets.only(top:
                                    MediaQuery.of(context).size.height/2.8),
                                    child:                                   BoxInfo(
                                        title: 'Список клиентов пуст'.tr(),
                                        iconData: Icons.list_rounded)
                                    ,
                                  )
                                }else...{
                                  ...List.generate(state.replacement.length,
                                          (index) {
                                        return ItemReplacemant(
                                          client: state.replacement[index],
                                        );
                                      }),
                                }

                              ],
                            ),
                            ListView(
                              children: [
                                if(state.archive.isEmpty)...{
                                  Padding(
                                    padding:  EdgeInsets.only(top:
                                    MediaQuery.of(context).size.height/2.8),
                                    child:                                   BoxInfo(
                                        title: 'Список клиентов пуст'.tr(),
                                        iconData: Icons.list_rounded)
                                    ,
                                  )
                                }else...{
                                  ...List.generate(state.archive.length, (index) {
                                    return ItemArchive(
                                      client: state.archive[index],
                                    );
                                  }),
                                }

                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ));
          }),
    );
  }
}

class ItemAll extends StatelessWidget {
  const ItemAll({super.key, required this.client});

  final ClientEntity client;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          Dialoger.showModalBottomMenu(
              title: client.name,
              args: client,
              blurred: true,
              content: DetailsClient());
        },
        child: Column(
          children: [
            const Gap(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.person, color: colorGreen, size: 18.0),
                    const Gap(3.0),
                    Text(client.name,
                        style: TStyle.textStyleVelaSansBold(colorGrey,
                            size: 16.0)),
                  ],
                ),
                Text('${client.countBalanceLesson} из ${client.countAllLesson}',
                    style: TStyle.textStyleVelaSansExtraBolt(
                        Theme.of(context).textTheme.displayMedium!.color!,
                        size: 12.0))
              ],
            ),
            const Gap(3),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(client.phoneNum,
                    style: TStyle.textStyleOpenSansRegular(
                        Theme.of(context).textTheme.displayMedium!.color!,
                        size: 14.0)),
                Text(client.nameDir,
                    style: TStyle.textStyleVelaSansBold(
                        Theme.of(context).textTheme.displayMedium!.color!,
                        size: 14.0))
              ],
            ),
            const Gap(5),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text('Дата ближ. урока: ',
                        style: TStyle.textStyleOpenSansRegular(colorGrey,
                            size: 12.0)),
                    Text('${DateTimeParser.getDateFromApi(date: client.dateNearLesson)} ${client.timeNearLesson}',
                        style:
                            TStyle.textStyleVelaSansBold(colorGrey, size: 12.0))
                  ],
                ),
                const Gap(20),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                      color: StatusToColor.getColor(
                          lessonStatus: client.statusNearLesson),
                      border: Border.all(
                          color: client.statusNearLesson.isComplete||client.statusNearLesson.isPlanned
                              ? textColorBlack(context)
                              : Colors.transparent),
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(
                      StatusToColor.getNameStatus(client.statusNearLesson),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TStyle.textStyleVelaSansBold(
                          Theme.of(context).textTheme.displayMedium!.color!,
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
  }
}

class ItemAction extends StatelessWidget {
  const ItemAction({super.key, required this.client});

  final ClientEntity client;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          Dialoger.showModalBottomMenu(
              args: client,
              title: client.name, blurred: true, content: DetailsClient());
        },
        child: Column(
          children: [
            const Gap(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.person, color: colorGreen, size: 18.0),
                    const Gap(3.0),
                    Text(client.name,
                        style: TStyle.textStyleVelaSansBold(colorGrey,
                            size: 16.0)),
                  ],
                ),
                Text('${client.countBalanceLesson} из ${client.countAllLesson}',
                    style: TStyle.textStyleVelaSansExtraBolt(
                        Theme.of(context).textTheme.displayMedium!.color!,
                        size: 12.0))
              ],
            ),
            const Gap(3),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(client.phoneNum,
                    style: TStyle.textStyleOpenSansRegular(
                        Theme.of(context).textTheme.displayMedium!.color!,
                        size: 14.0)),
                Text(client.nameDir,
                    style: TStyle.textStyleVelaSansBold(
                        Theme.of(context).textTheme.displayMedium!.color!,
                        size: 14.0))
              ],
            ),
            const Gap(5),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text('Дата ближ. урока: ',
                        style: TStyle.textStyleOpenSansRegular(colorGrey,
                            size: 12.0)),
                    Text('${DateTimeParser.getDateFromApi(date: client.dateNearLesson)} ${client.timeNearLesson}',
                        style:
                            TStyle.textStyleVelaSansBold(colorGrey, size: 12.0))
                  ],
                ),
                const Gap(20),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                      color: StatusToColor.getColor(
                          lessonStatus: client.statusNearLesson),
                      border: Border.all(
                          color: client.statusNearLesson.isComplete||client.statusNearLesson.isPlanned
                              ? textColorBlack(context)
                              : Colors.transparent),
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(
                      StatusToColor.getNameStatus(client.statusNearLesson),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TStyle.textStyleVelaSansBold(
                          Theme.of(context).textTheme.displayMedium!.color!,
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
  }
}

class ItemArchive extends StatelessWidget {
  const ItemArchive({super.key, required this.client});

  final ClientEntity client;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          Dialoger.showModalBottomMenu(
              args: client,
              title: client.name, blurred: true, content: DetailsClient());
        },
        child: Column(
          children: [
            const Gap(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Icon(Icons.person, color: colorGreen, size: 18.0),
                    ),
                    const Gap(5.0),
                    SizedBox(
                      width: MediaQuery.of(context).size.width-150,
                      child: Text(client.name,
                          style: TStyle.textStyleVelaSansBold(colorGrey,
                              size: 16.0)),
                    ),
                  ],
                ),
                const Gap(20),
                Text(client.nameDir,
                    style: TStyle.textStyleVelaSansBold(
                        Theme.of(context).textTheme.displayMedium!.color!,
                        size: 14.0))

                // Text('${client.countBalanceLesson} из ${client.countAllLesson}',
                //     style: TStyle.textStyleVelaSansExtraBolt(
                //         Theme.of(context).textTheme.displayMedium!.color!,
                //         size: 12.0))
              ],
            ),
            const Gap(3),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(client.phoneNum,
                    style: TStyle.textStyleOpenSansRegular(
                        Theme.of(context).textTheme.displayMedium!.color!,
                        size: 14.0)),
              ],
            ),
            const Gap(5),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text('Дата посл. урока: '.tr(),
                        style: TStyle.textStyleOpenSansRegular(colorGrey,
                            size: 12.0)),
                    Text('${DateTimeParser.getDateFromApi(date: client.dateLestLesson)} ${client.timeNearLesson}', //todo time lastLesson
                        style:
                            TStyle.textStyleVelaSansBold(colorGrey, size: 12.0))
                  ],
                ),
                const Gap(20),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                      color: StatusToColor.getColor(
                          lessonStatus: client.statusLastLesson),
                      border: Border.all(
                          color: client.statusLastLesson.isComplete||client.statusLastLesson.isPlanned
                              ? textColorBlack(context)
                              : Colors.transparent),
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(
                      StatusToColor.getNameStatus(client.statusLastLesson),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TStyle.textStyleVelaSansBold(
                          Theme.of(context).textTheme.displayMedium!.color!,
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
  }
}

class ItemToday extends StatelessWidget {
  const ItemToday({super.key, required this.client});

  final ClientEntity client;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          Dialoger.showModalBottomMenu(
              args: client,
              title: client.name, blurred: true, content: DetailsClient());
        },
        child: Column(
          children: [
            const Gap(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.person, color: colorGreen, size: 18.0),
                    const Gap(3.0),
                    Text(client.name,
                        style: TStyle.textStyleVelaSansBold(colorGrey,
                            size: 16.0)),
                  ],
                ),
                Text('${client.countBalanceLesson} из ${client.countAllLesson}',
                    style: TStyle.textStyleVelaSansExtraBolt(
                        Theme.of(context).textTheme.displayMedium!.color!,
                        size: 12.0))
              ],
            ),
            const Gap(3),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(client.phoneNum,
                    style: TStyle.textStyleOpenSansRegular(
                        Theme.of(context).textTheme.displayMedium!.color!,
                        size: 14.0)),
                Text('Вокал',
                    style: TStyle.textStyleVelaSansBold(
                        Theme.of(context).textTheme.displayMedium!.color!,
                        size: 14.0))
              ],
            ),
            const Gap(5),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text('Дата ближ. урока: ',
                        style: TStyle.textStyleOpenSansRegular(colorGrey,
                            size: 12.0)),
                    Text('${DateTimeParser.getDateFromApi(date: client.dateNearLesson)} ${client.timeNearLesson}',
                        style:
                            TStyle.textStyleVelaSansBold(colorGrey, size: 12.0))
                  ],
                ),
                const Gap(20),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                      color: StatusToColor.getColor(
                          lessonStatus: client.statusNearLesson),
                      border: Border.all(
                          color: client.statusNearLesson.isComplete||client.statusNearLesson.isPlanned
                              ? textColorBlack(context)
                              : Colors.transparent),
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(
                      StatusToColor.getNameStatus(client.statusNearLesson),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TStyle.textStyleVelaSansBold(
                          Theme.of(context).textTheme.displayMedium!.color!,
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
  }
}

class ItemReplacemant extends StatelessWidget {
  const ItemReplacemant({super.key, required this.client});

  final ClientEntity client;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          Dialoger.showModalBottomMenu(
              args: client,
              title: client.name,
              blurred: true,
              content: DetailsClient());
        },
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.person, color: colorGreen, size: 18.0),
                    const Gap(3.0),
                    Text(client.name,
                        style: TStyle.textStyleVelaSansBold(colorGrey,
                            size: 16.0)),
                  ],
                ),
                Text('${client.countBalanceLesson} из ${client.countAllLesson}',
                    style: TStyle.textStyleVelaSansExtraBolt(
                        Theme.of(context).textTheme.displayMedium!.color!,
                        size: 12.0))
              ],
            ),
            const Gap(3),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(client.phoneNum,
                    style: TStyle.textStyleOpenSansRegular(
                        Theme.of(context).textTheme.displayMedium!.color!,
                        size: 14.0)),
                Text('Вокал',
                    style: TStyle.textStyleVelaSansBold(
                        Theme.of(context).textTheme.displayMedium!.color!,
                        size: 14.0))
              ],
            ),
            const Gap(5),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text('Дата ближ. урока: ',
                        style: TStyle.textStyleOpenSansRegular(colorGrey,
                            size: 12.0)),
                    Text('${DateTimeParser.getDateFromApi(date: client.dateNearLesson)} ${client.timeNearLesson}',
                        style:
                            TStyle.textStyleVelaSansBold(colorGrey, size: 12.0))
                  ],
                ),
                const Gap(20),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                      color: StatusToColor.getColor(
                          lessonStatus: client.statusNearLesson),
                      border: Border.all(
                          color: client.statusNearLesson.isComplete||client.statusNearLesson.isPlanned
                              ? textColorBlack(context)
                              : Colors.transparent),
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(
                      StatusToColor.getNameStatus(client.statusNearLesson),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TStyle.textStyleVelaSansBold(
                          Theme.of(context).textTheme.displayMedium!.color!,
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
  }
}
