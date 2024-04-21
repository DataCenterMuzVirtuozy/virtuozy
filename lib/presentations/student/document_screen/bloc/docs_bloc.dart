

 import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:virtuozy/domain/entities/document_entity.dart';
import 'package:virtuozy/domain/user_cubit.dart';
import 'package:virtuozy/utils/date_time_parser.dart';
import 'package:virtuozy/utils/failure.dart';
 import 'package:path_provider/path_provider.dart' as pathProvider;
import '../../../../di/locator.dart';
import '../../../../domain/entities/user_entity.dart';
import '../../../../domain/repository/user_repository.dart';
import 'docs_event.dart';
import 'docs_state.dart';

class DocsBloc extends Bloc<DocsEvent,DocsState>{
  DocsBloc():super(DocsState.unknown()){
   on<GetDocumentsEvent>(_getDocs);
   on<AcceptDocumentsEvent>(_acceptDocs);
   on<DownloadDocumentEvent>(_downLoadDoc);
  }


  final _userCubit = locator.get<UserCubit>();
  final _userRepo =  locator.get<UserRepository>();


  void _getDocs(GetDocumentsEvent event,emit) async {
   try{
      emit(state.copyWith(docsStatus: DocsStatus.loading,error: ''));
      await Future.delayed(const Duration(milliseconds: 700));
      final docs = _userCubit.userEntity.documents;
      emit(state.copyWith(docsStatus: DocsStatus.loaded,docs: docs));

   }on Failure catch(e){
    emit(state.copyWith(error: e.message,docsStatus: DocsStatus.error));
   }
  }

  void _acceptDocs(AcceptDocumentsEvent event,emit) async {
   try{
    emit(state.copyWith(docsStatus: DocsStatus.accepting));
    UserEntity user = _userCubit.userEntity;
     final dateAccept = DateTimeParser.getDateToApi(dateNow: DateTime.now());
    List<DocumentEntity> docsNew = [];
    for(int i = 0; i< user.documents.length;i++){
     docsNew.add(DocumentEntity(
       name: user.documents[i].name,
         docUrl: user.documents[i].docUrl,
         dateSend: user.documents[i].dateSend,
         dateAccept: dateAccept,
         accept: true));
    }
    await _userRepo.acceptDocuments(uid: user.id, docs: docsNew);
    user = user.copyWith(documents: docsNew);
    _userCubit.setUser(user: user);
    emit(state.copyWith(docsStatus: DocsStatus.accepted,docs: docsNew));
   }on Failure catch(e){
    emit(state.copyWith(error: e.message,docsStatus: DocsStatus.error));
   }
  }


  void _downLoadDoc(DownloadDocumentEvent event,emit) async {
    try{
      emit(state.copyWith(docsStatus: DocsStatus.download,error: ''));
      final path = await _localPath;
       await FlutterDownloader.enqueue(
        url: event.urlDoc,
        headers: {}, // optional: header send with url (auth token etc)
        savedDir: path,
        saveInPublicStorage: true,
        showNotification: true, // show download progress in status bar (for Android)
        openFileFromNotification: true, // click on notification to open downloaded file (for Android)
      );
      emit(state.copyWith(docsStatus: DocsStatus.downloaded,error: ''));
    }on Failure catch(e){
      emit(state.copyWith(docsStatus: DocsStatus.error,error: e.message));
    } catch (e){
      emit(state.copyWith(docsStatus: DocsStatus.error,error: 'Ошибка загрузки документа'.tr()));
    }
  }


  Future<String> get _localPath async {
    if(Platform.isIOS){
      print("DIR IOS");
      final dir = await pathProvider.getApplicationDocumentsDirectory();
       return dir.path;

    }else{
      final directory = await pathProvider.getDownloadsDirectory();
      return directory!.path;
    }

  }





 }