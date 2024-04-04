


 import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:virtuozy/components/app_bar.dart';
import 'package:virtuozy/components/dialogs/sealeds.dart';
import 'package:virtuozy/domain/entities/document_entity.dart';

import '../../../components/box_info.dart';
import '../../../components/dialogs/dialoger.dart';
import '../../../resourses/colors.dart';

class PreviewDocPage extends StatefulWidget{
  const PreviewDocPage({super.key, required this.documentEntity});


  final DocumentEntity documentEntity;

  @override
  State<PreviewDocPage> createState() => _PreviewDocPageState();
}

class _PreviewDocPageState extends State<PreviewDocPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: colorOrange,
        child: Icon(Icons.file_download_rounded,color: colorWhite),
        onPressed: () {
          Dialoger.showCustomDialog(contextUp: context,
              content: DownloadDocument(),
              args: widget.documentEntity);
      },),
      appBar: AppBarCustom(title: widget.documentEntity.name),
      body:  const PDF().cachedFromUrl(
          widget.documentEntity.docUrl,
          placeholder: (progress) =>  Center(child: CircularProgressIndicator(color: colorOrange)),
          errorWidget: (error) =>  Center(
              child: BoxInfo(title: 'Ошибка загрузки документов'.tr(),
                  iconData: Icons.error_outline_rounded))),
    );
  }
}