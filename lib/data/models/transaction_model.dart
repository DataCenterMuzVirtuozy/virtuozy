
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
      return TransactionModel(
        idUser: map['idUser'] as int,
        date: map['date'] as String,
        typeTransaction: map['typeTransaction'] as int,
        time: map['time'] as String,
        quantity: (map['quantity'] as dynamic).toDouble(),
        idDir: map['idDir'] as int,
      );
    }
}