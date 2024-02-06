


 import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:virtuozy/components/app_bar.dart';
import 'package:virtuozy/components/buttons.dart';
import 'package:virtuozy/resourses/colors.dart';
import 'package:virtuozy/resourses/images.dart';

import '../../components/dialoger.dart';
import '../../utils/text_style.dart';

 final scaffoldState = GlobalKey<ScaffoldState>();

class BranchSearchPage extends StatefulWidget{
  const BranchSearchPage({super.key});

  @override
  State<BranchSearchPage> createState() => _BranchSearchPageState();
}

class _BranchSearchPageState extends State<BranchSearchPage> {


  bool _animateLocation = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldState,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset(animationLocation,animate: true),
            const Gap(30.0),
            Text('Для определения филиала в автоматическом режиме, включите определение геолокации на своем устройстве'.tr(),
            textAlign: TextAlign.center,
            style: TStyle.textStyleVelaSansBold(colorBlack,size: 18.0)),
            const Gap(30.0),
             OutLineButton(
              textButton: 'Поиск'.tr(),
               onTap: (){
                  setState(() {
                    _animateLocation = true;
                  });
               },

            ),

            const Gap(10.0),
            TextButton(onPressed: () {
              Dialoger.showModalBottomMenu(
                height: 200.0,
                  title:'Выбери свой филиал'.tr(),
                  context: context, content: SelectBranch());
            }, child: Column(
              children: [
                Text('Выбрать вручную'.tr(),style: TStyle.textStyleVelaSansRegularUnderline(colorOrange,size: 14.0)),
              ],
            ),)
            // SubmitButton(
            //   onTap: (){
            //     GoRouter.of(context).push(pathSuccessSendSMS);
            //   },
            //   textButton: 'Запросить код по СМС'.tr(),
            // ),
          ],
        ),
      ),
    );
  }
}