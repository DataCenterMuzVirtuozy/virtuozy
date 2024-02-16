


 class PriceSubscriptionModel{

   final String name;
   final double price;
   final double priceOneLesson;
   final int quantityLesson;


   const PriceSubscriptionModel({
    required this.name,
    required this.price,
    required this.priceOneLesson,
    required this.quantityLesson,
  });



  factory PriceSubscriptionModel.fromMap(Map<String, dynamic> map) {
    return PriceSubscriptionModel(
      name: map['name'] as String,
      price: map['price'] as double,
      priceOneLesson: map['priceOneLesson'] as double,
      quantityLesson: map['quantityLesson'] as int,

    );
  }
}