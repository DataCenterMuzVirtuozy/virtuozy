



import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:virtuozy/presentations/auth_screen/bloc/auth_bloc.dart';
import 'package:virtuozy/presentations/auth_screen/bloc/auth_state.dart';

import '../../bloc/app_bloc.dart';
import '../../components/buttons.dart';
import '../../components/dialogs/dialoger.dart';
import '../../components/text_fields.dart';
import '../../resourses/colors.dart';
import '../../router/paths.dart';
import '../../utils/preferences_util.dart';
import '../../utils/text_style.dart';
import 'bloc/auth_event.dart';

class ResetPasswordPage extends StatefulWidget{
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {

  late TextEditingController _phoneController;
  late MaskTextInputFormatter _maskFormatter;
  bool _networkConnect = true;
  String _phoneNumUser = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final appState = context.watch<AppBloc>().state;
    _networkConnect = appState.statusNetwork.isConnect;
  }

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController();
    _phoneNumUser = PreferencesUtil.phoneUser;
    _maskFormatter = MaskTextInputFormatter(
        mask: '+# (###) ###-##-##',
        filter: {"#": RegExp(r'[0-9]')},
        type: MaskAutoCompletionType.lazy);
    if(_phoneNumUser.isNotEmpty) {
      final phone = _maskFormatter.maskText(_phoneNumUser);
      _phoneController.text = phone;
    }
  }


  @override
  void dispose() {
    super.dispose();
    _phoneController.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
        backgroundColor: Theme.of(context).colorScheme.background,
        actions: [

        ],
      ),
      body: BlocConsumer<AuthBloc,AuthState>(
          listener: (c1,s1){
            if (s1.authStatus == AuthStatus.sendRequestResPass) {
              GoRouter.of(context).pushReplacement(pathSuccessSendSMS,extra: true);
            }



            if (s1.error.isNotEmpty) {
              Dialoger.showActionMaterialSnackBar(
                  context: context, title: s1.error);
            }


          },
          builder: (c,s){
            if (s.authStatus == AuthStatus.resettingPass) {
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: colorOrange),
                  ],
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                     Icon(Icons.lock_reset,size: 120,color: colorGrey),
                      const Gap(20.0),
                      Text('Сброс пароля'.tr(),
                          style: TStyle.textStyleVelaSansBold(
                              Theme.of(context).textTheme.displayMedium!.color!,
                              size: 25.0)),
                    ],
                  ),
                  const Gap(30.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      PhoneField(
                          onChange: (String text) {},
                          textInputFormatter: _maskFormatter,
                          controller: _phoneController),
                      const Gap(20.0),
                      SubmitButton(
                        onTap: () {
                          if(!_networkConnect){
                            Dialoger.showActionMaterialSnackBar(
                                context: context, onAction: () {}, title: 'Нет сети'.tr());
                            return;
                          }
                          context.read<AuthBloc>().add(ResetPassEvent(
                              phone: _phoneController.text));
                        },
                        textButton: 'Сбросить пароль'.tr(),
                      ),

                    ],
                  ),
                  const Gap(50)
                ],
              ),
            );
    }

      ),
    );
  }
}