

 import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
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

import '../../components/buttons.dart';
import '../../components/text_fields.dart';
import '../../resourses/colors.dart';
import '../../resourses/images.dart';
import '../../utils/text_style.dart';
import 'bloc/auth_event.dart';

class SingInPage extends StatefulWidget{
  const SingInPage({super.key});

  @override
  State<SingInPage> createState() => _SingInPageState();
}

class _SingInPageState extends State<SingInPage> {

  late TextEditingController _phoneController;
  late TextEditingController _firsNameController;
  late TextEditingController _lastNameController;
  late MaskTextInputFormatter _maskFormatter;


  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController();
    _lastNameController = TextEditingController();
    _firsNameController = TextEditingController();
    _maskFormatter = MaskTextInputFormatter(
        mask: '+# (###) ###-##-##',
        filter: { "#": RegExp(r'[0-9]') },
        type: MaskAutoCompletionType.lazy
    );
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
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0,right: 20.0,top: 50.0),
        child: SingleChildScrollView(
          child: BlocConsumer<AuthBloc,AuthState>(
            listener: (c, s) {
              if(s.error.isNotEmpty){
                Dialoger.showActionMaterialSnackBar(context: context, title: s.error);
              }

              if(s.authStatus == AuthStatus.onSearchLocation){
                GoRouter.of(context).push(pathBranchSearch);
              }
            },
            builder: (context,state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      SvgPicture.asset(logo),
                      const Gap(30.0),
                      Image.asset(illustration_5),
                      const Gap(20.0),
                      Text('Добро пожаловать!'.tr(),style: TStyle.textStyleVelaSansBold(colorBlack,size: 25.0)),
                    ],
                  ),
                  const Gap(20.0),
                  Column(
                    children: [
                      CustomField(controller: _lastNameController, textHint: 'Фамилия'.tr(), iconData: Icons.drive_file_rename_outline, fillColor: colorWhite),
                      const Gap(15.0),
                      CustomField(controller: _firsNameController, textHint: 'Имя'.tr(),iconData: Icons.drive_file_rename_outline, fillColor: colorWhite),
                      const Gap(15.0),
                      PhoneField(
                        onChange: (text){

                        },
                        textInputFormatter: _maskFormatter,
                          controller: _phoneController),
                      const Gap(30.0),
                      SubmitButton(
                        onTap: (){
                          context.read<AuthBloc>().add(SingInEvent(
                              lastName: _lastNameController.text,
                          firstName: _firsNameController.text,
                          phone: _phoneController.text));
                        },
                        textButton: 'Далее'.tr(),
                      ),
                      const Gap(15.0),
                      TextButton(onPressed: (){
                        Navigator.pop(context);
                      },
                          child: Text('Вход'.tr(),
                            style: TStyle.textStyleVelaSansRegularUnderline(colorBlack,size: 18.0),)),
                      const Gap(20.0),
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

