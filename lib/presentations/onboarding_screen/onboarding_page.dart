

 import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:onboarding/onboarding.dart';
import '../../resourses/colors.dart';
import '../../resourses/images.dart';
import '../../utils/text_style.dart';

class OnBoardingPage extends StatefulWidget{
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {


  late Material materialButton;
  late int index;

  @override
  void initState() {
    super.initState();
    materialButton = _skipButton();
    index = 0;
  }

  Material _skipButton({void Function(int)? setIndex}) {
    return Material(
      borderRadius: defaultSkipButtonBorderRadius,
      color: colorPink,
      child: InkWell(
        borderRadius: defaultSkipButtonBorderRadius,
        onTap: () {
          if (setIndex != null) {
            index++;
            setIndex(index);
          }
        },
        child:  Padding(
          padding: defaultSkipButtonPadding,
          child: Text(
            'Далее'.tr(),
            style: TStyle.textStyleVelaSansBold(colorBlack),
          ),
        ),
      ),
    );
  }

  Material get _signupButton {
    return Material(
      borderRadius: defaultProceedButtonBorderRadius,
      color: colorBlack,
      child: InkWell(
        borderRadius: defaultProceedButtonBorderRadius,
        onTap: () {

        },
        child:  Padding(
          padding: defaultProceedButtonPadding,
          child: Text(
            'Добро пожаловать'.tr(),
            style: TStyle.textStyleVelaSansBold(colorWhite),
          ),
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;

   return Scaffold(
     backgroundColor: colorWhite,
     body: Onboarding(
       startPageIndex: 0,
       onPageChange: (int pageIndex) {
         index = pageIndex;
       },
       footerBuilder: (context, dragDistance, pagesLength, setIndex) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: colorWhite,
            border: Border.all(
              width: 0.0,
              color: colorWhite,
            ),
          ),
          child: ColoredBox(
            color: colorWhite,
            child: Padding(
              padding: const EdgeInsets.all(45.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomIndicator(
                    netDragPercent: dragDistance,
                    pagesLength: pagesLength,
                    indicator: Indicator(
                      activeIndicator:  ActiveIndicator(color: colorBlack, borderWidth: 2.5),
                      indicatorDesign: IndicatorDesign.line(
                        lineDesign: LineDesign(
                          lineWidth: 15.0,
                          lineSpacer: 30.0,
                          lineType: DesignType.line_nonuniform,
                        ),
                      ),
                    ),
                  ),
                  index == pagesLength - 1
                  ? _signupButton
                      : _skipButton(setIndex: setIndex)
                ],
              ),
            ),
          ),
        );
      },
       pages: [
         // Page 1
         PageModel(
             widget: Column(
               children: [
                 Container(
                     decoration: BoxDecoration(
                         color: colorPink
                     ),
                     height: h/1.5,
                     padding: const EdgeInsets.symmetric(horizontal: 20.0),
                     child: Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Image.asset(illustration_1),
                         const Gap(20.0),
                         RichText(text: TextSpan(children:[
                           TextSpan(text: 'УЧИМ '.tr(),style: TStyle.textStyleGaretHeavy(colorBlack,size: 26.0)),
                           TextSpan(text: 'ВОКАЛУ '.tr(),style: TStyle.textStyleGaretHeavy(colorRed,size: 26.0)),
                           TextSpan(text: 'И '.tr(),style: TStyle.textStyleGaretHeavy(colorBlack,size: 26.0)),
                           TextSpan(text: 'ИГРЕ '.tr(),style: TStyle.textStyleGaretHeavy(colorRed,size: 26.0)),
                           TextSpan(text: 'НА МУЗЫКАЛЬНЫХ ИНСТРУМЕНТАХ'.tr(),style: TStyle.textStyleGaretHeavy(Colors.black,size: 26.0)),
                         ]))
                       ],
                     )
                 ),
                 const Gap(20.0),
                 Container(
                   margin: const EdgeInsets.symmetric(horizontal: 20.0),
                   child: RichText(text: TextSpan(
                       children: [
                         TextSpan(text: 'Виртуозы '.tr(),
                             style: TStyle.textStyleVelaSansBold(colorRed,size: 16.0)),
                         TextSpan(text: '- музыкальная семья, где взрослые и дети реализуют творческую мечту, выступают на сцене, '.tr(),
                             style: TStyle.textStyleVelaSansBold(colorBlack,size: 16.0)),
                         TextSpan(text: 'гастролируют.'.tr(),
                             style: TStyle.textStyleVelaSansBold(colorRed,size: 16.0)),

                       ]
                   ),),
                 )
               ],
             ).animate().fadeIn(duration: const Duration(milliseconds: 700))
         ),
         // Page 2
         PageModel(
             widget: Column(
               children: [
                 Container(
                     decoration: BoxDecoration(
                         color: colorPink
                     ),
                     height: h/1.5,
                     padding: const EdgeInsets.symmetric(horizontal: 20.0),
                     child: Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Image.asset(illustration_2),
                         const Gap(20.0),
                         RichText(text: TextSpan(children:[
                           TextSpan(text: 'Музыка - увлечение для любого возраста и призвания'.tr(),style: TStyle.textStyleGaretHeavy(colorBlack,size: 26.0)),
                         ]))
                       ],
                     )
                 ),
                 const Gap(20.0),
                 Container(
                   margin: const EdgeInsets.symmetric(horizontal: 20.0),
                   child: RichText(text: TextSpan(
                       children: [
                         TextSpan(text: 'Подберем подходящий абонемент, график занятий и педагога, чтобы легко раскрыть талант'.tr(),
                             style: TStyle.textStyleVelaSansBold(colorBlack,size: 16.0)),
                       ]
                   ),),
                 )
               ],
             )
         ),
         // Page 3
         PageModel(
             widget: Column(
               children: [
                 Container(
                     decoration: BoxDecoration(
                         color: colorPink
                     ),
                     height: h/1.5,
                     padding: const EdgeInsets.symmetric(horizontal: 20.0),
                     child: Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Image.asset(illustration_3),
                         const Gap(20.0),
                         RichText(text: TextSpan(children:[
                           TextSpan(text: '80% занятий проходят индивидуально'.tr(),style: TStyle.textStyleGaretHeavy(colorBlack,size: 26.0)),
                         ]))
                       ],
                     )
                 ),
                 const Gap(20.0),
                 Container(
                   margin: const EdgeInsets.symmetric(horizontal: 20.0),
                   child: RichText(text: TextSpan(
                       children: [
                         TextSpan(text: '20% групповые занятия, концерты, практика публичных выступлений и участие в музыкальных коллективах.'.tr(),
                             style: TStyle.textStyleVelaSansBold(colorBlack,size: 16.0)),

                       ]
                   ),),
                 )
               ],
             )),
         PageModel(
             widget: Column(
               children: [
                 Container(
                     decoration: BoxDecoration(
                         color: colorPink
                     ),
                     height: h/1.5,
                     padding: const EdgeInsets.symmetric(horizontal: 20.0),
                     child: Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Image.asset(illustration_4),
                         const Gap(20.0),
                         RichText(text: TextSpan(children:[
                           TextSpan(text: 'Увлекательные и разнообразные уроки. '.tr(),style: TStyle.textStyleGaretHeavy(colorBlack,size: 26.0)),
                           TextSpan(text: 'Много практики и живые выступления.'.tr(),style: TStyle.textStyleGaretHeavy(colorBlack,size: 26.0)),
                         ]))
                       ],
                     )
                 ),
                 const Gap(20.0),
                 Container(
                   margin: const EdgeInsets.symmetric(horizontal: 20.0),
                   child: RichText(text: TextSpan(
                       children: [
                         TextSpan(text: 'Репертуар подбирается индивидуально от классики до современной музыки. Даём ученикам возможность выступать на концертах, фестивалях и гастролировать.'.tr(),
                             style: TStyle.textStyleVelaSansBold(colorBlack,size: 16.0)),

                       ]
                   ),),
                 )
               ],
             ))



       ])
   );
  }



}