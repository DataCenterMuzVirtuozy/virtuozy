import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:flutter_dynamic_icon/flutter_dynamic_icon.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:virtuozy/components/buttons.dart';
import 'package:virtuozy/components/checkbox_menu.dart';
import 'package:virtuozy/components/dialogs/contents/bottom_sheet_menu/add_lesson_content.dart';
import 'package:virtuozy/components/dialogs/dialoger.dart';
import 'package:virtuozy/presentations/auth_screen/bloc/auth_bloc.dart';
import 'package:virtuozy/presentations/auth_screen/bloc/auth_event.dart';
import 'package:virtuozy/presentations/auth_screen/bloc/auth_state.dart';
import 'package:virtuozy/presentations/student/subscription_screen/bloc/sub_bloc.dart';
import 'package:virtuozy/resourses/colors.dart';
import 'package:virtuozy/resourses/images.dart';
import 'package:virtuozy/router/paths.dart';
import 'package:virtuozy/utils/change_icon_app.dart';
import 'package:virtuozy/utils/contact_school_by_location.dart';
import 'package:virtuozy/utils/preferences_util.dart';

import '../../components/dialogs/sealeds.dart';
import '../../components/text_fields.dart';
import '../../data/utils/location_util.dart';
import '../../utils/text_style.dart';
import '../../utils/theme_provider.dart';
import '../student/subscription_screen/bloc/sub_event.dart';


class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {

  late TextEditingController _phoneController;
  late TextEditingController _passwordController;
  bool _darkTheme = false;
  String _phoneNumSupport = '';
  String _phoneNumUser = '';
  late MaskTextInputFormatter _maskFormatter;

  @override
  void initState() {
    super.initState();
    _phoneNumUser = PreferencesUtil.phoneUser;
    _phoneController = TextEditingController();
    _passwordController = TextEditingController();

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    _darkTheme = context.watch<ThemeProvider>().themeStatus == ThemeStatus.dark;
  }

  @override
  void dispose() {
    super.dispose();

    _phoneController.dispose();
    _passwordController.dispose();
  }

  void _handleLocation() async {
    await LocationUtil.handleLocationPermission(context: context);

  }

  _saveBranch(branch) async {
    bool msk = branch == 'msk';
    await PreferencesUtil.setBranchUser(branch: branch);
    await ChangeIconApp.changeAppIcon(msk?AppIcon.msk:AppIcon.nsk);
  }

  Widget _logo(){
    final branch = PreferencesUtil.branchUser;
    print('State 1 ${branch}');
    if(branch == 'msk'||branch.isEmpty){
      return  _darkTheme
          ? Image.asset(logoDark, width: 100.0)
          : SvgPicture.asset(logo, width: 100.0);
    }else{
      return Container();
    }

  }

  Widget _illustration(){
    final  bool msk = PreferencesUtil.branchUser == 'msk';
    print('State 2 ${msk}');
    if(!msk){
      return Column(
        children: [
          _darkTheme
              ? Image.asset(msk?logoDark:logoMainNskBlack, width: 200.0)
              : msk?SvgPicture.asset(logo, width: 200.0):
          Image.asset(logoMainNsk,width: 200.0),
          const Gap(50)
        ],
      );
    }else{
      return  Image.asset(illustration_5);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions:  [MyCheckboxMenu(
          onChange: (idLoc){
          setState(() {
            _saveBranch(idLoc);
            _phoneNumSupport = ContactSchoolByLocation.getPhoneNumberByIdLocation(idLoc);
          });


        },)],
        iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
        backgroundColor: Theme.of(context).colorScheme.background,
        centerTitle: true,
        title: BlocBuilder<AuthBloc, AuthState>(
          builder: (context,state) {
            return _logo();
          }
        )
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 50.0),
        child: SingleChildScrollView(
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (c, s) {
              if(s.authStatus == AuthStatus.searchLocationComplete){

              }


              if (s.authStatus == AuthStatus.baseUrlEmpty) {
                _handleLocation();
              }


              if (s.error.isNotEmpty) {
                Dialoger.showActionMaterialSnackBar(
                    context: context, title: s.error);
              }

              if (s.authStatus == AuthStatus.authenticated ||
                  s.authStatus == AuthStatus.moderation) {
                context.read<SubBloc>().add(const GetUserEvent(
                    allViewDir: true,
                    currentDirIndex: 0,
                    refreshDirection: true));
                GoRouter.of(context).pop(pathMain);
              }
            },
            builder: (context, state) {
              if (state.authStatus == AuthStatus.processLogIn ||
                  state.authStatus == AuthStatus.authenticated) {
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
                      _illustration(),
                      const Gap(30.0),
                      Text('Добро пожаловать!'.tr(),
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
                      CustomField(
                          controller: _passwordController,
                          textHint: 'Пароль'.tr(),
                          iconData: Icons.code,
                          fillColor: colorPink.withOpacity(0.5)),
                      const Gap(20.0),
                      Visibility(
                        visible: _phoneNumSupport.isNotEmpty,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Не пришел пароль по СМС? Позвоните по телефону'
                                  .tr(),
                              textAlign: TextAlign.center,
                              style: TStyle.textStyleVelaSansMedium(PreferencesUtil.branchUser == 'msk'?colorRed:
                                  colorOrange,
                                  size: 14.0),
                            ),
                            TextButton(
                                onPressed: () async {
                                  await _launchUrlTel(tel: _phoneNumSupport);
                                },
                                child: Text(
                                  _phoneNumSupport,
                                  style: TStyle.textStyleVelaSansRegularUnderline(
                                      PreferencesUtil.branchUser == 'msk'?colorRed:
                                      colorOrange,
                                      size: 16.0),
                                ))
                          ],
                        ).animate().fade(duration: const Duration(milliseconds: 700)),
                      ),
                      const Gap(20.0),
                      SubmitButton(
                        onTap: () {
                          context.read<AuthBloc>().add(LogInEvent(
                            password: _passwordController.text,
                              phone: _phoneController.text));
                        },
                        textButton: 'Войти'.tr(),
                      ),
                      const Gap(10.0),
                      TextButton(
                          onPressed: () {
                            // if (state.authStatus !=
                            //     AuthStatus.sendRequestCode) {
                            //   GoRouter.of(context).push(pathSingIn);
                            // }

                            GoRouter.of(context).push(pathSingIn);
                          },
                          child: Text(
                            'Регистрация'.tr(),
                            style: TStyle.textStyleVelaSansRegularUnderline(
                                Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .color!,
                                size: 18.0),
                          )),
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
    final Uri url = Uri(scheme: 'tel', path: tel);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
