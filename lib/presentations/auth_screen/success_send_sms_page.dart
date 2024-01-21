


 import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../components/buttons.dart';
import '../../components/text_fields.dart';
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
                    style: TStyle.textStyleVelaSansBold(colorBlack,size: 20.0)),
                Text('Ожидайте СМС с паролем от сотрудника школы.'.tr(),
                    textAlign: TextAlign.center,
                    style: TStyle.textStyleVelaSansBold(colorBlack,size: 20.0)),
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
                 child: Text('Сообщение исчезает через 30 секунд. Пользователя переводит на страницу Вход'.tr(),
                 textAlign: TextAlign.center,
                 style: TStyle.textStyleVelaSansRegular(colorWhite)),
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
                      Text('virtuozy-msk.ru',
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