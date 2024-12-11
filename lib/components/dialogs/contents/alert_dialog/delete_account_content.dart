


import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../domain/entities/user_entity.dart';
import '../../../../presentations/auth_screen/bloc/auth_bloc.dart';
import '../../../../presentations/auth_screen/bloc/auth_event.dart';
import '../../../../resourses/colors.dart';
import '../../../../utils/text_style.dart';

class DeleteAccountContent extends StatelessWidget{
  const DeleteAccountContent({super.key, required this.user});

  final UserEntity user;

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.delete_outline,color: Theme.of(context).textTheme.displayMedium!.color!,size: 40.0),
          const SizedBox(height: 15.0),
          Text('Удалить аккаунт?'.tr(),
              textAlign:TextAlign.center,
              style:TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!,size: 18.0)),
          const SizedBox(height: 5.0),
          Text('Ваши данные будут удалены'.tr(),
              textAlign:TextAlign.center,
              style:TStyle.textStyleVelaSansRegular(Theme.of(context).textTheme.displayMedium!.color!,size: 16.0)),
          const SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Отмена'.tr(),
                      textAlign: TextAlign.center,
                      style: TStyle.textStyleVelaSansBold(
                          Theme.of(context).textTheme.displayMedium!.color!,
                          size: 16.0))),
              const Gap(5.0),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(DeleteAccountEvent(user: user));
                  Navigator.pop(context);
                },
                child: Text('Удалить'.tr(),
                    textAlign: TextAlign.center,
                    style:
                    TStyle.textStyleVelaSansBold(colorRed,size: 16.0)),)
            ],
          )
        ],
      ),
    );
  }



}