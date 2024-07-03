import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:virtuozy/components/dialogs/sealeds.dart';
import 'package:virtuozy/components/phone_number.dart';
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

class _ClientsPageState extends State<ClientsPage> with TickerProviderStateMixin{
  List<ClientEntity> _allCl = [];
  List<ClientEntity> _todayCl = [];
  List<ClientEntity> _activeCl = [];
  List<ClientEntity> _replacementCl = [];
  List<ClientEntity> _archiveCl = [];
  List<ClientEntity> _allClResult = [];
  List<ClientEntity> _todayClResult = [];
  List<ClientEntity> _activeClResult = [];
  List<ClientEntity> _replacementClResult = [];
  List<ClientEntity> _archiveClResult = [];
  late ScrollController _controller;
  late Animation<double> _animation;
  late AnimationController _controllerAnim;

  @override
  void initState() {
    _controllerAnim = AnimationController(
      duration: const Duration(milliseconds:300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 60, end: 0).animate(_controllerAnim);
    super.initState();
    _controller = ScrollController();
    _controller.addListener(() {
      if (_controller.position.userScrollDirection == ScrollDirection.forward) {
        _controllerAnim.reverse();
      } else if (_controller.position.userScrollDirection ==
          ScrollDirection.reverse) {
        _controllerAnim.forward();
      }
    });

    context.read<ClientsBloc>().add(GetClientsEvent());
  }

  @override
  void dispose() {
    _controller.dispose();
    _controllerAnim.dispose();
    super.dispose();
  }

  void _handleSearchMyLids(String input) {
    _allClResult.clear();
    _todayClResult.clear();
    _activeClResult.clear();
    _replacementClResult.clear();
    _archiveClResult.clear();

    for (var str in _allCl) {
      if (str.name.toLowerCase().contains(input.toLowerCase())) {
        _allClResult.add(str);
      }
    }
    for (var str in _todayCl) {
      if (str.name.toLowerCase().contains(input.toLowerCase())) {
        _todayClResult.add(str);
      }
    }
    for (var str in _archiveCl) {
      if (str.name.toLowerCase().contains(input.toLowerCase())) {
        _archiveClResult.add(str);
      }
    }

    for (var str in _replacementCl) {
      if (str.name.toLowerCase().contains(input.toLowerCase())) {
        _replacementClResult.add(str);
      }
    }

    for (var str in _activeCl) {
      if (str.name.toLowerCase().contains(input.toLowerCase())) {
        _activeClResult.add(str);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ClientsBloc, ClientsState>(listener: (c, s) {
        _allCl = s.all;
        _todayCl = s.today;
        _activeCl = s.action;
        _replacementCl = s.replacement;
        _archiveCl = s.archive;

        if (_allClResult.isEmpty) {
          _allClResult = _allCl;
        }
        if (_todayClResult.isEmpty) {
          _todayClResult = _todayCl;
        }
        if (_activeClResult.isEmpty) {
          _activeClResult = _activeCl;
        }
        if (_archiveClResult.isEmpty) {
          _archiveClResult = _archiveCl;
        }
        if (_replacementClResult.isEmpty) {
          _replacementClResult = _replacementCl;
        }
      }, builder: (context, state) {
        if (state.status.isError) {
          return Center(
            child: BoxInfo(
                title: 'Ошибка загрузки данных'.tr(), iconData: Icons.error),
          );
        }

        if (state.status.isLoading) {
          return Center(
            child: CircularProgressIndicator(color: colorOrange),
          );
        }

        return DefaultTabController(
            length: 5,
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (BuildContext context, Widget? child) {
                    return SizedBox(
                      height: _animation.value,
                      child: SearchClients(
                        open: _animation.value>40.0,
                        onChange: (d) {
                          setState(() {
                            _handleSearchMyLids(d);
                          });
                        },
                      ),
                    );
                    },

                  ),
                  TabBar(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    tabAlignment: TabAlignment.start,
                    dividerColor: Colors.transparent,
                    isScrollable: true,
                    tabs: [
                      Text('Все'.tr(),
                          style: TStyle.textStyleVelaSansBold(
                              Theme.of(context).textTheme.displayMedium!.color!,
                              size: 14.0)),
                      Text('Клиенты сегодня'.tr(),
                          style: TStyle.textStyleVelaSansBold(
                              Theme.of(context).textTheme.displayMedium!.color!,
                              size: 14.0)),
                      Text('Активные'.tr(),
                          style: TStyle.textStyleVelaSansBold(
                              Theme.of(context).textTheme.displayMedium!.color!,
                              size: 14.0)),
                      Text('Замены'.tr(),
                          style: TStyle.textStyleVelaSansBold(
                              Theme.of(context).textTheme.displayMedium!.color!,
                              size: 14.0)),
                      Text('Архив'.tr(),
                          style: TStyle.textStyleVelaSansBold(
                              Theme.of(context).textTheme.displayMedium!.color!,
                              size: 14.0))
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: TabBarView(
                      children: [
                        ListView(
                          padding: const EdgeInsets.only(bottom: 90,top: 10),
                          controller: _controller,
                          children: [
                            if (_allCl.isEmpty) ...{
                              Padding(
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height /
                                        4),
                                child: BoxInfo(
                                    title: 'Список клиентов пуст'.tr(),
                                    iconData: Icons.list_rounded),
                              )
                            } else ...{
                              if (_allClResult.isNotEmpty) ...{
                                ...List.generate(_allClResult.length,
                                    (index) {
                                  return ItemAll(client: _allClResult[index]);
                                })
                              } else ...{
                                Padding(
                                  padding: EdgeInsets.only(
                                      top:
                                          MediaQuery.of(context).size.height /
                                              4),
                                  child: BoxInfo(
                                      title:
                                          'Нет подходящих результатов'.tr(),
                                      iconData: Icons.list_rounded),
                                )
                              }
                            }
                          ],
                        ),
                        ListView(
                          padding: const EdgeInsets.only(bottom: 90,top: 10),
                          controller: _controller,
                          children: [
                            if (_todayCl.isEmpty) ...{
                              Padding(
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height /
                                        4),
                                child: BoxInfo(
                                    title: 'Список клиентов пуст'.tr(),
                                    iconData: Icons.list_rounded),
                              )
                            } else ...{
                              if (_todayClResult.isNotEmpty) ...{
                                ...List.generate(_todayClResult.length,
                                    (index) {
                                  return ItemToday(
                                    client: _todayClResult[index],
                                  );
                                }),
                              } else ...{
                                Padding(
                                  padding: EdgeInsets.only(
                                      top:
                                          MediaQuery.of(context).size.height /
                                              4),
                                  child: BoxInfo(
                                      title:
                                          'Нет подходящих результатов'.tr(),
                                      iconData: Icons.list_rounded),
                                )
                              }
                            }
                          ],
                        ),
                        ListView(
                          padding: const EdgeInsets.only(bottom: 90,top: 10),
                          controller: _controller,
                          children: [
                            if (_activeCl.isEmpty) ...{
                              Padding(
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height /
                                        4),
                                child: BoxInfo(
                                    title: 'Список клиентов пуст'.tr(),
                                    iconData: Icons.list_rounded),
                              )
                            } else ...{
                              if (_activeClResult.isNotEmpty) ...{
                                ...List.generate(_activeClResult.length,
                                    (index) {
                                  return ItemAction(
                                    client: _activeClResult[index],
                                  );
                                }),
                              } else ...{
                                Padding(
                                  padding: EdgeInsets.only(
                                      top:
                                          MediaQuery.of(context).size.height /
                                              4),
                                  child: BoxInfo(
                                      title:
                                          'Нет подходящих результатов'.tr(),
                                      iconData: Icons.list_rounded),
                                )
                              }
                            }
                          ],
                        ),
                        ListView(
                          padding: const EdgeInsets.only(bottom: 90,top: 10),
                          controller: _controller,
                          children: [
                            if (_replacementCl.isEmpty) ...{
                              Padding(
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height /
                                        4),
                                child: BoxInfo(
                                    title: 'Список клиентов пуст'.tr(),
                                    iconData: Icons.list_rounded),
                              )
                            } else ...{
                              if (_replacementClResult.isNotEmpty) ...{
                                ...List.generate(_replacementClResult.length,
                                    (index) {
                                  return ItemAll(
                                      client: _replacementClResult[index]);
                                })
                              } else ...{
                                Padding(
                                  padding: EdgeInsets.only(
                                      top:
                                          MediaQuery.of(context).size.height /
                                              4),
                                  child: BoxInfo(
                                      title:
                                          'Нет подходящих результатов'.tr(),
                                      iconData: Icons.list_rounded),
                                )
                              }
                            }
                          ],
                        ),
                        ListView(
                          padding: const EdgeInsets.only(bottom: 90,top: 10),
                          controller: _controller,
                          children: [
                            if (_archiveCl.isEmpty) ...{
                              Padding(
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height /
                                        2.8),
                                child: BoxInfo(
                                    title: 'Список клиентов пуст'.tr(),
                                    iconData: Icons.list_rounded),
                              )
                            } else ...{
                              if (_archiveClResult.isNotEmpty) ...{
                                ...List.generate(_archiveClResult.length,
                                    (index) {
                                  return ItemArchive(
                                    client: _archiveClResult[index],
                                  );
                                }),
                              } else ...{
                                Padding(
                                  padding: EdgeInsets.only(
                                      top:
                                          MediaQuery.of(context).size.height /
                                              2.8),
                                  child: BoxInfo(
                                      title:
                                          'Нет подходящих результатов'.tr(),
                                      iconData: Icons.list_rounded),
                                )
                              }
                            }
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ));
      }),
    );
  }
}

class SearchClients extends StatefulWidget {
  const SearchClients({super.key, required this.onChange, required this.open});

  final Function onChange;
  final bool open;

  @override
  State<SearchClients> createState() => _SearchClientsState();
}

class _SearchClientsState extends State<SearchClients> {

  late TextEditingController _editingController;


  @override
  void initState() {
    super.initState();
    _editingController = TextEditingController();
  }


  @override
  void dispose() {
    super.dispose();
    _editingController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if(!widget.open){
      print('Clera');
      _editingController.clear();
    }

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 15),
      child: TextField(
        controller: _editingController,
        keyboardType: TextInputType.text,
        textAlign: TextAlign.start,
        onChanged: (d) {
          widget.onChange.call(d);
        },
        style: TextStyle(
            color: Theme.of(context).textTheme.displayMedium!.color!),
        cursorColor: colorBeruza,
        decoration: InputDecoration(
            //border: InputBorder.none,
            filled: true,
            fillColor: Theme.of(context).colorScheme.background,
            hintText: 'Поиск'.tr(),
            hintStyle: TStyle.textStyleVelaSansMedium(
                colorGrey.withOpacity(0.4),
                size: 16),
            contentPadding: const EdgeInsets.only(
                left: 20, right: 20, top: 10, bottom: 5),
            enabledBorder: widget.open?OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(
                color: colorGrey,
                width: 1.0,
              ),
            ):InputBorder.none,
           focusedBorder: widget.open?OutlineInputBorder(
             borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(
                color: colorBeruza,
                width: 1.0,
              ),
            ):InputBorder.none
        ),
      ),
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
            const Gap(7),
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
                Container(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color:
                          client.countAllLesson - client.countBalanceLesson == 1
                              ? colorOrange
                              : null),
                  child: Text(
                      '${client.countBalanceLesson} из ${client.countAllLesson}',
                      style: TStyle.textStyleVelaSansExtraBolt(
                          Theme.of(context).textTheme.displayMedium!.color!,
                          size: 12.0)),
                )
              ],
            ),
            const Gap(3),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PhoneNum(phone: client.phoneNum),
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
                    Text(
                        '${DateTimeParser.getDateFromApi(date: client.dateNearLesson)} ${client.timeNearLesson}',
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
                          color: client.statusNearLesson.isComplete ||
                                  client.statusNearLesson.isPlanned
                              ? textColorBlack(context)
                              : Colors.transparent),
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(
                      StatusToColor.getNameStatus(client.statusNearLesson),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TStyle.textStyleVelaSansBold(
                          client.statusNearLesson.isComplete ||
                                  client.statusNearLesson.isPlanned
                              ? colorBlack
                              : textColorBlack(context),
                          size: 10.0)),
                )
              ],
            ),
            const Gap(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      color: colorGreen,
                      size: 14,
                    ),
                    const Gap(5),
                    Text('ДоА:',
                        style: TStyle.textStyleVelaSansMedium(colorGrey,
                            size: 13.0)),
                  ],
                ),
                Visibility(
                  visible: _dateDoa(client.dOa),
                  child: Container(
                    padding:
                        const EdgeInsets.only(left: 5, right: 5, bottom: 3),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: colorOrange, width: 1)),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 2.5),
                          child: Icon(Icons.info_outline,
                              color: colorOrange, size: 10),
                        ),
                        const Gap(3),
                        Text('oсталось менее недели'.tr(),
                            style: TStyle.textStyleVelaSansBold(colorOrange,
                                size: 10.0)),
                      ],
                    ),
                  ),
                ),
                Text(DateTimeParser.getDateFromApi(date: client.dOa),
                    style: TStyle.textStyleVelaSansBold(
                        Theme.of(context).textTheme.displayMedium!.color!,
                        size: 14.0))
              ],
            ),
            const Gap(7),
            Divider(color: colorGrey),
          ],
        ),
      ),
    );
  }

  bool _dateDoa(String date) {
    final d1 = DateFormat('yyyy-MM-dd').parse(date).millisecondsSinceEpoch;
    final d2 = DateTime.now().millisecondsSinceEpoch;
    if (d2 < d1) {
      final res = d1 - d2;
      if (res <= 604800000) {
        return true;
      }
    }
    return false;
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
              title: client.name,
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
                PhoneNum(phone: client.phoneNum),
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
                    Text(
                        '${DateTimeParser.getDateFromApi(date: client.dateNearLesson)} ${client.timeNearLesson}',
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
                          color: client.statusNearLesson.isComplete ||
                                  client.statusNearLesson.isPlanned
                              ? textColorBlack(context)
                              : Colors.transparent),
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(
                      StatusToColor.getNameStatus(client.statusNearLesson),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TStyle.textStyleVelaSansBold(
                          client.statusNearLesson.isComplete ||
                                  client.statusNearLesson.isPlanned
                              ? colorBlack
                              : textColorBlack(context),
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
              title: client.name,
              blurred: true,
              content: DetailsClient());
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
                      width: MediaQuery.of(context).size.width - 150,
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
                PhoneNum(phone: client.phoneNum),
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
                    Text(
                        '${DateTimeParser.getDateFromApi(date: client.dateLestLesson)} ${client.timeNearLesson}',
                        //todo time lastLesson
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
                          color: client.statusLastLesson.isComplete ||
                                  client.statusLastLesson.isPlanned
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
              title: client.name,
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
                PhoneNum(phone: client.phoneNum),
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
                    Text(
                        '${DateTimeParser.getDateFromApi(date: client.dateNearLesson)} ${client.timeNearLesson}',
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
                          color: client.statusNearLesson.isComplete ||
                                  client.statusNearLesson.isPlanned
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
                PhoneNum(phone: client.phoneNum),
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
                    Text(
                        '${DateTimeParser.getDateFromApi(date: client.dateNearLesson)} ${client.timeNearLesson}',
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
                          color: client.statusNearLesson.isComplete ||
                                  client.statusNearLesson.isPlanned
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



