



 import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:virtuozy/components/buttons.dart';
import 'package:virtuozy/presentations/auth_screen/bloc/auth_bloc.dart';
import 'package:virtuozy/presentations/auth_screen/bloc/auth_event.dart';
import 'package:virtuozy/resourses/colors.dart';

import '../../../../router/paths.dart';
import '../../../../utils/text_style.dart';

class SearchLocationCompleteContent extends StatelessWidget{

  const SearchLocationCompleteContent({super.key, required this.branch});

  final String branch;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
      children: [
       Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
            color: colorGrey.withOpacity(0.2),
         borderRadius: BorderRadius.circular(20.0)
        ),
         child: Column(
           children: [
             Container(
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                  color: colorOrange.withOpacity(0.2),
                  shape: BoxShape.circle
              ),
              child: Icon(Icons.location_on_outlined,color: colorOrange),
             ),
             const Gap(10.0),
             Text(branch,style: TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!,
                 size: 28.0)),
           ],
         ),
       ),
       const Gap(20.0),
       OutLineButton(
         onTap: (){
           context.read<AuthBloc>().add(CompleteSinIgEvent(branch: branch));
           GoRouter.of(context).push(pathSuccessSendSMS);
         },
        textButton: 'Завершить регистрацию'.tr(),
       ),
       const Gap(10.0),
       Text('Если филиал определен неверно, попробуйте выбрать вручную'.tr(),
           textAlign: TextAlign.center,
           style: TStyle.textStyleVelaSansRegular(colorGrey,size: 12.0)),
      ],
      ),
    );
  }




}