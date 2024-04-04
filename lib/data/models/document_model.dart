

  class DocumentModel{

    final String docUrl;
    final String dateSend;
    final String dateAccept;
    final bool accept;
    final String name;

    const DocumentModel({
      required this.name,
    required this.docUrl,
    required this.dateSend,
    required this.dateAccept,
    required this.accept,
  });

    Map<String, dynamic> toMap() {
    return {
      'name':name,
      'docUrl': docUrl,
      'dateSend': dateSend,
      'dateAccept': dateAccept,
      'accept': accept,
    };
  }

  factory DocumentModel.fromMap(Map<String, dynamic> map) {
    return DocumentModel(
      name: map['name'] as String,
      docUrl: map['docUrl'] as String,
      dateSend: map['dateSend'] as String,
      dateAccept: map['dateAccept'] as String,
      accept: map['accept'] as bool,
    );
  }
}