


  import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:gap/gap.dart';
import 'package:virtuozy/components/app_bar.dart';
import 'package:virtuozy/components/box_info.dart';
import 'package:virtuozy/utils/auth_mixin.dart';

import '../../../components/buttons.dart';
import '../../../resourses/colors.dart';
import '../../../utils/text_style.dart';

class DocumentsPage extends StatefulWidget{
  const DocumentsPage({super.key});

  @override
  State<DocumentsPage> createState() => _DocumentsPageState();
}

class _DocumentsPageState extends State<DocumentsPage> with AuthMixin{


  bool _acceptDoc = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(title: 'Мои документы'.tr()),
      body:  Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 120),
            child: const PDF().cachedFromUrl(
              user.documents[0],
              placeholder: (progress) =>  Center(child: CircularProgressIndicator(color: colorOrange)),
              errorWidget: (error) =>  Center(
                  child: BoxInfo(title: 'Ошибка загрузки документов'.tr(),
                      iconData: Icons.error_outline_rounded))),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              height: 120,
              color: Theme.of(context).colorScheme.surfaceVariant,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //todo test
                      Text('Принять условия в документах',
                        style: TStyle.textStyleVelaSansMedium(Theme.of(context).textTheme.displayMedium!.color!,
                            size: 18.0),),
                      Checkbox(
                          side: BorderSide(color: Theme.of(context).textTheme.displayMedium!.color!),
                          checkColor: colorWhite,
                          value: _acceptDoc,
                          onChanged: (v){
                            setState(() {
                              _acceptDoc = v!;
                            });
                          }),
                    ],
                  ),
                  const Gap(10.0),
                  Opacity(
                    opacity: _acceptDoc?1.0:0.3,
                    child: SizedBox(
                      height: 40.0,
                      child: SubmitButton(
                          textButton: 'Отправить ответ'.tr(),
                          onTap: () {
                    
                          }
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),

    );
  }
}