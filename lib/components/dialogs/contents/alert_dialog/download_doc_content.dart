


 import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:virtuozy/domain/entities/document_entity.dart';
import 'package:virtuozy/presentations/student/document_screen/bloc/docs_event.dart';

import '../../../../presentations/student/document_screen/bloc/docs_bloc.dart';
import '../../../../presentations/student/document_screen/bloc/docs_state.dart';
import '../../../../resourses/colors.dart';
import '../../../../utils/text_style.dart';
import '../../dialoger.dart';

class DownloadDocContent extends StatelessWidget{
  const DownloadDocContent({super.key, required this.documentEntity});

  final DocumentEntity documentEntity;


  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.only(top: 10),
      child: BlocConsumer<DocsBloc,DocsState>(
        listener: (c,s){
          if(s.docsStatus ==  DocsStatus.error){
            Dialoger.showActionMaterialSnackBar(context: context, title: s.error);
          }
        },
        builder: (context,state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.save_alt_rounded,color: Theme.of(context).textTheme.displayMedium!.color!,size: 40.0),
              const SizedBox(height: 15.0),
              Text(documentEntity.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign:TextAlign.center,
                  style:TStyle.textStyleVelaSansBold(Theme.of(context).textTheme.displayMedium!.color!,size: 18.0)),
              const SizedBox(height: 5.0),
              Text('Сохранить документ в памяти устройства?'.tr(),
                  textAlign:TextAlign.center,
                  style:TStyle.textStyleVelaSansRegular(Theme.of(context).textTheme.displayMedium!.color!,size: 16.0)),

              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Отмена'.tr(),
                          textAlign: TextAlign.center,
                          style: TStyle.textStyleVelaSansBold(
                              Theme.of(context).textTheme.displayMedium!.color!,
                              size: 16.0))),
                  const Gap(5.0),
                  TextButton(
                    onPressed: () {
                      context.read<DocsBloc>().add( DownloadDocumentEvent(documentEntity.docUrl));
                      Navigator.pop(context);
                    },
                    child: Text('Загрузить'.tr(),
                        textAlign: TextAlign.center,
                        style:
                        TStyle.textStyleVelaSansBold(colorRed,size: 16.0)),)
                ],
              )
            ],
          );
        }
      ),
    );

  }


 }