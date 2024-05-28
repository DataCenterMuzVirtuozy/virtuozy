import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../domain/entities/lesson_entity.dart';
import '../../../../resourses/colors.dart';
import '../../../../utils/status_to_color.dart';
import '../../../../utils/text_style.dart';
import '../../../buttons.dart';

class DetailsClientContent extends StatelessWidget {
  const DetailsClientContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15).copyWith(bottom: 15),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Дата создания: ',
                      style: TStyle.textStyleOpenSansRegular(colorGrey,
                          size: 14.0)),
                  Text('12.05.2024 10:00',
                      style: TStyle.textStyleVelaSansBold(
                          Theme.of(context).textTheme.displayMedium!.color!,
                          size: 12.0))
                ],
              ),
              Row(
                children: [
                  Icon(Icons.phone, color: colorGreen, size: 16.0),
                  const Gap(5),
                  Text('+7 999 999 99 99',
                      style: TStyle.textStyleVelaSansMedium(colorGrey,
                          size: 15.0)),
                ],
              ),
            ],
          ),
          Divider(color: colorGrey),
          const Gap(8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.directions, color: colorGreen, size: 16.0),
                  const Gap(5),
                  Text('Направление:'.tr(),
                      style: TStyle.textStyleVelaSansMedium(colorGrey,
                          size: 15.0)),
                  const Gap(10),
                  Text('Вокал',
                      style: TStyle.textStyleVelaSansBold(
                          Theme.of(context).textTheme.displayMedium!.color!,
                          size: 16.0))
                ],
              ),
              Container(
                  alignment: Alignment.center,
                  padding:
                      const EdgeInsets.only(right: 8.0, left: 8.0, bottom: 2.0),
                  decoration: BoxDecoration(
                      color: colorGreen,
                      borderRadius: BorderRadius.circular(10.0)),
                  //todo status unactiv, planned, unactive
                  child: Text('активный'.tr(),
                      style:
                          TStyle.textStyleVelaSansBold(colorWhite, size: 10.0)))
            ],
          ),
          const Gap(5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.play_lesson_outlined,
                    color: colorGreen,
                    size: 16,
                  ),
                  const Gap(5),
                  Text('Осталось уроков: ',
                      style: TStyle.textStyleVelaSansMedium(colorGrey,
                          size: 15.0)),
                ],
              ),
              Text('1/3',
                  style: TStyle.textStyleVelaSansBold(
                      Theme.of(context).textTheme.displayMedium!.color!,
                      size: 16.0))
            ],
          ),
          const Gap(5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    color: colorGreen,
                    size: 16,
                  ),
                  const Gap(5),
                  Text('ДоА:',
                      style: TStyle.textStyleVelaSansMedium(colorGrey,
                          size: 15.0)),
                ],
              ),
              Text('07.11.23',
                  style: TStyle.textStyleVelaSansBold(
                      Theme.of(context).textTheme.displayMedium!.color!,
                      size: 16.0))
            ],
          ),
          const Gap(8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Дата ближ. урока: ',
                      style: TStyle.textStyleVelaSansBold(
                          Theme.of(context).textTheme.displayMedium!.color!,
                          size: 14.0)),
                  Text('12.05.2024 10:00',
                      style: TStyle.textStyleVelaSansMedium(colorGrey!,
                          size: 12.0))
                ],
              ),
              const Gap(20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                    color: StatusToColor.getColor(
                        lessonStatus: LessonStatus.singly),
                    borderRadius: BorderRadius.circular(5)),
                child: Text(StatusToColor.getNameStatus(LessonStatus.singly),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TStyle.textStyleVelaSansBold(
                        Theme.of(context).textTheme.displayMedium!.color!,
                        size: 10.0)),
              )
            ],
          ),
          const Gap(20.0),
          SizedBox(
            height: 40.0,
            child: SubmitButton(
              onTap: () {},
              borderRadius: 10.0,
              textButton: 'Перейти в карту клиента'.tr(),
            ),
          )
        ],
      ),
    );
  }
}
