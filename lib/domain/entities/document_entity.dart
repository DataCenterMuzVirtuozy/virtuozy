


 class DocumentEntity{

   final String docUrl;
   final String dateSend;
   final String dateAccept;
   final String name;
   final bool accept;

   const DocumentEntity({
     required this.name,
    required this.docUrl,
    required this.dateSend,
    required this.dateAccept,
    required this.accept,
  });
}