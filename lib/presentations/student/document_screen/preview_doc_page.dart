


 import 'dart:isolate';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:virtuozy/components/app_bar.dart';
import 'package:virtuozy/components/dialogs/sealeds.dart';
import 'package:virtuozy/domain/entities/document_entity.dart';

import '../../../components/box_info.dart';
import '../../../components/dialogs/dialoger.dart';
import '../../../resourses/colors.dart';
import 'bloc/docs_bloc.dart';
import 'bloc/docs_state.dart';

class PreviewDocPage extends StatefulWidget{
  const PreviewDocPage({super.key, required this.documentEntity});


  final DocumentEntity documentEntity;

  @override
  State<PreviewDocPage> createState() => _PreviewDocPageState();
}

class _PreviewDocPageState extends State<PreviewDocPage> {



  final ReceivePort _port = ReceivePort();
  bool _downloading = false;




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: !_downloading?FloatingActionButton(
        backgroundColor: colorOrange,
        child: Icon(Icons.file_download_rounded,color: colorWhite),
        onPressed: () {
          Dialoger.showCustomDialog(contextUp: context,
              content: DownloadDocument(),
              args: widget.documentEntity);
      },):null,
      appBar: AppBarCustom(title: widget.documentEntity.name),
      body:  BlocConsumer<DocsBloc,DocsState>(
        listener: (c,s){
          if(s.docsStatus ==  DocsStatus.error){
            Dialoger.showActionMaterialSnackBar(context: context, title: s.error);
          }

          if(s.docsStatus == DocsStatus.download){
            setState(() {
              Dialoger.showMessage('Загрузка началась'.tr());
              _downloading = true;
            });

          }

        },
        builder: (context,state) {
          return const PDF().cachedFromUrl(
              widget.documentEntity.docUrl,
              placeholder: (progress) =>  Center(child: CircularProgressIndicator(color: colorOrange)),
              errorWidget: (error) =>  Center(
                  child: BoxInfo(title: 'Ошибка загрузки документов'.tr(),
                      iconData: Icons.error_outline_rounded)));
        }
      ),
    );
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  @pragma('vm:entry-point')
  static void downloadCallback(String id, int status, int progress) {
    final SendPort? send = IsolateNameServer.lookupPortByName('downloader_send_port');
    send!.send([id, status, progress]);
  }

  @override
  void initState() {
    super.initState();
    IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      int progress = data[2];
      print('Dat ${data[1]}');
      if(data[1]=='RUNNING'){
        //Dialoger.showMessage('Загрузка началась'.tr());
      }

      if(progress==100){
        setState(() {
          _downloading = false;
        });
        Dialoger.showMessage('Загрузка завершена'.tr());
      }
    });

    FlutterDownloader.registerCallback(downloadCallback);
  }
}