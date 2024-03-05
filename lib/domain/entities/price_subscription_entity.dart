

 class PriceSubscriptionEntity{

   final int id;
   final String name;
   final double price;
   final double priceOneLesson;
   final int quantityLesson;

   const PriceSubscriptionEntity({
     required this.id,
    required this.name,
    required this.price,
    required this.priceOneLesson,
    required this.quantityLesson,
  });


  factory PriceSubscriptionEntity.unknown(){
    return const PriceSubscriptionEntity(name: '', price: 0.0, priceOneLesson: 0.0, quantityLesson: 0,id: 0);
  }

  PriceSubscriptionEntity copyWith({
    String? name,
    double? price,
    double? priceOneLesson,
    int? quantityLesson,
    int? id
  }) {
    return PriceSubscriptionEntity(
      id: id??this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      priceOneLesson: priceOneLesson ?? this.priceOneLesson,
      quantityLesson: quantityLesson ?? this.quantityLesson,

    );
  }
}