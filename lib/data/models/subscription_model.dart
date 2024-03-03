

 class SubscriptionModel{
  final int id;
  final String name;
   final double price;
  final double  priceOneLesson;
  final double balanceSub;
  final int balanceLesson;
  final String dateStart;
  final String dateEnd;
  final String commentary;
  final int status;
  final String nameDir;

  const SubscriptionModel( {
    required this.id,
    required this.nameDir,
    required this.dateEnd,
    required this.dateStart,
    required this.commentary,
    required this.name,
    required this.price,
    required this.priceOneLesson,
    required this.balanceSub,
    required this.balanceLesson,
    required this.status
  });



  factory SubscriptionModel.fromMap(Map<String, dynamic> map,String nameDir) {
    return SubscriptionModel(
      nameDir: nameDir,
      name: map['name'] as String,
      price: (map['price'] as dynamic).toDouble(),
      priceOneLesson: (map['priceOneLesson'] as dynamic).toDouble(),
      balanceSub: (map['balanceSub'] as dynamic).toDouble(),
      balanceLesson: map['balanceLesson'] as int,
      id: map['id'] as int,
      dateEnd: map['dateEnd'] as String,
      dateStart: map['dateStart'] as String,
      commentary: map['commentary'] as String,
      status: map['status'] as int
    );
  }
}