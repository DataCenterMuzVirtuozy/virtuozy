

  import 'package:equatable/equatable.dart';

import '../../../../domain/entities/document_entity.dart';

enum DocsStatus{
  accepting,
  accepted,
  loading,
  loaded,
  unknown,
  error
}


class DocsState extends Equatable{


  final List<DocumentEntity> docs;
  final DocsStatus docsStatus;
  final String error;


 factory DocsState.unknown(){
   return const DocsState(docs: [], docsStatus: DocsStatus.unknown, error: '');
 }

  @override
  List<Object?> get props => [docs,docsStatus,error];

  const DocsState({
    required this.docs,
    required this.docsStatus,
    required this.error,
  });

  DocsState copyWith({
    List<DocumentEntity>? docs,
    DocsStatus? docsStatus,
    String? error,
  }) {
    return DocsState(
      docs: docs ?? this.docs,
      docsStatus: docsStatus ?? this.docsStatus,
      error: error ?? this.error,
    );
  }
}