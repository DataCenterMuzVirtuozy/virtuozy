

enum StatusSub{
  active,
  inactive,
  planned
}

 class SubscriptionEntity{

   final int id;
   final int idUser;
   final int idDir;
   final String nameDir;
   final String name;
   final double price;
   final double  priceOneLesson;
   final double balanceSub;
   final int balanceLesson;
   final String dateBay;
   final String dateStart;
   final String dateEnd;
   final String commentary;
   final StatusSub status;

   const SubscriptionEntity( {
     required this.idDir,
     required this.idUser,
     required this.id,
     required this.nameDir,
    required this.name,
    required this.price,
    required this.priceOneLesson,
    required this.balanceSub,
    required this.balanceLesson,
     required this.dateStart,
     required this.dateEnd,
     required this.dateBay,
     required this.commentary,
     required this.status
  });

   SubscriptionEntity copyWith({
    String? name,
    double? price,
    double? priceOneLesson,
    double? balanceSub,
    int? balanceLesson,
      String? dateStart,
      String? dateEnd,
     String? dateBay,
      String? commentary,
     StatusSub? status,
     String? nameDir,
      int? idUser,
      int? idDir,
     int? id
  }) {
    return SubscriptionEntity(
      id:id??this.id,
      idDir: idDir??this.idDir,
      idUser: idUser??this.idUser,
      nameDir: nameDir??this.nameDir,
      status: status??this.status,
      dateEnd: dateEnd??this.dateEnd,
      dateStart: dateStart??this.dateStart,
      commentary: commentary??this.commentary,
      name: name ?? this.name,
      price: price ?? this.price,
      priceOneLesson: priceOneLesson ?? this.priceOneLesson,
      balanceSub: balanceSub ?? this.balanceSub,
      balanceLesson: balanceLesson ?? this.balanceLesson,
      dateBay: dateBay??this.dateBay,
    );
  }
}