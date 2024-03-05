


 class PriceSubscriptionModel{


   final int id;
   final String name;
   final double price;
   final double priceOneLesson;
   final int quantityLesson;



   const PriceSubscriptionModel({
     required this.id,
    required this.name,
    required this.price,
    required this.priceOneLesson,
    required this.quantityLesson,
  });






  factory PriceSubscriptionModel.fromMap(Map<String, dynamic> map) {
    return PriceSubscriptionModel(
      id: map['id'] as int,
      name: map['name'] as String,
      price: (map['price'] as dynamic).toDouble()??0.0,
      priceOneLesson: (map['priceOneLesson'] as dynamic).toDouble()??0.0,
      quantityLesson: map['quantityLesson']??0,

    );
  }
}