
  import 'package:flutter/cupertino.dart';
import 'package:gap/gap.dart';
import 'package:virtuozy/resourses/colors.dart';

import '../utils/text_style.dart';

class BoxInfo extends StatelessWidget{
  const BoxInfo({super.key,
    required this.title,
    this.description = '',
    required this.iconData});

  final String title;
  final String description;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(iconData,color: colorGrey.withOpacity(0.6),size: 30.0),
          const Gap(10.0),
          Text(title,style: TStyle.textStyleVelaSansRegular(colorGrey.withOpacity(0.6),size: 16.0)),
          Visibility(
            visible: description.isNotEmpty,
              child: Text(description,
                  style: TStyle.textStyleVelaSansBold(colorGrey.withOpacity(0.6),size: 14.0)))

        ],
      ),
    );
  }

}