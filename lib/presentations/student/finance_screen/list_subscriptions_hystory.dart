import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:virtuozy/components/app_bar.dart';
import 'package:virtuozy/presentations/student/finance_screen/bloc/bloc_finance.dart';
import 'package:virtuozy/presentations/student/finance_screen/bloc/state_finance.dart';
import 'package:virtuozy/presentations/student/widgets/options_list.dart';
import 'package:virtuozy/utils/date_time_parser.dart';
import 'package:virtuozy/utils/parser_price.dart';

import '../../../components/box_info.dart';
import '../../../components/drawing_menu_selected.dart';
import '../../../domain/entities/subscription_entity.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../resourses/colors.dart';
import '../../../utils/craeator_list_directions.dart';
import '../../../utils/text_style.dart';
import 'bloc/event_finance.dart';

class ListSubscriptionHistory extends StatefulWidget {
  const ListSubscriptionHistory(
      {super.key, required this.directions, required this.selIdDirection});

  final List<DirectionLesson> directions;
  final int selIdDirection;

  @override
  State<ListSubscriptionHistory> createState() =>
      _ListSubscriptionHistoryState();
}

class _ListSubscriptionHistoryState extends State<ListSubscriptionHistory> {
  List<String> _titlesDirections = [];
  int _selIndexDirection = 0;
  bool _allViewDirection = true;

  // List<DirectionLesson> directions = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _titlesDirections = CreatorListDirections.getTitlesDrawingMenu(
        directions: widget.directions);
    print('Titles 1 ${_titlesDirections.length}');
  }

  @override
  void initState() {
    super.initState();
    if (widget.selIdDirection > 0) {
      final dirIndex =
          widget.directions.indexWhere((d) => d.id == widget.selIdDirection);
      _selIndexDirection = dirIndex;
      _allViewDirection = false;
    }
    context.read<BlocFinance>().add(GetListHistorySubsEvent(
        refreshDirection: false,
        directions: widget.directions,
        allViewDir: _allViewDirection,
        currentDirIndex: _selIndexDirection));
  }

  Future<void> _refreshData() async {
    context.read<BlocFinance>().add(GetListHistorySubsEvent(
        refreshDirection: false,
        directions: widget.directions,
        allViewDir: _allViewDirection,
        currentDirIndex: _selIndexDirection));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(title: 'История абонементов'.tr()),
      body: BlocConsumer<BlocFinance, StateFinance>(listener: (c, s) {
        if (s.listHistorySubsStatus == ListHistorySubsStatus.loaded) {
          _titlesDirections = CreatorListDirections.getTitlesDrawingMenu(
              directions: widget.directions);
        }
      }, builder: (context, state) {
        if (state.listHistorySubsStatus == ListHistorySubsStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(
          onRefresh: () {
            return _refreshData();
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (state.subscriptionHistory.isEmpty) ...{
                BoxInfo(
                    title: 'Список пуст'.tr(), iconData: Icons.list_alt_sharp)
              } else ...{
                Visibility(
                  visible: widget.selIdDirection<0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: DrawingMenuSelected(
                      items: _titlesDirections,
                      onSelected: (index) {
                        _selIndexDirection = index;
                        if (index == _titlesDirections.length - 1) {
                          _allViewDirection = true;
                        } else {
                          _allViewDirection = false;
                        }
                        context.read<BlocFinance>().add(GetListHistorySubsEvent(
                            refreshDirection: true,
                            directions: state.directions,
                            allViewDir: _allViewDirection,
                            currentDirIndex: _selIndexDirection));
                      },
                    ),
                  ),
                ),
                const Gap(15),
                if (state.listHistorySubsStatus ==
                    ListHistorySubsStatus.refresh) ...{
                  const Expanded(
                      child: Center(child: CircularProgressIndicator()))
                } else ...{
                  Expanded(
                    child: GroupedListView<SubscriptionEntity, String>(
                      elements: state.subscriptionHistory,
                      sort: false,
                      groupBy: (element) => DateTimeParser.getDateForCompare(
                          date: element.dateBay),
                      groupSeparatorBuilder: (String value) => Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Center(
                            child: Text(
                          value,
                          style: TStyle.textStyleVelaSansBold(
                              Theme.of(context).textTheme.displayMedium!.color!,
                              size: 14),
                        )),
                      ),
                      itemBuilder: (context, SubscriptionEntity element) {
                        return ItemSubHistory(subscriptionEntity: element);
                      },
                      itemComparator: (item1, item2) {
                        return DateTimeParser.getDateForCompare(
                                date: item1.dateBay)
                            .compareTo(DateTimeParser.getDateForCompare(
                                date: item2.dateBay));
                      },
                      // optional
                      useStickyGroupSeparators: false,
                      // optional
                      floatingHeader: true,
                      // optional
                      order: GroupedListOrder.ASC, // optional
                    ),
                  )

                  // Expanded(
                  //           child:  ListView.builder(
                  //               padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  //               itemCount: widget.listExpiredSubscriptions.length,
                  //               itemBuilder: (c,i){
                  //                 return ItemSubHistory(
                  //                    subscriptionEntity: widget.listExpiredSubscriptions[i]);
                  //               }),
                  //         )
                }
              }
            ],
          ),
        );
      }),
    );
  }
}

class ItemSubHistory extends StatelessWidget {
  const ItemSubHistory({super.key, required this.subscriptionEntity});

  final SubscriptionEntity subscriptionEntity;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Theme.of(context).colorScheme.surfaceContainerHighest),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 50.0),
              child: Text(subscriptionEntity.nameDir,
                  style: TStyle.textStyleVelaSansExtraBolt(
                      Theme.of(context).textTheme.displayMedium!.color!,
                      size: 18.0)),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                    color: colorOrange.withOpacity(0.2),
                    shape: BoxShape.circle),
                child: Icon(Icons.music_note_rounded, color: colorOrange),
              ),
              const Gap(15.0),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(subscriptionEntity.name,
                      style: TStyle.textStyleVelaSansBold(
                          Theme.of(context).textTheme.displayMedium!.color!,
                          size: 14.0)),
                  const Gap(5.0),
                  Row(
                    children: [
                      Icon(Icons.timelapse_rounded,
                          color: colorBeruza, size: 10.0),
                      const Gap(3.0),
                      Row(
                        children: [
                          Text('Дата покупки'.tr(),
                              style: TStyle.textStyleVelaSansRegular(
                                  colorBeruza,
                                  size: 10.0)),
                          Text(
                              ' ${DateTimeParser.getDateFromApi(date: subscriptionEntity.dateBay)}',
                              style: TStyle.textStyleVelaSansBold(colorBeruza,
                                  size: 10.0))
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
                          Icon(Icons.timelapse_rounded,
                              color: colorBeruza, size: 10.0),
                          const Gap(3.0),
                          Row(
                            children: [
                              Text('Дата начала'.tr(),
                                  style: TStyle.textStyleVelaSansRegular(
                                      colorBeruza,
                                      size: 10.0)),
                              Text(
                                  ' ${DateTimeParser.getDateFromApi(date: subscriptionEntity.dateStart)}',
                                  style: TStyle.textStyleVelaSansBold(
                                      colorBeruza,
                                      size: 10.0))
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
                          Icon(Icons.timelapse_rounded,
                              color: colorBeruza, size: 10.0),
                          const Gap(3.0),
                          Row(
                            children: [
                              Text('Дата окончания'.tr(),
                                  style: TStyle.textStyleVelaSansRegular(
                                      colorBeruza,
                                      size: 10.0)),
                              Text(
                                  ' ${DateTimeParser.getDateFromApi(date: subscriptionEntity.dateEnd)}',
                                  style: TStyle.textStyleVelaSansBold(
                                      colorBeruza,
                                      size: 10.0))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 100.0,
                    margin: const EdgeInsets.only(top: 10.0),
                    padding: const EdgeInsets.only(
                        right: 8.0, left: 8.0, bottom: 2.0),
                    decoration: BoxDecoration(
                        color: subscriptionEntity.status ==
                                    StatusSub.inactive ||
                                subscriptionEntity.status == StatusSub.planned
                            ? colorRed
                            : colorGreen,
                        borderRadius: BorderRadius.circular(10.0)),
                    alignment: Alignment.center,
                    child: Text(
                        subscriptionEntity.status == StatusSub.inactive
                            ? 'окончился'.tr()
                            : subscriptionEntity.status == StatusSub.planned
                                ? 'запланирован'.tr()
                                : 'активный'.tr(),
                        style: TStyle.textStyleVelaSansBold(colorWhite,
                            size: 10.0)),
                  ),
                ],
              )),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 50),
            child: OptionsList(subscription: subscriptionEntity),
          ),
          const Gap(10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  Text(ParserPrice.getBalance(subscriptionEntity.price),
                      style: TStyle.textStyleVelaSansExtraBolt(
                          Theme.of(context).textTheme.displayMedium!.color!,
                          size: 14.0)),
                  Icon(CupertinoIcons.money_rubl,
                      color: Theme.of(context).textTheme.displayMedium!.color!,
                      size: 16.0)
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
