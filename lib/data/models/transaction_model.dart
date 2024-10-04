
  import 'package:virtuozy/domain/entities/transaction_entity.dart';

class TransactionModel{

    final int typeTransaction;
    final String time;
    final String date;
    final double quantity;
    final int idDir;
    final int idUser;

    const TransactionModel( {
      required this.idUser,
      required this.idDir,
    required this.typeTransaction,
    required this.time,
      required this.date,
    required this.quantity,
  });

    static Map<String, dynamic> toMap({required TransactionEntity transactionEntity}) {
    return {
      'typeTransaction': transactionEntity.typeTransaction == TypeTransaction.addBalance?1:0,
      'time': transactionEntity.time,
      'date': transactionEntity.date,
      'quantity': transactionEntity.quantity,
      'idDir': transactionEntity.idDir,
      'idUser':transactionEntity.idUser
    };
  }

    factory TransactionModel.fromMap(Map<String, dynamic> map) {
      final idUser = map['idUser'];
      final typeTransaction = map['typeTransaction'];
      final quantity = double.parse(map['quantity'].toString());
      final idDir =  map['idDir'];
      return TransactionModel(
        idUser: idUser,
        date: map['date'] as String,
        typeTransaction: typeTransaction,
        time: map['time'] as String,
        quantity: quantity,
        idDir: idDir, //todo empty from api
      );
    }
}