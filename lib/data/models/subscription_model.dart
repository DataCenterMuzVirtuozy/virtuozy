

 class SubscriptionModel{
  final String name;
   final double price;
  final double  priceOneLesson;
  final double balanceSub;
  final int balanceLesson;

  const SubscriptionModel({
    required this.name,
    required this.price,
    required this.priceOneLesson,
    required this.balanceSub,
    required this.balanceLesson,
  });



  factory SubscriptionModel.fromMap(Map<String, dynamic> map) {
    return SubscriptionModel(
      name: map['name'] as String,
      price: map['price'] as double,
      priceOneLesson: map['priceOneLesson'] as double,
      balanceSub: map['balanceSub'] as double,
      balanceLesson: map['balanceLesson'] as int,
    );
  }
}