

  import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:virtuozy/components/buttons.dart';
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
  late TextEditingController _passwordController;


  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController();
   // _passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0,right: 20.0,top: 50.0),
        child: SingleChildScrollView(
          child: Column(
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
                children: [
                  CustomField(controller: _codeController, textHint: 'Пароль от личного кабинета'.tr(), iconData: Icons.code, fillColor: colorWhite),
                  const Gap(40.0),
                  SubmitButton(
                    textButton: 'Войти'.tr(),
                  ),
                  const Gap(15.0),
                  TextButton(onPressed: (){
                    GoRouter.of(context).push(pathSingIn);

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