


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

import '../../components/drawing_menu_selected.dart';
import '../../resourses/colors.dart';
import '../../utils/text_style.dart';
import 'bloc/event_finance.dart';

class PayPage extends StatefulWidget{
   const PayPage({super.key, required this.direction});

   final DirectionLesson direction;


  @override
  State<PayPage> createState() => _PayPageState();
}

class _PayPageState extends State<PayPage> {

  bool _sbpPay = false;
  bool _cardPay = false;
  int _selIndexDirection = 0;
  late PriceSubscriptionEntity _selPriceSubscription;


  @override
  void initState() {
    super.initState();
    context.read<BlocFinance>().add(GetListSubscriptionsEvent(nameDirection: widget.direction.name));
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBarCustom(title: 'Пополнить счет'.tr()),
      body: BlocConsumer<BlocFinance,StateFinance>(
        listener: (c, s) {
            if(s.paymentStatus == PaymentStatus.loaded){
              _selPriceSubscription = s.pricesDirectionEntity.subscriptions[0];
            }
        },
        builder: (context,state) {


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
            child: Column(
              children: [
                // Visibility(
                //   visible: false,
                //   child: DrawingMenuSelected(items:_listDirection, onSelected: (index){
                //     setState(() {
                //       _selIndexDirection = index;
                //     });
                //   },),
                // ),
                // const Gap(10.0),
                DrawingMenuSelected(
                  items: state.pricesDirectionEntity.subscriptions
                      .map((e) => '${e.name} - ${e.price} руб.').toList(),
                  onSelected: (index){
                    print('Seke ${ state.pricesDirectionEntity.subscriptions[index]}');
                    _selPriceSubscription = state.pricesDirectionEntity.subscriptions[index];
                },),
                const Gap(20.0),
                Container(
                  padding: const EdgeInsets.all(20.0),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: colorBeruzaLight,
                      borderRadius: BorderRadius.circular(20.0)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Способ оплаты'.tr(),style: TStyle.textStyleVelaSansBold(colorBlack,size: 16.0)),
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
                               Text('СБП',style: TStyle.textStyleVelaSansBold(colorBlack,size: 20.0),),
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
                              Text('Картой'.tr(),style: TStyle.textStyleVelaSansBold(colorBlack,size: 20.0),),
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
                       context.read<BlocFinance>()
                           .add(PaySubscriptionEvent(priceSubscriptionEntity: _selPriceSubscription,
                       currentDirection: widget.direction));
                     },
                     textButton: 'К оплате'.tr(),
                   ).animate().fadeIn(),
                 )
              ],
            ),
          );
        },
      ),
    );
  }
}