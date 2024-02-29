

enum StatusSub{
  active,
  inactive,
  planned
}

 class SubscriptionEntity{

   final int id;
   final String name;
   final double price;
   final double  priceOneLesson;
   final double balanceSub;
   final int balanceLesson;
   final String dateStart;
   final String dateEnd;
   final String commentary;
   final StatusSub status;

   const SubscriptionEntity({
     required this.id,
    required this.name,
    required this.price,
    required this.priceOneLesson,
    required this.balanceSub,
    required this.balanceLesson,
     required this.dateStart,
     required this.dateEnd,
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
      String? commentary,
     StatusSub? status
  }) {
    return SubscriptionEntity(
      status: status??this.status,
      dateEnd: dateEnd??this.dateEnd,
      dateStart: dateStart??this.dateStart,
      commentary: commentary??this.commentary,
      name: name ?? this.name,
      price: price ?? this.price,
      priceOneLesson: priceOneLesson ?? this.priceOneLesson,
      balanceSub: balanceSub ?? this.balanceSub,
      balanceLesson: balanceLesson ?? this.balanceLesson,
      id: id,
    );
  }
}