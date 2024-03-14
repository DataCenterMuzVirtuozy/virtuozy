


 import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';

import '../../../components/app_bar.dart';
import '../../../components/buttons.dart';
import '../../../components/dialogs/dialoger.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../resourses/colors.dart';
import '../../../resourses/images.dart';
import '../../../utils/text_style.dart';
import 'bloc/sub_bloc.dart';
import 'bloc/sub_state.dart';



class DetailsBonusPage extends StatelessWidget{
   DetailsBonusPage({super.key, required this.bonusEntity, required this.directionLesson});


  final BonusEntity bonusEntity;
  final DirectionLesson directionLesson;
  String _textResultBonus = 'Бонус успешно активирован!'.tr();

  @override
  Widget build(BuildContext context) {
   return Scaffold(
    appBar: AppBarCustom(title: bonusEntity.title),
    body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 20.0),
      child: BlocConsumer<SubBloc,SubState>(
       listener: (c,s){

       },
        builder: (context,state) {

        if(state.bonusStatus == BonusStatus.loading){
         return const Center(child: CircularProgressIndicator());
        }

        if(state.bonusStatus == BonusStatus.activate){
         return Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           Lottie.asset(successAnim,repeat: false,width: 150.0,height: 150.0),
           Text(_textResultBonus,
            style: TStyle.textStyleVelaSansBold(colorGreenLight,size: 18.0),).animate().fadeIn(
               duration: const Duration(milliseconds: 700)
           )
          ],
         ));
        }


          return Column(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
            Text(bonusEntity.description,
                style: TStyle.textStyleVelaSansRegular(Theme.of(context).textTheme.displayMedium!.color!,size: 18.0)),
            const Gap(40.0),
            Column(
              children: [
               SizedBox(
                height: 40.0,
                child: OutLineButton(
                 onTap: (){
                   Dialoger.showMessage('В разработке');
                  // _textResultBonus = 'Бонус удален!'.tr();
                  // context.read<SubBloc>().add(ActivateBonusEvent(
                  //     direction: directionLesson,
                  //     idBonus: bonusEntity.id,
                  //     activate: false));
                 },
                 borderRadius: 10.0,
                 textButton: 'Удалить бонус'.tr(),
                ),
               ),
                const Gap(10.0),
                SizedBox(
                 height: 40.0,
                  child: SubmitButton(
                   onTap: (){
                     Dialoger.showMessage('В разработке');
                    // context.read<SubBloc>().add(ActivateBonusEvent(
                    //     direction: directionLesson,
                    //     idBonus: bonusEntity.id,
                    //     activate: true));
                   },
                   borderRadius: 10.0,
                   textButton: 'Активировать бонус'.tr(),
                  ),
                ),
              ],
            )
           ],
          );
        }
      ),
    ),
   );
  }




}