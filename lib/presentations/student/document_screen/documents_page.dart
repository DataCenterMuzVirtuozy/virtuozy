


  import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:virtuozy/components/app_bar.dart';
import 'package:virtuozy/components/box_info.dart';
import 'package:virtuozy/components/dialogs/sealeds.dart';
import 'package:virtuozy/domain/entities/user_entity.dart';
import 'package:virtuozy/router/paths.dart';
import 'package:virtuozy/utils/auth_mixin.dart';

import '../../../components/buttons.dart';
import '../../../components/dialogs/dialoger.dart';
import '../../../resourses/colors.dart';
import '../../../utils/text_style.dart';

class DocumentsPage extends StatefulWidget{
  const DocumentsPage({super.key});

  @override
  State<DocumentsPage> createState() => _DocumentsPageState();
}

class _DocumentsPageState extends State<DocumentsPage> with AuthMixin, TickerProviderStateMixin{


  bool _acceptDoc = false;
  List<String> urlsDoc = [];
  List<String> namesDoc = [];
  int _lengthDoc = 0;

  @override
  void initState() {
    super.initState();
    _lengthDoc = user.documents.length-1;
    for(int i = 1; i<=_lengthDoc;i++){
       urlsDoc.add(user.documents[i]);
       namesDoc.add('Документ $i');
    }


  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(title: 'Мои документы'.tr()),
      body:  Stack(
        children: [
          ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _lengthDoc,
              itemBuilder: (context,index){
            return GestureDetector(
              onTap: (){
                GoRouter.of(context).push(pathPreviewDoc,extra: [urlsDoc[index],namesDoc[index]]);
              },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 5.0),
                  padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 15.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Row(
                     crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(7.0),
                        decoration: BoxDecoration(
                            color: colorOrange.withOpacity(0.2),
                            shape: BoxShape.circle
                        ),
                        child: Icon(Icons.file_copy_outlined,color: colorOrange),
                      ),
                      const Gap(10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(namesDoc[index],
                              textAlign: TextAlign.center,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: TStyle.textStyleVelaSansBold(colorGrey,size: 16)),
                          const Gap(5),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('Дата отправки: ',
                                  textAlign: TextAlign.center,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TStyle.textStyleVelaSansMedium(colorBeruza,size: 12)),
                              const Gap(5),
                              Text('22.02.2024',
                                  textAlign: TextAlign.center,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TStyle.textStyleVelaSansBold(colorBeruza,size: 12)),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('Дата подтверждения: ',
                                  textAlign: TextAlign.center,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TStyle.textStyleVelaSansMedium(colorBeruza,size: 12)),
                              const Gap(5),
                              Text('22.02.2024',
                                  textAlign: TextAlign.center,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TStyle.textStyleVelaSansBold(colorBeruza,size: 12)),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ));
          }),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              height: 100,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //todo test
                      Text('Подписать и утвердить документы',
                        style: TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!,
                            size: 16.0),),
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
                  const Gap(5.0),
                  Opacity(
                    opacity: _acceptDoc?1.0:0.3,
                    child: SizedBox(
                      height: 30.0,
                      child: SubmitButton(
                        borderRadius: 8,
                          textButton: 'Отправить ответ'.tr(),
                          onTap: () {
                            Dialoger.showCustomDialog(contextUp: context, content: AcceptDocuments(),
                            args: namesDoc);
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

  class PageViewBody extends StatelessWidget{
    const PageViewBody({super.key,required this.tabController,
      required this.urlsDoc});

    final TabController tabController;
    final List<String> urlsDoc;

    @override
    Widget build(BuildContext context) {
      return   TabBarView(
        controller: tabController,
        children: [
           ...List.generate(tabController.length, (index) {
             return Padding(
               padding: const EdgeInsets.only(bottom: 120,top: 50),
               child: const PDF().cachedFromUrl(
                   urlsDoc[index],
                   placeholder: (progress) =>  Center(child: CircularProgressIndicator(color: colorOrange)),
                   errorWidget: (error) =>  Center(
                       child: BoxInfo(title: 'Ошибка загрузки документов'.tr(),
                           iconData: Icons.error_outline_rounded))),
             );
           })
      ],);
    }
  }