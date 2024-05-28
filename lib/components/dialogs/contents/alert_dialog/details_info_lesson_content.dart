

  import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';

import '../../../../resourses/colors.dart';
import '../../../../utils/text_style.dart';

class InfoDetailsLessonContent extends StatelessWidget{
  const InfoDetailsLessonContent({super.key});

  @override
  Widget build(BuildContext context) {
   return  Padding(
      padding: const EdgeInsets.only(top: 10),
      child: SizedBox(
        height: MediaQuery.of(context).size.height - 200,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text('Данилина Дарья Денисовна',
                        textAlign:TextAlign.start,
                        style:TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!,size: 16.0)),
                  ),
                  const Gap(20),
                  InkWell(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.close,color: colorGrey,),
                  )

                ],
              ),
              const Gap(10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Обновил(а) Урок №96266',
                      textAlign:TextAlign.center,
                      style:TStyle.textStyleVelaSansMedium(colorGreen,size: 10.0)),
                  const Gap(10),
                  Expanded(
                    child: Text(' 27.05.2024  17:02',
                        textAlign: TextAlign.end,
                        style:TStyle.textStyleVelaSansBold(textColorBlack(context),size: 12.0)),
                  ),
                ],
              ),
              const Gap(8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('IP-адрес:',
                      textAlign:TextAlign.center,
                      style:TStyle.textStyleVelaSansMedium(colorGreen,size: 10.0)),
                  const Gap(10),
                  Expanded(
                    child: Text('91.107.205.75',
                        textAlign: TextAlign.end,
                        style:TStyle.textStyleVelaSansBold(textColorBlack(context),size: 12.0)),
                  ),
                ],
              ),
              const Gap(8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Email:',
                      textAlign:TextAlign.center,
                      style:TStyle.textStyleVelaSansMedium(colorGreen,size: 10.0)),
                  const Gap(10),
                  Expanded(
                    child: Text('dd_danilina@mail.ru',
                        textAlign: TextAlign.end,
                        style:TStyle.textStyleVelaSansBold(textColorBlack(context),size: 12.0)),
                  ),
                ],
              ),
              const Gap(8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text("Время (date) (Индивидуальное : 2024-05-28 15:00:00)",
                        textAlign:TextAlign.start,
                        style:TStyle.textStyleVelaSansMedium(colorGreen,size: 10.0)),
                  ),
                  const Gap(10),
                  Expanded(
                    child: Text('13:00:00 → 15:00:00',
                        textAlign: TextAlign.end,
                        style:TStyle.textStyleVelaSansBold(textColorBlack(context),size: 12.0)),
                  ),
                ],
              ),
              const Gap(8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text("Инициатор (initiator_id) (Индивидуальное : 2024-05-28 15:00:00)",
                        textAlign:TextAlign.start,
                        style:TStyle.textStyleVelaSansMedium(colorGreen,size: 10.0)),
                  ),
                  const Gap(10),
                  Expanded(
                    child: Text('(пусто) → Ученик',
                        textAlign: TextAlign.end,
                        style:TStyle.textStyleVelaSansBold(textColorBlack(context),size: 12.0)),
                  ),
                ],
              ),
              const Gap(8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text("Коментарий (comment) (Индивидуальное : 2024-05-28 15:00:00)",
                        textAlign:TextAlign.start,
                        style:TStyle.textStyleVelaSansMedium(colorGreen,size: 10.0)),
                  ),
                  const Gap(10),
                  Expanded(
                    child: Text('(пусто) → Попросила попозже',
                        textAlign: TextAlign.end,
                        style:TStyle.textStyleVelaSansBold(textColorBlack(context),size: 12.0)),
                  ),
                ],
              ),
              Divider(color: colorGrey),
              Text('АШ МШ2 - А1 Мск',
                  textAlign:TextAlign.center,
                  style:TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!,size: 16.0)),
              const Gap(10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Добавил(а) Урок №96266',
                      textAlign:TextAlign.center,
                      style:TStyle.textStyleVelaSansMedium(colorGreen,size: 10.0)),
                  const Gap(10),
                  Expanded(
                    child: Text(' 27.05.2024  17:02',
                        textAlign: TextAlign.end,
                        style:TStyle.textStyleVelaSansBold(textColorBlack(context),size: 12.0)),
                  ),
                ],
              ),
              const Gap(8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('IP-адрес:',
                      textAlign:TextAlign.center,
                      style:TStyle.textStyleVelaSansMedium(colorGreen,size: 10.0)),
                  const Gap(10),
                  Expanded(
                    child: Text('91.107.205.75',
                        textAlign: TextAlign.end,
                        style:TStyle.textStyleVelaSansBold(textColorBlack(context),size: 12.0)),
                  ),
                ],
              ),
              const Gap(8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Email:',
                      textAlign:TextAlign.center,
                      style:TStyle.textStyleVelaSansMedium(colorGreen,size: 10.0)),
                  const Gap(10),
                  Expanded(
                    child: Text('msk.ms2.a1.muz@gmail.com',
                        textAlign: TextAlign.end,
                        style:TStyle.textStyleVelaSansBold(textColorBlack(context),size: 12.0)),
                  ),
                ],
              ),
              const Gap(8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text("Тип занятия (lesson_type_id)",
                        textAlign:TextAlign.start,
                        style:TStyle.textStyleVelaSansMedium(colorGreen,size: 10.0)),
                  ),
                  const Gap(10),
                  Expanded(
                    child: Text('(пусто) → Индивидуальное',
                        textAlign: TextAlign.end,
                        style:TStyle.textStyleVelaSansBold(textColorBlack(context),size: 12.0)),
                  ),
                ],
              ),
              const Gap(8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text("Дата (date)",
                        textAlign:TextAlign.start,
                        style:TStyle.textStyleVelaSansMedium(colorGreen,size: 10.0)),
                  ),
                  const Gap(10),
                  Expanded(
                    child: Text('(пусто) → 2024-05-28',
                        textAlign: TextAlign.end,
                        style:TStyle.textStyleVelaSansBold(textColorBlack(context),size: 12.0)),
                  ),
                ],
              ),
              const Gap(8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text("Время (date)",
                        textAlign:TextAlign.start,
                        style:TStyle.textStyleVelaSansMedium(colorGreen,size: 10.0)),
                  ),
                  const Gap(10),
                  Expanded(
                    child: Text('(пусто) → 13:00:00',
                        textAlign: TextAlign.end,
                        style:TStyle.textStyleVelaSansBold(textColorBlack(context),size: 12.0)),
                  ),
                ],
              ),
              const Gap(8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text("Локация (branch_id)",
                        textAlign:TextAlign.start,
                        style:TStyle.textStyleVelaSansMedium(colorGreen,size: 10.0)),
                  ),
                  const Gap(10),
                  Expanded(
                    child: Text('(пусто) → МШ2',
                        textAlign: TextAlign.end,
                        style:TStyle.textStyleVelaSansBold(textColorBlack(context),size: 12.0)),
                  ),
                ],
              ),
              const Gap(8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text("Аудитория (name)",
                        textAlign:TextAlign.start,
                        style:TStyle.textStyleVelaSansMedium(colorGreen,size: 10.0)),
                  ),
                  const Gap(10),
                  Expanded(
                    child: Text('(пусто) → 3 - Шансонье',
                        textAlign: TextAlign.end,
                        style:TStyle.textStyleVelaSansBold(textColorBlack(context),size: 12.0)),
                  ),
                ],
              ),
              const Gap(8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text("Направление (direction)",
                        textAlign:TextAlign.start,
                        style:TStyle.textStyleVelaSansMedium(colorGreen,size: 10.0)),
                  ),
                  const Gap(10),
                  Expanded(
                    child: Text('пусто) → Вокал',
                        textAlign: TextAlign.end,
                        style:TStyle.textStyleVelaSansBold(textColorBlack(context),size: 12.0)),
                  ),
                ],
              ),
              const Gap(8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text("Преподаватель (name)",
                        textAlign:TextAlign.start,
                        style:TStyle.textStyleVelaSansMedium(colorGreen,size: 10.0)),
                  ),
                  const Gap(10),
                  Expanded(
                    child: Text('(пусто) → Данилина Дарья Денисовна',
                        textAlign: TextAlign.end,
                        style:TStyle.textStyleVelaSansBold(textColorBlack(context),size: 12.0)),
                  ),
                ],
              ),
              const Gap(8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text("Ученик (name)",
                        textAlign:TextAlign.start,
                        style:TStyle.textStyleVelaSansMedium(colorGreen,size: 10.0)),
                  ),
                  const Gap(10),
                  Expanded(
                    child: Text('(пусто) → Кисенкова София Александровна',
                        textAlign: TextAlign.end,
                        style:TStyle.textStyleVelaSansBold(textColorBlack(context),size: 12.0)),
                  ),
                ],
              ),
              const Gap(8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text("Статус (status_id)",
                        textAlign:TextAlign.start,
                        style:TStyle.textStyleVelaSansMedium(colorGreen,size: 10.0)),
                  ),
                  const Gap(10),
                  Expanded(
                    child: Text('(пусто) → Запланирован',
                        textAlign: TextAlign.end,
                        style:TStyle.textStyleVelaSansBold(textColorBlack(context),size: 12.0)),
                  ),
                ],
              ),
              const Gap(8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text("Тип урока (lesson_online)",
                        textAlign:TextAlign.start,
                        style:TStyle.textStyleVelaSansMedium(colorGreen,size: 10.0)),
                  ),
                  const Gap(10),
                  Expanded(
                    child: Text('(пусто) → Оффлайн',
                        textAlign: TextAlign.end,
                        style:TStyle.textStyleVelaSansBold(textColorBlack(context),size: 12.0)),
                  ),
                ],
              ),
              const Gap(8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text("Длительность (duration)",
                        textAlign:TextAlign.start,
                        style:TStyle.textStyleVelaSansMedium(colorGreen,size: 10.0)),
                  ),
                  const Gap(10),
                  Expanded(
                    child: Text('(пусто) → 60',
                        textAlign: TextAlign.end,
                        style:TStyle.textStyleVelaSansBold(textColorBlack(context),size: 12.0)),
                  ),
                ],
              ),

              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Закрыть'.tr(),
                        textAlign: TextAlign.end,
                        style:
                        TStyle.textStyleVelaSansBold(colorRed,size: 16.0)),)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }





}