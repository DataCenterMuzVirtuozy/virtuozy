

  import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:virtuozy/components/buttons.dart';
import 'package:virtuozy/components/dialogs/dialoger.dart';
import 'package:virtuozy/presentations/auth_screen/bloc/auth_bloc.dart';
import 'package:virtuozy/presentations/auth_screen/bloc/auth_event.dart';
import 'package:virtuozy/presentations/auth_screen/bloc/auth_state.dart';
import 'package:virtuozy/presentations/student/subscription_screen/bloc/sub_bloc.dart';
import 'package:virtuozy/resourses/colors.dart';
import 'package:virtuozy/resourses/images.dart';
import 'package:virtuozy/router/paths.dart';

import '../../components/text_fields.dart';
import '../../utils/text_style.dart';
import '../../utils/theme_provider.dart';
import '../student/subscription_screen/bloc/sub_event.dart';

class LogInPage extends StatefulWidget{
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {


  late TextEditingController _codeController;
  late TextEditingController _phoneController;
  bool _darkTheme = false;
  late MaskTextInputFormatter _maskFormatter;


  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController();
    _phoneController = TextEditingController();
    _maskFormatter = MaskTextInputFormatter(
        mask: '+# (###) ###-##-##',
        filter: { "#": RegExp(r'[0-9]') },
        type: MaskAutoCompletionType.lazy
    );
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _darkTheme = context.watch<ThemeProvider>().themeStatus == ThemeStatus.dark;
  }

  @override
  void dispose() {
    super.dispose();
    _codeController.dispose();
    _phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Theme.of(context).iconTheme.color
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        centerTitle: true,
        title:   _darkTheme?Image.asset(logoDark,width: 100.0):
        SvgPicture.asset(logo, width: 100.0),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0,right: 20.0,top: 50.0),
        child: SingleChildScrollView(
          child: BlocConsumer<AuthBloc,AuthState>(
            listener: ( c,s) {

                if(s.error.isNotEmpty){
                  Dialoger.showActionMaterialSnackBar(context: context,
                      title: s.error);
                }

                if(s.authStatus == AuthStatus.authenticated||
                    s.authStatus == AuthStatus.moderation){
                  context.read<SubBloc>().add(const GetUserEvent(
                      allViewDir: true,
                      currentDirIndex: 0,
                      refreshDirection: true));
                  GoRouter.of(context).pop(pathMain);
                }


            },
            builder: (context,state) {
              print('STATUS ${state.authStatus}');
              if(state.authStatus == AuthStatus.processLogIn||
                  state.authStatus == AuthStatus.authenticated){
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
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Image.asset(illustration_5),
                      const Gap(30.0),
                      Text('Добро пожаловать!'.tr(),style: TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!,
                          size: 25.0)),
                    ],
                  ),
                  const Gap(30.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      PhoneField(
                        onChange: (String text){

                        },
                        textInputFormatter: _maskFormatter,
                          controller: _phoneController),
                      const Gap(20.0),
                      CustomField(
                          controller: _codeController,
                          textHint: 'Пароль'.tr(),
                          iconData: Icons.code,
                          fillColor: colorPink.withOpacity(0.5)),
                      const Gap(20.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Не пришел пароль по СМС? Позвоните по телефону'.tr(),
                          textAlign: TextAlign.center,
                          style: TStyle.textStyleVelaSansMedium(colorRed,size: 14.0),),
                         TextButton(onPressed: () async {
                            await _launchUrlTel(tel: '8 (499) 322-71-04');
                         },
                             child:  Text('8 (499) 322-71-04',
                               style: TStyle.textStyleVelaSansRegularUnderline(colorRed,size: 16.0),))
                        ],
                      ),
                      const Gap(20.0),
                      SubmitButton(
                        onTap: (){
                          context.read<AuthBloc>().add(LogInEvent(
                            phone: _phoneController.text,
                              code: _codeController.text));
                        },
                        textButton:'Войти'.tr(),
                      ),
                      const Gap(10.0),
                      TextButton(onPressed: (){
                        if(state.authStatus != AuthStatus.sendRequestCode){
                          GoRouter.of(context).push(pathSingIn);
                        }

                      },
                          child: Text('Регистрация'.tr(),
                          style: TStyle.textStyleVelaSansRegularUnderline(Theme.of(context).textTheme.displayMedium!.color!,
                              size: 18.0),)),
                      const Gap(5.0),
                      // InkWell(
                      //   onTap: () async {
                      //     await _launchUrl();
                      //   },
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       Icon(Icons.transit_enterexit,color: colorGrey),
                      //        const Gap(5.0),
                      //        Text('virtuozy-msk.ru',
                      //             style: TStyle.textStyleVelaSansRegularUnderline(colorGrey,size: 18.0),),
                      //     ],
                      //   ),
                      // ),
                    ],
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrlTel({required String tel}) async {
    final Uri url = Uri(
        scheme:'tel',
      path: tel);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }


}