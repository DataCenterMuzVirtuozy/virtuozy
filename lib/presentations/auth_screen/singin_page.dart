import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:virtuozy/components/dialogs/dialoger.dart';
import 'package:virtuozy/presentations/auth_screen/bloc/auth_bloc.dart';
import 'package:virtuozy/presentations/auth_screen/bloc/auth_state.dart';
import 'package:virtuozy/router/paths.dart';

import '../../bloc/app_bloc.dart';
import '../../components/buttons.dart';
import '../../components/text_fields.dart';
import '../../data/utils/location_util.dart';
import '../../resourses/colors.dart';
import '../../resourses/images.dart';
import '../../resourses/strings.dart';
import '../../utils/change_icon_app.dart';
import '../../utils/preferences_util.dart';
import '../../utils/text_style.dart';
import '../../utils/theme_provider.dart';
import 'bloc/auth_event.dart';

//ValueNotifier<String> openDropMenuNotifier = ValueNotifier('');

class SingInPage extends StatefulWidget {
  const SingInPage({super.key});

  @override
  State<SingInPage> createState() => _SingInPageState();
}

class _SingInPageState extends State<SingInPage> {
  late TextEditingController _phoneController;
  late TextEditingController _firsNameController;
  late TextEditingController _lastNameController;
  late MaskTextInputFormatter _maskFormatter;
  bool _darkTheme = false;
  String selectedValue = "Не выбрано";
  String _phoneNum = '';
  bool _networkConnect = true;
  final GlobalKey _dropdownButtonKey = GlobalKey();

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(
          value: "Москва",
          child: Text("Москва",
              style: TStyle.textStyleVelaSansRegular(
                  Theme.of(context).textTheme.displayMedium!.color!,
                  size: 14.0))),
      DropdownMenuItem(
          value: "Новосибирск",
          child: Text(
            "Новосибирск",
            style: TStyle.textStyleVelaSansRegular(
                Theme.of(context).textTheme.displayMedium!.color!,
                size: 14.0),
          )),
      DropdownMenuItem(
          value: "Не выбрано",
          child: Text(
            "Не выбрано",
            style: TStyle.textStyleVelaSansRegular(
                Theme.of(context).textTheme.displayMedium!.color!,
                size: 14.0),
          )),
    ];
    return menuItems;
  }

  void openDropdown() {
    GestureDetector? detector;
    void searchForGestureDetector(BuildContext element) {
      element.visitChildElements((element) {
        if (element.widget is GestureDetector) {
          detector = element.widget as GestureDetector?;
        } else {
          searchForGestureDetector(element);
        }
      });
    }

    searchForGestureDetector(_dropdownButtonKey.currentContext!);
    assert(detector != null);
    detector!.onTap!();
  }

  _saveLocation(String selectedValue) async {
    String urlSch = '';
    bool nsk = selectedValue == 'Новосибирск';
    String branch = nsk ? 'nsk' : 'msk';
    if (!nsk) {
      urlSch = mskUrl;
    } else if (nsk) {
      urlSch = nskUrl;
    }
    await PreferencesUtil.setUrlSchool(urlSch);
    await PreferencesUtil.setBranchUser(branch: branch);
    await ChangeIconApp.changeAppIcon(!nsk ? AppIcon.msk : AppIcon.nsk);
  }

  void _handleLocation() async {
    await LocationUtil.handleLocationPermission(context: context);
  }

  Widget _logo() {
    final bool msk = selectedValue == 'Москва'||selectedValue == 'Не выбрано';//PreferencesUtil.branchUser == 'msk';

    if (msk) {
      return _darkTheme
          ? Image.asset(logoDark, width: 100.0)
          : SvgPicture.asset(logo, width: 100.0);
    } else {
      return Container();
    }
  }

  Widget _illustration() {
    //final bool msk = PreferencesUtil.branchUser == 'msk';
    bool nsk = selectedValue == 'Новосибирск';
    if (nsk) {
      return Column(
        children: [
          _darkTheme
              ? Image.asset(!nsk ? logoDark : logoMainNskBlack, width: 200.0)
              : !nsk
                  ? SvgPicture.asset(logo, width: 200.0)
                  : Image.asset(logoMainNsk, width: 200.0),
          const Gap(50)
        ],
      );
    } else {
      return Image.asset(illustration_5);
    }
  }

  @override
  void initState() {
    super.initState();
    //_phoneNum = PreferencesUtil.phoneUser;
    _phoneController = TextEditingController();
    _lastNameController = TextEditingController();
    _firsNameController = TextEditingController();
    //if(_phoneNum.isNotEmpty) _phoneController.text = _phoneNum;
    _maskFormatter = MaskTextInputFormatter(
        mask: '+# (###) ###-##-##',
        filter: {"#": RegExp(r'[0-9]')},
        type: MaskAutoCompletionType.lazy);

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _darkTheme = context.watch<ThemeProvider>().themeStatus == ThemeStatus.dark;
    final appState = context.watch<AppBloc>().state;
    _networkConnect = appState.statusNetwork.isConnect;
  }

  @override
  void dispose() {
    super.dispose();
    _phoneController.dispose();
    _lastNameController.dispose();
    _firsNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (c, s) {
        if (s.authStatus == AuthStatus.sendRequestCode) {
          GoRouter.of(context).pushReplacement(pathSuccessSendSMS, extra: false);
        }

        if (s.error.isNotEmpty) {
          Dialoger.showActionMaterialSnackBar(
              context: context, title: s.error);
        }

        if (s.authStatus == AuthStatus.onSearchLocation) {
          _handleLocation();
        }

        if (s.authStatus == AuthStatus.searchLocationComplete) {
           if(s.changedLocation!='0'||s.changedLocation!='1'){
             if(s.changedLocation == 'msk'){
               selectedValue = 'Москва';
             }else if(s.changedLocation == 'nsk'){
               selectedValue = 'Новосибирск';
             }
           }else{
             openDropdown();
           }
        }
      },
      builder: (context, state) {
        if (state.authStatus == AuthStatus.processSingIn) {
          return Scaffold(
            body: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: colorOrange),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
              iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
              backgroundColor: Theme.of(context).colorScheme.background,
              centerTitle: true,
              title: _logo()),
          body: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 50.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      _illustration(),
                      const Gap(10.0),
                      Text('Добро пожаловать!'.tr(),
                          style: TStyle.textStyleVelaSansBold(
                              Theme.of(context).textTheme.displayMedium!.color!,
                              size: 25.0)),
                    ],
                  ),
                  const Gap(20.0),
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        height: 50.0,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.0),
                          border: Border.all(
                            color: colorPink,
                            width: 1.0,
                          ),
                        ),
                        child: Stack(
                          children: [
                            DropdownButton(
                                key: _dropdownButtonKey,
                                underline: Container(
                                  color: Colors.transparent,
                                ),
                                isExpanded: true,
                                value: selectedValue,
                                items: dropdownItems,
                                onChanged: (v) {
                                  setState(() {
                                    selectedValue = v!;
                                    if (selectedValue == 'Не выбрано') {
                                      return;
                                    }
                                    _saveLocation(selectedValue);
                                  });
                                }),
                            Visibility(
                              visible: selectedValue == 'Не выбрано',
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  color:
                                  Theme.of(context).colorScheme.background,
                                  child: Text(
                                    "Выбери город".tr(),
                                    style: TStyle.textStyleVelaSansRegular(
                                        colorGrey,
                                        size: 14.0),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const Gap(15.0),
                      CustomField(
                          controller: _lastNameController,
                          textHint: 'Фамилия'.tr(),
                          iconData: Icons.drive_file_rename_outline,
                          fillColor: colorWhite),
                      const Gap(15.0),
                      CustomField(
                          controller: _firsNameController,
                          textHint: 'Имя'.tr(),
                          iconData: Icons.drive_file_rename_outline,
                          fillColor: colorWhite),
                      const Gap(15.0),
                      PhoneField(
                          onChange: (text) {},
                          textInputFormatter: _maskFormatter,
                          controller: _phoneController),
                      const Gap(30.0),
                      SubmitButton(
                        onTap: () {

                          if(!_networkConnect){
                            Dialoger.showActionMaterialSnackBar(
                                context: context, onAction: () {}, title: 'Нет сети'.tr());
                            return;
                          }

                          if (selectedValue == 'Не выбрано') {
                            _handleLocation();
                            return;
                          }
                          context.read<AuthBloc>().add(SingInEvent(
                            name: _firsNameController.text,
                              surName: _lastNameController.text,
                          phone: _phoneController.text));
                        },
                        textButton: 'Далее'.tr(),
                      ),
                      const Gap(15.0),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Вход'.tr(),
                            style: TStyle.textStyleVelaSansRegularUnderline(
                                Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .color!,
                                size: 18.0),
                          )),
                      const Gap(20.0),
                      // InkWell(
                      //   onTap: () async {
                      //     await _launchUrl();
                      //   },
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       Icon(Icons.transit_enterexit,color: colorGrey),
                      //       const Gap(5.0),
                      //       Text('virtuozy-msk.ru',
                      //         style: TStyle.textStyleVelaSansRegularUnderline(colorGrey,size: 18.0),),
                      //     ],
                      //   ),
                      // ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _launchUrl() async {
    final Uri url = Uri.parse('https://virtuozy-msk.ru');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
