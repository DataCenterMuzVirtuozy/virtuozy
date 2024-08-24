

 import 'package:virtuozy/domain/entities/subscription_entity.dart';

class SubscriptionModel{
  final int id;
  final int idUser;
  final int idDir;
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
  final String dateBay;
  final String nameTeacher;
  final OptionModel optionModel;
  final List<dynamic> contactValues;

  const SubscriptionModel( {
    required this.contactValues,
    required this.idUser,
    required this.idDir,
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
    required this.status,
    required this.dateBay,
    required this.nameTeacher,
    required this.optionModel
  });

 static Map<String, dynamic> toMap({required SubscriptionEntity subscriptionEntity}) {
    return {
      'idUser': subscriptionEntity.idUser,
      'idDir': subscriptionEntity.idDir,
      'name': subscriptionEntity.name,
      'price': subscriptionEntity.price,
      'priceOneLesson': subscriptionEntity.priceOneLesson,
      'balanceSub': subscriptionEntity.balanceSub,
      'balanceLesson': subscriptionEntity.balanceLesson,
      'dateStart': subscriptionEntity.dateStart,
      'dateEnd': subscriptionEntity.dateEnd,
      'commentary': subscriptionEntity.commentary,
      'status': subscriptionEntity.status == StatusSub.active?1:
      subscriptionEntity.status == StatusSub.planned?2:0,
      'nameDir': subscriptionEntity.nameDir,
      'dateBay':subscriptionEntity.dateBay, //
      'nameTeacher':subscriptionEntity.nameTeacher,
      'options':{}
    };

  }

  factory SubscriptionModel.fromMap(Map<String, dynamic> map,String nameDirection) {

   final option = OptionModel.fromMap(map['options'][0]); //todo принимать список
   final idDir = map['idDir'];
   final idUser = map['idUser'];
   int balanceSub = map['balanceSub'];
   final balanceLesson = map['balanceLesson'];
   final status = map['status'];


    return SubscriptionModel(
        contactValues: map['contactValues']??[],
      idDir: idDir,
      idUser: idUser,
      id: map['id'] as int,
      name: map['name'] as String,
      price: (map['price'] as dynamic).toDouble(),
      priceOneLesson: (map['priceOneLesson'] as dynamic).toDouble(),
      balanceSub: balanceSub.toDouble(),
      balanceLesson: balanceLesson,
      dateStart: map['dateStart'] as String,
      dateEnd: map['dateEnd'] as String,
      commentary: map['commentary'] as String,
      status: 1, //todo status
      dateBay: map['dateBay'] as String,
      nameDir: nameDirection,
      nameTeacher: map['nameTeacher'] as String,
      optionModel: option
    );
  }
}

 class OptionModel{
   final String status;
   final String dateEnd;

   const OptionModel({
    required this.status,
    required this.dateEnd,
  });



  factory OptionModel.fromMap(Map<String, dynamic> map) {
    return OptionModel(
      status: map['status']??'',
      dateEnd: map['dataEnd']??'',
    );
  }
}

