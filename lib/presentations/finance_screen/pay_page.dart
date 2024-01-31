


 import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:virtuozy/components/app_bar.dart';
import 'package:virtuozy/components/buttons.dart';
import 'package:virtuozy/resourses/images.dart';

import '../../components/drawing_menu_selected.dart';
import '../../resourses/colors.dart';
import '../../utils/text_style.dart';

class PayPage extends StatefulWidget{
   const PayPage({super.key, required this.direction});

   final String direction;


  @override
  State<PayPage> createState() => _PayPageState();
}

class _PayPageState extends State<PayPage> {

  bool _sbpPay = false;
  bool _cardPay = false;
  int _selIndexDirection = 0;
  List<String> _listDirection =  [
    'Вокал'.tr(),
    'Академический вокал'.tr(),
    'Фортепиано'.tr(),
  ];

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBarCustom(title: 'Пополнить счет'.tr()),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
        child: Column(
          children: [
            Visibility(
              visible: widget.direction.isEmpty,
              child: DrawingMenuSelected(items:_listDirection, onSelected: (index){
                setState(() {
                  _selIndexDirection = index;
                });
              },),
            ),
            const Gap(10.0),
            DrawingMenuSelected(items: const [
              'Абонемент 1 - 20000 руб.',
              'Абонемент 2 - 30000 руб.',
              'Абонемент 3 - 40000 руб.',
              'Абонемент 4 - 50000 руб.'
            ], onSelected: (index){

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
                         activeColor: colorOrange,
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
                          activeColor: colorOrange,
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
                 textButton: 'К оплате'.tr(),
               ).animate().fadeIn(),
             )
          ],
        ),
      ),
    );
  }
}