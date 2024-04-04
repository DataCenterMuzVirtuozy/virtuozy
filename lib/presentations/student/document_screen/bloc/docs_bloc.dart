

 import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:virtuozy/domain/entities/document_entity.dart';
import 'package:virtuozy/domain/user_cubit.dart';
import 'package:virtuozy/utils/date_time_parser.dart';
import 'package:virtuozy/utils/failure.dart';

import '../../../../di/locator.dart';
import '../../../../domain/entities/user_entity.dart';
import '../../../../domain/repository/user_repository.dart';
import 'docs_event.dart';
import 'docs_state.dart';

class DocsBloc extends Bloc<DocsEvent,DocsState>{
  DocsBloc():super(DocsState.unknown()){
   on<GetDocumentsEvent>(_getDocs);
   on<AcceptDocumentsEvent>(_acceptDocs);
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



 }