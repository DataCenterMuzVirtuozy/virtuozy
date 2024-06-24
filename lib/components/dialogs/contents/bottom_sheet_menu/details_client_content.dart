import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:virtuozy/utils/date_time_parser.dart';

import '../../../../domain/entities/client_entity.dart';
import '../../../../domain/entities/lesson_entity.dart';
import '../../../../resourses/colors.dart';
import '../../../../utils/status_to_color.dart';
import '../../../../utils/text_style.dart';
import '../../../buttons.dart';

class DetailsClientContent extends StatelessWidget {
  const DetailsClientContent({super.key, required this.client});


  final ClientEntity client;

  @override
  Widget build(BuildContext context) {

    print('Status ${client.status}');
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
                  Text(DateTimeParser.getDateFromApi(date: client.dateCreate),
                      style: TStyle.textStyleVelaSansBold(
                          Theme.of(context).textTheme.displayMedium!.color!,
                          size: 12.0))
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Icon(Icons.phone, color: colorGreen, size: 14.0),
                      const Gap(5),
                      Text(client.phoneNum,
                          style: TStyle.textStyleVelaSansMedium(colorGrey,
                              size: 13.0)),
                    ],
                  ),
                  const Gap(5),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: colorGreyLight
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 4,vertical: 2),
                    child: Row(
                      children: [
                        Icon(Icons.location_on_outlined,size: 9,color:
                        Theme.of(context).textTheme.displayMedium!.color!),
                        const Gap(2),
                        Text(client.idSchool,
                            style:TStyle.textStyleVelaSansMedium(Theme.of(context).textTheme.displayMedium!.color!,
                                size: 8.0)),
                      ],
                    ),
                  )

                ],
              ),
            ],
          ),
          Divider(color: colorGrey),
          Visibility(
            visible: client.status==ClientStatus.archive||
            client.status == ClientStatus.replacement||client.status == ClientStatus.action,
            child: Column(
              children: [
                const Gap(8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.subscriptions, color: colorGreen, size: 16.0),
                        const Gap(5),
                        Text('Абонемент:'.tr(),
                            style: TStyle.textStyleVelaSansMedium(colorGrey,
                                size: 15.0)),
                        const Gap(10),
                        Text(client.nameSub,
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
                            color: client.actionSub?colorGreen:colorRed,
                            borderRadius: BorderRadius.circular(10.0)),
                        //todo status unactiv, planned, unactive
                        child: Text(client.actionSub?'активный'.tr():'неактивный'.tr(),
                            style:
                            TStyle.textStyleVelaSansBold(colorWhite, size: 10.0)))
                  ],
                ),
              ],
            ),
          ),
          const Gap(5),
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
                  Text(client.nameDir,
                      style: TStyle.textStyleVelaSansBold(
                          Theme.of(context).textTheme.displayMedium!.color!,
                          size: 16.0))
                ],
              ),
            ],
          ),
          const Gap(5),
          Visibility(
            visible: client.status==ClientStatus.archive||
                client.status == ClientStatus.replacement||client.status == ClientStatus.action,
            child: Row(
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
                Text('${client.countBalanceLesson} из ${client.countAllLesson}',
                    style: TStyle.textStyleVelaSansBold(
                        Theme.of(context).textTheme.displayMedium!.color!,
                        size: 16.0))
              ],
            ),
          ),
          const Gap(5),
          Visibility(
            visible: client.status==ClientStatus.archive||
                client.status == ClientStatus.replacement||client.status == ClientStatus.action,
            child: Column(
              children: [
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
                    Text(DateTimeParser.getDateFromApi(date: client.dOa),
                        style: TStyle.textStyleVelaSansBold(
                            Theme.of(context).textTheme.displayMedium!.color!,
                            size: 16.0))
                  ],
                ),
                const Gap(8),
              ],
            ),
          ),

          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(client.status != ClientStatus.archive
                      ?'Дата ближ. урока: '.tr():
                  'Дата посл. урока: '.tr(),
                      style: TStyle.textStyleVelaSansBold(
                          Theme.of(context).textTheme.displayMedium!.color!,
                          size: 14.0)),
                  Text(client.status != ClientStatus.archive?DateTimeParser.getDateFromApi(date: client.dateNearLesson):
                      DateTimeParser.getDateFromApi(date: client.dateLestLesson),
                      style: TStyle.textStyleVelaSansMedium(colorGrey,
                          size: 12.0))
                ],
              ),
              const Gap(20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                    color: StatusToColor.getColor(
                        lessonStatus: client.status != ClientStatus.archive?
                    client.statusNearLesson:client.statusLastLesson),
                    border: Border.all(
                        color: client.statusNearLesson.isComplete||client.statusNearLesson.isPlanned||
                        client.statusLastLesson.isComplete||client.statusLastLesson.isPlanned
                            ? textColorBlack(context)
                            : Colors.transparent),
                    borderRadius: BorderRadius.circular(5)),
                child: Text(StatusToColor.getNameStatus(client.status != ClientStatus.archive?
                client.statusNearLesson:client.statusLastLesson),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TStyle.textStyleVelaSansBold(
                        Theme.of(context).textTheme.displayMedium!.color!,
                        size: 10.0)),
              )
            ],
          ),
          Visibility(
            visible: client.status==ClientStatus.archive||
                client.status == ClientStatus.replacement||client.status == ClientStatus.action,
            child: Column(
              children: [
                const Gap(5),
                Divider(color: colorGrey),
                const Gap(8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Проведено:',
                        style: TStyle.textStyleVelaSansMedium(colorGrey,
                            size: 15.0)),
                    Container(
                      alignment: Alignment.center,
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        //color: StatusToColor.getColor(lessonStatus: LessonStatus.complete),
                        border: Border.all(color: textColorBlack(context),width: 1.5),
                        borderRadius: BorderRadius.circular(5)
                      ),
                      child: Text(client.cancelL.toString(),
                          style: TStyle.textStyleVelaSansMedium(
                              Theme.of(context).textTheme.displayMedium!.color!,
                              size: 12.0)),
                    )
                  ],
                ),
                const Gap(5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Пропущено:',
                        style: TStyle.textStyleVelaSansMedium(colorGrey,
                            size: 15.0)),
                    Container(
                      alignment: Alignment.center,
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                          //color: StatusToColor.getColor(lessonStatus: LessonStatus.out),
                          border: Border.all(color: textColorBlack(context),width: 1.5),
                          borderRadius: BorderRadius.circular(5)
                      ),
                      child: Text(client.outL.toString(),
                          style: TStyle.textStyleVelaSansMedium(
                              Theme.of(context).textTheme.displayMedium!.color!,
                              size: 12.0)),
                    )
                  ],
                ),
                const Gap(5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Запланировано:',
                        style: TStyle.textStyleVelaSansMedium(colorGrey,
                            size: 15.0)),
                    Container(
                      alignment: Alignment.center,
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                         // color: StatusToColor.getColor(lessonStatus: LessonStatus.planned),
                          border: Border.all(color: textColorBlack(context),width: 1.5),
                          borderRadius: BorderRadius.circular(5)
                      ),
                      child: Text(client.plannedL.toString(),
                          style: TStyle.textStyleVelaSansMedium(
                              Theme.of(context).textTheme.displayMedium!.color!,
                              size: 12.0)),
                    )
                  ],
                ),
              ],
            ),
          ),
          const Gap(50.0),
          // SizedBox(
          //   height: 40.0,
          //   child: SubmitButton(
          //     onTap: () {},
          //     borderRadius: 10.0,
          //     textButton: 'Перейти в карту клиента'.tr(),
          //   ),
          // )
        ],
      ),
    );
  }
}
