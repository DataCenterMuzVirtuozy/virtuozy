

 class SubscriptionEntity{

   final String name;
   final double price;
   final double  priceOneLesson;
   final double balanceSub;
   final int balanceLesson;

   const SubscriptionEntity({
    required this.name,
    required this.price,
    required this.priceOneLesson,
    required this.balanceSub,
    required this.balanceLesson,
  });

   SubscriptionEntity copyWith({
    String? name,
    double? price,
    double? priceOneLesson,
    double? balanceSub,
    int? balanceLesson,
  }) {
    return SubscriptionEntity(
      name: name ?? this.name,
      price: price ?? this.price,
      priceOneLesson: priceOneLesson ?? this.priceOneLesson,
      balanceSub: balanceSub ?? this.balanceSub,
      balanceLesson: balanceLesson ?? this.balanceLesson,
    );
  }
}