


 import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:virtuozy/router/paths.dart';
import 'package:virtuozy/utils/contact_school_by_location.dart';

import '../../resourses/colors.dart';
import '../../resourses/images.dart';
import '../../utils/text_style.dart';

class SuccessSendSMS extends StatelessWidget{
  const SuccessSendSMS({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0,right: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                SvgPicture.asset(logo),
                const Gap(40.0),
                Image.asset(illustration_5),
                const Gap(40.0),
                Text('Поздравляем с регистрацией в личном кабинете!'.tr(),
                    textAlign: TextAlign.center,
                    style: TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!,
                        size: 20.0)),
                Text('Ожидайте СМС с паролем'.tr(),
                    textAlign: TextAlign.center,
                    style: TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!,
                        size: 20.0)),
              ],
            ),
            const Gap(20.0),
            Column(
              children: [
                Container(
                 padding: const EdgeInsets.all(20.0),
                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(20.0),
                   color: colorOrange
                 ),
                 child: Countdown(
                   onFinished: (){
                     GoRouter.of(context).pushReplacement(pathLogIn);
                   },
                   seconds: 10,
                   build: (c,i){
                     return Column(
                       children: [
                         Text('Сообщение исчезает через ${i.toInt()} секунд.'.tr(),
                             textAlign: TextAlign.center,
                             style: TStyle.textStyleVelaSansRegular(colorWhite)),
                         Text('Вас направит на страницу Вход',
                             textAlign: TextAlign.center,
                             style: TStyle.textStyleVelaSansRegular(colorWhite))
                       ],
                     );
                   },
                 ),
               ),
                const Gap(40.0),
                InkWell(
                  onTap: () async {
                    await _launchUrl();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.transit_enterexit,color: colorGrey),
                      const Gap(5.0),
                      Text(ContactSchoolByLocation.getUrlWebsite(),
                        style: TStyle.textStyleVelaSansRegularUnderline(colorGrey,size: 18.0),),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );

  }

  Future<void> _launchUrl() async {
    final Uri url = Uri.parse('https://virtuozy-msk.ru');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }




}