


 import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:virtuozy/components/app_bar.dart';
import 'package:virtuozy/components/buttons.dart';
import 'package:virtuozy/domain/entities/price_subscription_entity.dart';
import 'package:virtuozy/domain/entities/user_entity.dart';
import 'package:virtuozy/presentations/finance_screen/bloc/bloc_finance.dart';
import 'package:virtuozy/presentations/finance_screen/bloc/state_finance.dart';
import 'package:virtuozy/resourses/images.dart';

import '../../components/dialogs/dialoger.dart';
import '../../components/drawing_menu_selected.dart';
import '../../resourses/colors.dart';
import '../../utils/text_style.dart';
import 'bloc/event_finance.dart';

class PayPage extends StatefulWidget{
   const PayPage({super.key, required this.directions});

   final List<DirectionLesson> directions;


  @override
  State<PayPage> createState() => _PayPageState();
}

class _PayPageState extends State<PayPage> {

  bool _sbpPay = false;
  bool _cardPay = false;
  int _selIndexDirection = 0;
  late PriceSubscriptionEntity _selPriceSubscription;
  List<String> _titlesDirections = [];
  List<String> _titlePrices = [];


  @override
  void initState() {
    super.initState();
    context.read<BlocFinance>().add(GetListSubscriptionsEvent(nameDirection: widget.directions[_selIndexDirection].name,
    refreshDirection: true));
    _titlesDirections = widget.directions.map((e) => e.name).toList();

  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBarCustom(title: 'Пополнить счет'.tr()),
      body: BlocConsumer<BlocFinance,StateFinance>(
        listener: (c, s) {
            if(s.paymentStatus == PaymentStatus.loaded){
              //_selPriceSubscription = s.pricesDirectionEntity.subscriptions[_selIndexDirection];
              _selPriceSubscription = s.pricesSubscriptionsAll[0];
               _titlePrices = s.pricesSubscriptionsAll.map((e) => '${e.name} - ${e.price} руб.').toList();
            }
        },
        builder: (context,state) {

          if(state.paymentStatus == PaymentStatus.loading){
            return const Center(child: CircularProgressIndicator());
          }

          if(state.paymentStatus == PaymentStatus.payment || state.paymentStatus == PaymentStatus.loading){
            return const Center(child: CircularProgressIndicator());
          }

          if(state.paymentStatus == PaymentStatus.paymentComplete){
            return Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(successAnim,repeat: false,width: 150.0,height: 150.0),
                Text('Спасибо за оплату!'.tr(),
                style: TStyle.textStyleVelaSansBold(colorGreenLight,size: 18.0),).animate().fadeIn(
                  duration: const Duration(milliseconds: 700)
                )
              ],
            ));
          }


          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Visibility(
                    visible: widget.directions.length>1,
                    child: DrawingMenuSelected(
                      items:_titlesDirections,
                      onSelected: (index){
                        _selIndexDirection = index;
                         context.read<BlocFinance>().add(GetListSubscriptionsEvent(nameDirection: widget.directions[_selIndexDirection].name,
                             refreshDirection: false));

                    },),
                  ),
                  const Gap(10.0),
                  DrawingMenuSelected(
                    key: UniqueKey(),
                    items: _titlePrices,
                    onSelected: (index){
                      _selPriceSubscription = state.pricesSubscriptionsAll[index];
                  },),
                  const Gap(20.0),
                  PaymentList(
                      onPay: (){
                    Dialoger.showMessage('В разработке');

                    // context.read<BlocFinance>()
                    //   .add(PaySubscriptionEvent(
                    //   priceSubscriptionEntity: _selPriceSubscription,
                    //   currentDirection: widget.directions[_selIndexDirection]));
                      }
                      )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

 class PaymentList extends StatefulWidget{
  const PaymentList({super.key, required this.onPay});



  final VoidCallback onPay;

  @override
  State<PaymentList> createState() => _PaymentListState();
}

class _PaymentListState extends State<PaymentList> {



   bool _sbpPay = false;
  bool _cardPay = false;


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20.0),
          width: double.infinity,
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(20.0)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Способ оплаты'.tr(),
                  style: TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!,size: 16.0)),
              const Gap(20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(30.0),
                          child: Image.asset(spbPay,width: 30.0,height: 30.0,)),
                      const Gap(20.0),
                      Text('СБП',
                        style: TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!,size: 20.0),),
                    ],
                  ),
                  Checkbox(
                      checkColor: colorWhite,
                      value: _sbpPay,
                      onChanged: (v){
                        setState(() {
                          _sbpPay = v!;
                          if(_sbpPay){
                            _cardPay = false;
                          }
                        });
                      })
                ],
              ),
              const Gap(10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                            color: colorOrange.withOpacity(0.2),
                            shape: BoxShape.circle
                        ),
                        child: Icon(Icons.payment,color: colorOrange),
                      ),
                      const Gap(20.0),
                      Text('Картой'.tr(),
                        style: TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!,size: 20.0),),
                    ],
                  ),
                  Checkbox(
                      checkColor: colorWhite,
                      value: _cardPay, onChanged: (v){
                    setState(() {
                      _cardPay = v!;
                      if(_cardPay){
                        _sbpPay = false;
                      }
                    });
                  })
                ],
              )

            ],
          ),
        ),
        const Gap(20.0),
        Visibility(
          visible: _sbpPay||_cardPay,
          child: SubmitButton(
            onTap: (){
              widget.onPay.call();
            },
            textButton: 'К оплате'.tr(),
          ).animate().fadeIn(),
        )
      ],
    );
  }
}


