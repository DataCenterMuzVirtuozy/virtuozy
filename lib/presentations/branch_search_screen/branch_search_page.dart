


 import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:virtuozy/components/app_bar.dart';
import 'package:virtuozy/components/buttons.dart';
import 'package:virtuozy/presentations/auth_screen/bloc/auth_bloc.dart';
import 'package:virtuozy/presentations/auth_screen/bloc/auth_event.dart';
import 'package:virtuozy/presentations/auth_screen/bloc/auth_state.dart';
import 'package:virtuozy/resourses/colors.dart';
import 'package:virtuozy/resourses/images.dart';

import '../../components/dialogs/dialoger.dart';
import '../../utils/text_style.dart';

 final scaffoldState = GlobalKey<ScaffoldState>();

class BranchSearchPage extends StatefulWidget{
  const BranchSearchPage({super.key});

  @override
  State<BranchSearchPage> createState() => _BranchSearchPageState();
}

class _BranchSearchPageState extends State<BranchSearchPage> with TickerProviderStateMixin{

  late final AnimationController _controller;



  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldState,
      body: BlocConsumer<AuthBloc,AuthState>(
        listener: (c,s){
           if(s.authStatus == AuthStatus.searchLocationComplete){
          Dialoger.showModalBottomMenu(
            height: 320.0,
              title: 'Ваш филиал'.tr(),
              context: context,
              args: 'Москва',
              content: SearchLocationComplete());
        }
        },
        builder: (context,state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                    children: [
                      Lottie.asset(animationLocation,
                        repeat: true,
                        controller: _controller,
                        onLoaded: (composition) {
                          // Configure the AnimationController with the duration of the
                          // Lottie file and start the animation.
                          _controller.duration = composition.duration;

                        },),
                      const Gap(30.0),
                      Text(state.authStatus == AuthStatus.searchLocation?'Поиск филиалов поблизости....'.tr():
                      'Для определения филиала в автоматическом режиме, включите определение геолокации на своем устройстве'.tr(),
                          textAlign: TextAlign.center,
                          style: TStyle.textStyleVelaSansBold(colorBlack,size: 18.0)),
                    ],
                  ),


                const Gap(30.0),
                 Visibility(
                   visible: state.authStatus != AuthStatus.searchLocation,
                   child: OutLineButton(
                    textButton: 'Поиск'.tr(),
                     onTap: (){
                      _controller.forward();
                      context.read<AuthBloc>().add(SearchLocationEvent());
                     },

                                   ),
                 ),

                const Gap(10.0),
                Visibility(
                  visible: state.authStatus != AuthStatus.searchLocation,
                  child: TextButton(onPressed: () {
                    Dialoger.showModalBottomMenu(
                      height: 240.0,
                        title:'Выбери свой филиал'.tr(),
                        context: context, content: SelectBranch());
                  }, child: Column(
                    children: [
                      Text('Выбрать вручную'.tr(),style: TStyle.textStyleVelaSansRegularUnderline(colorOrange,size: 14.0)),
                    ],
                  ),),
                )
                // SubmitButton(
                //   onTap: (){
                //     GoRouter.of(context).push(pathSuccessSendSMS);
                //   },
                //   textButton: 'Запросить код по СМС'.tr(),
                // ),
              ],
            ),
          );
        }
      ),
    );
  }
}