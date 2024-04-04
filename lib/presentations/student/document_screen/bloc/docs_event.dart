


 import 'package:equatable/equatable.dart';

class DocsEvent extends Equatable{

  @override
  List<Object?> get props => [];

  const DocsEvent();
}

 class GetDocumentsEvent extends DocsEvent{
   const GetDocumentsEvent();
}

 class AcceptDocumentsEvent extends DocsEvent{
   const AcceptDocumentsEvent();
}