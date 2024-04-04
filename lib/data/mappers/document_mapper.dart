


  import 'package:virtuozy/data/models/document_model.dart';
import 'package:virtuozy/domain/entities/document_entity.dart';

class DocumentMapper{


    static DocumentEntity fromApi({required DocumentModel documentModel}){
      return DocumentEntity(
        name: documentModel.name,
        docUrl: documentModel.docUrl,
        dateSend: documentModel.dateSend,
        dateAccept: documentModel.dateAccept,
        accept: documentModel.accept);
  }

  static DocumentModel toApi({required DocumentEntity documentEntity}){
      return DocumentModel(
          name: documentEntity.name,
          docUrl: documentEntity.docUrl,
          dateSend: documentEntity.dateSend,
          dateAccept: documentEntity.dateAccept,
          accept: documentEntity.accept);
  }


  }