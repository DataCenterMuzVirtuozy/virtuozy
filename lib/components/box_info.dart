
  import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:virtuozy/components/buttons.dart';
import 'package:virtuozy/resourses/colors.dart';
import 'package:virtuozy/router/paths.dart';

import '../utils/text_style.dart';

class BoxInfo extends StatelessWidget{
  const BoxInfo({super.key,
    required this.title,
    this.description = '',
    required this.iconData,
    this.buttonVisible = false
  });

  final String title;
  final String description;
  final IconData iconData;
  final bool buttonVisible;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(iconData,color: colorGrey.withOpacity(0.6),size: 30.0),
            const Gap(10.0),
            Text(title,
                textAlign: TextAlign.center,
                style: TStyle.textStyleVelaSansBold(colorGrey.withOpacity(0.6),size: 16.0)),
            Visibility(
              visible: description.isNotEmpty,
                child: Text(description,
                    textAlign: TextAlign.center,
                    style: TStyle.textStyleVelaSansRegular(colorGrey.withOpacity(0.6),size: 14.0))),
            const Gap(20.0),
            Visibility(
              visible: buttonVisible,
                child:  OutLineButton(
                  onTap: (){
                    GoRouter.of(context).push(pathLogIn);
                  },
                  width: 100.0,
                  textButton: 'Войти'.tr(),
                ))

          ],
        ),
      ),
    );
  }

}