

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
import 'package:virtuozy/resourses/colors.dart';
import 'package:virtuozy/resourses/images.dart';
import 'package:virtuozy/router/paths.dart';

import '../../components/text_fields.dart';
import '../../utils/text_style.dart';

class LogInPage extends StatefulWidget{
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {


  late TextEditingController _codeController;
  late TextEditingController _phoneController;
  bool _activePhoneField = true;
  bool _activeCodeField = false;
  bool _activeButton = false;
  bool _visibleButton = true;
  final List<String> _textButton = ['Получить код','Войти'];
  int _indexTextButton = 0;
  late MaskTextInputFormatter _maskFormatter;


  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController();
    _phoneController = TextEditingController();
    _codeController.addListener(() {
      if(_codeController.text.isNotEmpty){
         setState(() {
           _visibleButton = true;
           _indexTextButton = 1;
         });
      }else{
        setState(() {
          _indexTextButton = 0;
        });
      }
    });
    _maskFormatter = MaskTextInputFormatter(
        mask: '+# (###) ###-##-##',
        filter: { "#": RegExp(r'[0-9]') },
        type: MaskAutoCompletionType.lazy
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0,right: 20.0,top: 50.0),
        child: SingleChildScrollView(
          child: BlocConsumer<AuthBloc,AuthState>(
            listener: ( c,s) {
                if(s.authStatus == AuthStatus.sendRequestCode){
                  _visibleButton = false;

                }

                if(s.authStatus == AuthStatus.authenticated){
                  GoRouter.of(context).pushReplacement(pathMain);
                }
                print('Code ${s.authStatus}');
                if(s.authStatus == AuthStatus.awaitCode){
                  _activeCodeField = true;
                  Dialoger.showActionMaterialSnackBar(onAction: (){}, context: context, title: 'Код успешно отправлен. Ожидайте'.tr());
                }
            },
            builder: (context,state) {
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
                      SvgPicture.asset(logo),
                      const Gap(30.0),
                      Image.asset(illustration_5),
                      const Gap(40.0),
                      Text('Добро пожаловать!'.tr(),style: TStyle.textStyleVelaSansBold(colorBlack,size: 25.0)),
                    ],
                  ),
                  const Gap(40.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Opacity(opacity: _activePhoneField?1.0:0.3,
                      child: PhoneField(
                        onChange: (String text){
                          _indexTextButton = 0;
                          if(text.isNotEmpty){
                            setState(() {
                               _activeButton = true;
                            });
                          }else{
                            setState(() {
                              _activeButton = false;
                            });
                          }
                        },
                        textInputFormatter: _maskFormatter,
                        activate: !_activePhoneField,
                          controller: _phoneController)),
                      const Gap(20.0),
                      Opacity(
                          opacity: _activeCodeField?1.0:0.3,
                          child: CustomField(
                            activate: !_activeCodeField,
                              controller: _codeController,
                              textHint: 'Пароль'.tr(),
                              iconData: Icons.code,
                              fillColor: colorPink.withOpacity(0.5))),
                      const Gap(40.0),
                      Visibility(
                        visible: state.authStatus == AuthStatus.awaitCode && !_visibleButton,
                          child: Text('Не пришел пароль по СМС? Позвоните по телефону 8 (499) 322-71-04'.tr(),
                          textAlign: TextAlign.center,
                          style: TStyle.textStyleVelaSansMedium(colorRed,size: 14.0),)),

                      Visibility(
                        visible: state.authStatus == AuthStatus.sendRequestCode,
                          child: CircularProgressIndicator(color: colorOrange)),
                      Visibility(
                        visible: _visibleButton,
                        child: Opacity(
                          opacity: _activeButton?1.0:0.5,
                          child: SubmitButton(
                            onTap: (){
                              if(_activeButton){
                                if(_codeController.text.isEmpty){
                                  setState(() {
                                    _visibleButton = false;
                                  });
                                }

                                if(_phoneController.text.isNotEmpty&&_codeController.text.isEmpty){
                                  context.read<AuthBloc>().add(GetCodeEvent(phoneNumber: _phoneController.text));
                                }
                                if(_codeController.text.isNotEmpty){
                                  context.read<AuthBloc>().add(LogInEvent(code: _codeController.text));
                                }

                              }
                            },
                            textButton: _textButton[_indexTextButton].tr(),
                          ),
                        ),
                      ),
                      const Gap(15.0),
                      TextButton(onPressed: (){
                        if(state.authStatus != AuthStatus.sendRequestCode){
                          GoRouter.of(context).push(pathSingIn);
                        }

                      },
                          child: Text('Регистрация'.tr(),
                          style: TStyle.textStyleVelaSansRegularUnderline(colorBlack,size: 18.0),)),
                      const Gap(30.0),
                      InkWell(
                        onTap: () async {
                          await _launchUrl();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.transit_enterexit,color: colorGrey),
                             const Gap(5.0),
                             Text('virtuozy-msk.ru',
                                  style: TStyle.textStyleVelaSansRegularUnderline(colorGrey,size: 18.0),),
                          ],
                        ),
                      ),
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

  Future<void> _launchUrl() async {
    final Uri url = Uri.parse('https://virtuozy-msk.ru');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}