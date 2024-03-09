

 import 'package:virtuozy/data/models/transaction_model.dart';
import 'package:virtuozy/domain/entities/transaction_entity.dart';

class TransactionMapper{


   static TransactionEntity fromApi({required TransactionModel transactionModel}){
    return TransactionEntity(
      idUser: transactionModel.idUser,
      idDir: transactionModel.idDir,
        date: transactionModel.date,
        typeTransaction: transactionModel.typeTransaction == 0?TypeTransaction.minusLesson:TypeTransaction.addBalance,
        time: transactionModel.time,
        quantity: transactionModel.quantity);
  }

 }