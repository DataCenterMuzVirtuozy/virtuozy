import 'dart:async';

import 'package:badges/badges.dart' as badges;
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:virtuozy/components/box_info.dart';
import 'package:virtuozy/components/calendar/calendar.dart';
import 'package:virtuozy/components/dialogs/dialoger.dart';
import 'package:virtuozy/components/teacher_contacts.dart';
import 'package:virtuozy/data/rest/endpoints.dart';
import 'package:virtuozy/domain/entities/subscription_entity.dart';
import 'package:virtuozy/domain/entities/user_entity.dart';
import 'package:virtuozy/resourses/colors.dart';
import 'package:virtuozy/router/paths.dart';
import 'package:virtuozy/utils/date_time_parser.dart';

import '../../../components/buttons.dart';
import '../../../components/dialogs/sealeds.dart';
import '../../../components/drawing_menu_selected.dart';
import '../../../components/home_drawer_menu.dart';
import '../../../di/locator.dart';
import '../../../domain/entities/lesson_entity.dart';
import '../../../utils/parser_price.dart';
import '../../../utils/preferences_util.dart';
import '../../../utils/text_style.dart';
import '../finance_screen/bloc/bloc_finance.dart';
import '../finance_screen/bloc/event_finance.dart';
import '../widgets/options_list.dart';
import 'bloc/sub_bloc.dart';
import 'bloc/sub_event.dart';
import 'bloc/sub_state.dart';

int globalCurrentMonthCalendar = 0;

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  int _selIndexDirection = 0;
  //final currentDayNotifi = locator.get<ValueNotifier<List<int>>>();
  BonusEntity bonus = BonusEntity.unknown();
  List<String> _titlesDirections = [];
  bool _hasBonus = false;
  bool _resetFocus = false;
  bool _allViewDirection = false;
  late DateTime _focusedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    context.read<SubBloc>().add(GetUserEvent(
        allViewDir: true,
        currentDirIndex: _selIndexDirection,
        refreshDirection: true));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  bool _visibleButtonBonus({required List<BonusEntity> bonuses}) {
    if (bonuses.isEmpty) {
      return false;
    } else {
      for (var b in bonuses) {
        if (!b.active) {
          return true;
        }
      }
    }
    return false;
  }

  Future<void> _refreshData() async {
    context.read<SubBloc>().add(RefreshDataEvent(
        allViewDir: true,
        currentDirIndex: _selIndexDirection,
        refreshDirection: true));
  }

  int _maxNumberLessonFromSubs(
      {required int idSub, required List<SubscriptionEntity> subs}) {
    return subs.firstWhere((s) => s.id == idSub).maxLessonsCount;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SubBloc, SubState>(listener: (c, s) {
      if (s.subStatus == SubStatus.confirm) {
        context.read<BlocFinance>().add(WritingOfMoneyEvent(
            lessonConfirm: s.lessonConfirm,
            currentDirection: s.userEntity.directions[_selIndexDirection]));
      }

      if (s.subStatus == SubStatus.loaded) {
        if (s.directions.length > 1) {
          _allViewDirection = true;
        }
        _titlesDirections = s.titlesDrawingMenu;
      }
    }, builder: (context, state) {
      if (state.subStatus == SubStatus.unknown) {
        return Container();
      }

      if (state.subStatus == SubStatus.loading) {
        return Center(child: CircularProgressIndicator(color: colorOrange));
      }

      if (state.subStatus == SubStatus.loaded) {
        if (state.userEntity.userStatus.isModeration ||
            state.userEntity.userStatus.isNotAuth) {
          return Center(
            child: BoxInfo(
                buttonVisible: state.userEntity.userStatus.isNotAuth,
                title: state.userEntity.userStatus.isModeration
                    ? 'Ваш аккаунт на модерации'.tr()
                    : 'Абонементы недоступны'.tr(),
                description: state.userEntity.userStatus.isModeration
                    ? 'На период модерации работа с абонементами недоступна'
                        .tr()
                    : 'Для работы с абонементами необходимо авторизироваться'
                        .tr(),
                iconData: CupertinoIcons.music_note_list),
          );
        }
      }

      if (state.directions.isEmpty && state.subStatus == SubStatus.loaded) {
        return Center(
          child: BoxInfo(
              buttonVisible: false,
              title: 'Список пуст'.tr(),
              description: 'У вас нет направлений обучения'.tr(),
              iconData: CupertinoIcons.music_note_list),
        );
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: RefreshIndicator(
          onRefresh: () {
            return _refreshData();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: DrawingMenuSelected(
                      items: _titlesDirections,
                      onSelected: (index) {
                        _resetFocus = false;
                        _selIndexDirection = index;
                        if (index == _titlesDirections.length - 1) {
                          _allViewDirection = true;
                        } else {
                          _allViewDirection = false;
                        }
                        context.read<SubBloc>().add(GetUserEvent(
                            allViewDir: _allViewDirection,
                            currentDirIndex: _selIndexDirection,
                            refreshDirection: false));
                      },
                    )),
                const Gap(10.0),
                Calendar(
                  focusedDay: _focusedDay,
                  onDate: (date) {
                    _focusedDay = date;
                  },
                  colorFill:
                      Theme.of(context).colorScheme.surfaceContainerHighest,
                  resetFocusDay: _resetFocus,
                  lessons: state.lessons,
                  onMonth: (month) {
                    _resetFocus = false;
                    globalCurrentMonthCalendar = month;
                  },
                  onLesson: (List<Lesson> lessons) {
                    // var l = state.lessons.where((l)=>l.idDir == lessons[0].idDir);
                    // print('Lessons ${l.length}');
                    // print('Subs ${state.directions[_selIndexDirection].lastSubscriptions[0].id}');
                    Dialoger.showModalBottomMenu(
                        blurred: false,
                        args: [lessons, state.userEntity.directions],
                        content: DetailsLesson());
                  },
                ),
                Visibility(
                  visible: state.listNotAcceptLesson.isNotEmpty,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        const Gap(20.0),
                        badges.Badge(
                          position:
                              badges.BadgePosition.topEnd(end: -5.0, top: -8.0),
                          showBadge: state.listNotAcceptLesson.length > 1,
                          badgeContent: Text(
                              '${state.listNotAcceptLesson.length}',
                              style: TStyle.textStyleVelaSansBold(colorWhite)),
                          child: SizedBox(
                            height: 40.0,
                            child: SubmitButton(
                              onTap: () {
                                Dialoger.showModalBottomMenu(
                                    blurred: false,
                                    args: [
                                      state.firstNotAcceptLesson,
                                      state.directions,
                                      state.listNotAcceptLesson,
                                      _allViewDirection
                                    ],
                                    title: 'Подтверждение урока'.tr(),
                                    content: ConfirmLesson());
                              },
                              //colorFill: Theme.of(context).colorScheme.tertiary,
                              colorFill: colorGreen,
                              borderRadius: 10.0,
                              textButton: 'Подтвердите прохождение урока'.tr(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Gap(10),
                BoxSubscription(
                    key: ValueKey(state.directions),
                    namesDir: _titlesDirections,
                    directions: state.directions,
                    allViewDirection: _allViewDirection),
                const Gap(10.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      const Gap(10.0),
                      if (_visibleButtonBonus(bonuses: state.bonuses)) ...{
                        Padding(
                          padding: const EdgeInsets.only(bottom: 30.0),
                          child: badges.Badge(
                            position: badges.BadgePosition.topEnd(
                                end: -5.0, top: -8.0),
                            showBadge: state.bonuses.length > 1,
                            badgeContent: Text('${state.bonuses.length}',
                                style:
                                    TStyle.textStyleVelaSansBold(colorWhite)),
                            child: SizedBox(
                              height: 40.0,
                              child: OutLineButton(
                                onTap: () {
                                  if (state.bonuses.length > 1) {
                                    Dialoger.showModalBottomMenu(
                                        title: 'Получить бонусы'.tr(),
                                        blurred: true,
                                        args: state.bonuses,
                                        content: ListBonuses());
                                  } else {
                                    GoRouter.of(context).push(pathDetailBonus,
                                        extra: [
                                          state.bonuses[0],
                                          state.userEntity.directions[0]
                                        ]);
                                  }
                                },
                                borderRadius: 10.0,
                                textButton: state.bonuses.length > 1
                                    ? 'Получить бонусы'.tr()
                                    : state.bonuses[0].title,
                              ),
                            ),
                          ),
                        )
                      }
                    ],
                  ),
                )
              ],
            ),
          ).animate().fadeIn(duration: const Duration(milliseconds: 700)),
        ),
      );
    });
  }
}

class BoxSubscription extends StatefulWidget {
  const BoxSubscription(
      {super.key,
      required this.directions,
      required this.allViewDirection,
      required this.namesDir});

  final List<DirectionLesson> directions;
  final bool allViewDirection;
  final List<String> namesDir;

  @override
  State<BoxSubscription> createState() => _BoxSubscriptionState();
}

class _BoxSubscriptionState extends State<BoxSubscription> {
  List<SubscriptionEntity> subs = [];

  //late StreamSubscription<List<PurchaseDetails>> _subscription;

  double _summaBalance({required List<DirectionLesson> directions}) {
    double sum = 0.0;
    for (var dir in directions) {
      sum += double.parse(dir.balance);
      // for (var s in dir.lastSubscriptions) {
      //   sum += s.balanceSub;
      // }
    }
    return sum;
  }

  List<SubscriptionEntity> _getSubs(
      {required List<DirectionLesson> directions,
      required bool allViewDirection}) {
    List<SubscriptionEntity> list = [];
    for (var dir in directions) {
      for (var s in dir.lastSubscriptions) {
        list.add(s);
      }
    }
    return list;
  }

  // void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
  //   print('P ${purchaseDetailsList}');
  //   purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
  //     if (purchaseDetails.status == PurchaseStatus.pending) {
  //       //_showPendingUI();
  //     } else {
  //       if (purchaseDetails.status == PurchaseStatus.error) {
  //         print('Error');
  //         //_handleError(purchaseDetails.error!);
  //       } else if (purchaseDetails.status == PurchaseStatus.purchased ||
  //           purchaseDetails.status == PurchaseStatus.restored) {
  //         // bool valid = await _verifyPurchase(purchaseDetails);
  //         // if (valid) {
  //         //   //_deliverProduct(purchaseDetails);
  //         // } else {
  //         //   //_handleInvalidPurchase(purchaseDetails);
  //         // }
  //       }
  //       if (purchaseDetails.pendingCompletePurchase) {
  //         await InAppPurchase.instance
  //             .completePurchase(purchaseDetails);
  //       }
  //     }
  //   });
  // }

  @override
  void initState() {
    // final Stream<List<PurchaseDetails>> purchaseUpdated = InAppPurchase.instance.purchaseStream;
    // _subscription = purchaseUpdated.listen((purchaseDetailsList) {
    //   _listenToPurchaseUpdated(purchaseDetailsList);
    // }, onDone: () {
    //   _subscription.cancel();
    // }, onError: (error) {
    //   // handle error here.
    // });

    // _productsDetails();

    super.initState();
    subs = _getSubs(
        directions: widget.directions,
        allViewDirection: widget.allViewDirection);
  }

  // Future<void> _productsDetails() async {
  //   final ProductDetailsResponse response =
  //       await InAppPurchase.instance.queryProductDetails({'sub_test'});
  //   if (response.notFoundIDs.isNotEmpty) {
  //     // Handle the error.
  //     print('Error 2 ');
  //   }
  //   List<ProductDetails> products = response.productDetails;
  //   print('Product ${products.length} ');
  // }

  @override
  void dispose() {
    // _subscription.cancel();
    super.dispose();

//
  }

  List<SubscriptionEntity> _getHistorySubscriptions(
      List<DirectionLesson> directions, int idSelDir) {
    DirectionLesson dir = directions.firstWhere((d) => d.id == idSelDir);
    return dir.subscriptionsAll;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      padding: const EdgeInsets.all(20.0),
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Активные абонементы'.tr(),
              style: TStyle.textStyleVelaSansExtraBolt(
                  Theme.of(context).textTheme.displayMedium!.color!,
                  size: 18.0)),
          const Gap(10.0),
          Divider(color: colorGrey),
          Column(
            children: [
              ...List.generate(subs.length, (index) {
                // if(widget.directions[index].lastSubscriptions.isEmpty){
                //   return Container();
                // }

                return ItemSub(
                    onTap: (int idDir) {
                      // final subsList =
                      //     _getHistorySubscriptions(widget.directions, idDir);

                      GoRouter.of(context)
                          .push(pathListSubscriptionsHistory, extra: [widget.directions,idDir]);
                    },
                    direction: widget.directions.firstWhere((d)=>d.name == subs[index].nameDir),
                    subscription: subs[index]);

                // return ItemSubscription(direction: directions[index],
                //     allViewDirection: allViewDirection, namesDir: namesDir);
              })
            ],
          ),
          // BoxSubscription(directions: directions,allViewDirection: allViewDirection,
          // namesDir: namesDir),
          const Gap(10.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Container(
              //   margin: const EdgeInsets.only(top: 2.0),
              //   decoration: BoxDecoration(
              //       color: Theme.of(context).colorScheme.secondary,
              //       shape: BoxShape.circle
              //   ),
              //   child:  Icon(CupertinoIcons.money_rubl_circle,color: colorWhite,size: 20.0,),),

              Text(
                'Общий баланс',
                style: TStyle.textStyleVelaSansBold(textColorBlack(context),
                    size: 18),
              ),
              const Gap(5.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Gap(15),
                  Text(
                      ParserPrice.getBalance(
                          _summaBalance(directions: widget.directions)),
                      style: TStyle.textStyleVelaSansBold(
                          Theme.of(context).textTheme.displayMedium!.color!,
                          size: 20.0)),
                  Icon(
                    CupertinoIcons.money_rubl,
                    color: Theme.of(context).iconTheme.color,
                    size: 25.0,
                  )
                ],
              ),
            ],
          ),
          const Gap(15.0),
          SizedBox(
            height: 40.0,
            child: SubmitButton(
                textButton: 'Пополнить'.tr(),
                onTap: () async {
                  //currentItemNotifier.value = 4;
                  GoRouter.of(context).push(pathWep,
                      extra: PreferencesUtil.branchUser == 'nsk'
                          ? Endpoints.urlPriceNsk
                          : Endpoints.urlPriceMsk);
                }),
          ),
          const Gap(5.0),
        ],
      ),
    );
  }
}

class ItemSub extends StatefulWidget {
  const ItemSub({super.key, required this.subscription, required this.onTap, required this.direction});

  final SubscriptionEntity subscription;
  final Function onTap;
  final DirectionLesson direction;

  @override
  State<ItemSub> createState() => _ItemSubState();
}

class _ItemSubState extends State<ItemSub> {
  bool _open = false;
  double _heightContainer = 80;

  @override
  Widget build(BuildContext context) {
    if (!_open) {
      _heightContainer = 80;
    } else {
      _heightContainer = widget.subscription.options.isEmpty
          ? 155
          : 155 + (widget.subscription.options.length * 20) + 35;
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: InkWell(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          setState(() {
            if (!_open) {
              _open = true;
            } else {
              _open = false;
            }
          });
        },
        child: Column(
          children: [
            AnimatedContainer(
              height: _heightContainer,
              curve: Curves.easeIn,
              duration: const Duration(milliseconds: 500),
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.subscription.nameDir,
                            style: TStyle.textStyleVelaSansBold(colorGrey,
                                size: 16.0)),
                        if (widget.subscription.status == StatusSub.active ||
                            widget.subscription.status ==
                                StatusSub.planned) ...{
                          Row(
                            children: [
                              Text('Осталось уроков:'.tr(),
                                  style: TStyle.textStyleVelaSansMedium(
                                      colorGrey,
                                      size: 14.0)),
                              const Gap(3.0),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6.0, vertical: 2),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  //color: Theme.of(context).colorScheme.secondary,
                                  //shape: BoxShape.circle
                                ),
                                child: Text(
                                    '${widget.subscription.balanceLesson} из ${widget.subscription.maxLessonsCount}',
                                    style: TStyle.textStyleVelaSansExtraBolt(
                                        Theme.of(context)
                                            .textTheme
                                            .displayMedium!
                                            .color!,
                                        size: 14.0)),
                              ),
                            ],
                          )
                        } else ...{
                          Visibility(
                            visible: widget.subscription.status ==
                                StatusSub.inactive,
                            child: Container(
                              padding: const EdgeInsets.only(
                                  right: 8.0, left: 8.0, bottom: 2.0),
                              decoration: BoxDecoration(
                                  color: colorRed,
                                  borderRadius: BorderRadius.circular(10.0)),
                              alignment: Alignment.center,
                              child: Text('неактивный'.tr(),
                                  style: TStyle.textStyleVelaSansBold(
                                      colorWhite,
                                      size: 10.0)),
                            ),
                          ),
                        },
                      ],
                    ),
                    const Gap(5),
                    Visibility(
                      visible: widget.subscription.status == StatusSub.active ||
                          widget.subscription.status == StatusSub.planned,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              '${ParserPrice.getBalance(double.parse(widget.direction.balance))} руб.',
                              style: TStyle.textStyleVelaSansMedium(colorGrey,
                                  size: 16.0)),
                          Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.only(
                                  right: 8.0, left: 8.0, bottom: 2.0),
                              decoration: BoxDecoration(
                                  color: widget.subscription.status ==
                                          StatusSub.active
                                      ? colorGreen
                                      : colorRed,
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: Text(
                                  widget.subscription.status == StatusSub.active
                                      ? 'активный'.tr()
                                      : 'запланирован'.tr(),
                                  style: TStyle.textStyleVelaSansBold(
                                      colorWhite,
                                      size: 10.0)))
                        ],
                      ),
                    ),
                    const Gap(5.0),
                    Visibility(
                      visible: widget.subscription.nameTeacher.isNotEmpty,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Icon(Icons.person,
                                    color: colorGreen, size: 10.0),
                              ),
                              const Gap(5.0),
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.sizeOf(context).width * 0.5),
                                child: Text(widget.subscription.nameTeacher,
                                    style: TStyle.textStyleVelaSansMedium(
                                        colorGrey,
                                        size: 13.0)),
                              ),
                            ],
                          ),
                          TeacherContacts(
                            contacts: widget.subscription.contactValues,
                            size: 25.0,
                          )
                        ],
                      ),
                    ),
                    Visibility(
                      visible: widget.subscription.dateEnd.isNotEmpty,
                      child: Row(
                        children: [
                          Icon(Icons.timelapse, color: colorGreen, size: 10.0),
                          const Gap(5.0),
                          Text('Дата окончания'.tr(),
                              style: TStyle.textStyleVelaSansMedium(colorGrey,
                                  size: 13.0)),
                          const Gap(5.0),
                          Text(
                              DateTimeParser.getDateFromApi(
                                  date: widget.subscription.dateEnd),
                              style: TStyle.textStyleVelaSansMedium(colorGrey,
                                  size: 13.0)),
                        ],
                      ),
                    ),
                    OptionsList(subscription: widget.subscription),
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                          onTap: () {
                            widget.onTap.call(widget.subscription.idDir);
                          },
                          child: Text(
                            'Подробнее',
                            style: TStyle.textStyleVelaSansRegularUnderline(
                                colorGrey,
                                size: 12),
                          )),
                    )
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 5),
              color: Colors.transparent,
              child: Column(
                children: [
                  RotatedBox(
                      quarterTurns: !_open ? 1 : 3,
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: colorGrey,
                        size: 16.0,
                      )),
                  Divider(color: colorGrey),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
