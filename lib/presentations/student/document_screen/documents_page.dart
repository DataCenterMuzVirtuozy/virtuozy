


  import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:virtuozy/components/app_bar.dart';
import 'package:virtuozy/components/box_info.dart';
import 'package:virtuozy/components/dialogs/sealeds.dart';
import 'package:virtuozy/domain/entities/user_entity.dart';
import 'package:virtuozy/presentations/student/document_screen/bloc/docs_event.dart';
import 'package:virtuozy/presentations/student/document_screen/bloc/docs_state.dart';
import 'package:virtuozy/router/paths.dart';
import 'package:virtuozy/utils/auth_mixin.dart';

import '../../../components/buttons.dart';
import '../../../components/dialogs/dialoger.dart';
import '../../../resourses/colors.dart';
import '../../../utils/date_time_parser.dart';
import '../../../utils/text_style.dart';
import 'bloc/docs_bloc.dart';

class DocumentsPage extends StatefulWidget{
  const DocumentsPage({super.key});

  @override
  State<DocumentsPage> createState() => _DocumentsPageState();
}

class _DocumentsPageState extends State<DocumentsPage> with AuthMixin, TickerProviderStateMixin{


  bool _acceptDoc = false;
  bool _accept = false;

  @override
  void initState() {
    super.initState();

  context.read<DocsBloc>().add(const GetDocumentsEvent());

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(title: 'Мои документы'.tr()),
      body:  BlocConsumer<DocsBloc,DocsState>(
        listener: (BuildContext c, DocsState s) {
          if(s.docsStatus == DocsStatus.error){
            Dialoger.showMessage(s.error);
          }

          if(s.docsStatus == DocsStatus.loaded){
            for (var element in s.docs) {
               if(element.accept){
                 _acceptDoc = true;
                 break;
               }
            }
          }
          if(s.docsStatus == DocsStatus.accepted){
            _acceptDoc = true;
            Dialoger.showActionMaterialSnackBar(context: context, title: 'Документы успешно подписаны'.tr());
          }


        },
        builder: (context,state) {

          if(state.docsStatus == DocsStatus.loading){
            return Center(child: CircularProgressIndicator(color: colorOrange,));
          }


          return IgnorePointer(
            ignoring: state.docsStatus == DocsStatus.accepting,
            child: Stack(
              children: [
                ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: state.docs.length,
                    itemBuilder: (context,index){
                  return GestureDetector(
                    onTap: (){
                      GoRouter.of(context).push(pathPreviewDoc,extra: state.docs[index]);
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
                                Text(state.docs[index].name,
                                    textAlign: TextAlign.center,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: TStyle.textStyleVelaSansBold(colorGrey,size: 16)),
                                const Gap(5),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('Дата получения: '.tr(),
                                        textAlign: TextAlign.center,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: TStyle.textStyleVelaSansMedium(colorBeruza,size: 12)),
                                    const Gap(5),
                                    Text(DateTimeParser.getDateFromApi(date: state.docs[index].dateSend),
                                        textAlign: TextAlign.center,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: TStyle.textStyleVelaSansBold(colorBeruza,size: 12)),
                                  ],
                                ),
                                Visibility(
                                  visible: state.docs[index].dateAccept.isNotEmpty,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text('Дата подписания: '.tr(),
                                          textAlign: TextAlign.center,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: TStyle.textStyleVelaSansMedium(colorBeruza,size: 12)),
                                      const Gap(5),
                                      Text(DateTimeParser.getDateFromApi(date: state.docs[index].dateAccept),
                                          textAlign: TextAlign.center,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: TStyle.textStyleVelaSansBold(colorBeruza,size: 12)),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ));
                }),
                if(state.docsStatus == DocsStatus.accepting)...{
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 50),
                      child: CircularProgressIndicator(color: colorOrange),
                    ),
                  )
                }else...{
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Visibility(
                      visible: !_acceptDoc,
                      child: IntrinsicHeight(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surfaceVariant,
                              borderRadius:  BorderRadius.circular(20)
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Icon(Icons.info_outline,color: colorOrange),
                                      const Gap(10),
                                      Text('Подтвердить'.tr(),
                                        style: TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!,
                                            size: 22.0),),
                                    ],
                                  ),
                                  Checkbox(
                                      side: BorderSide(color: Theme.of(context).textTheme.displayMedium!.color!),
                                      checkColor: colorWhite,
                                      value: _accept,
                                      onChanged: (v){
                                        setState(() {
                                          _accept = v!;
                                        });
                                      }),
                                ],
                              ),
                              const Gap(10.0),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Opacity(
                                  opacity: _accept?1.0:0.3,
                                  child: SizedBox(
                                    height: 40.0,
                                    width: 160,
                                    child: SubmitButton(
                                        borderRadius: 10,
                                        textButton: 'Подписать'.tr(),
                                        onTap: () {
                                          if(!_accept){
                                            return;
                                          }
                                          Dialoger.showCustomDialog(contextUp: context, content: AcceptDocuments(),
                                              args: state.docs);
                                        }
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )

                }
              ],
            ),
          );
        },
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