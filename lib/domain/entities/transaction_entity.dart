
enum TypeTransaction{
   minusLesson,
   addBalance
}

 class TransactionEntity{

   final TypeTransaction typeTransaction;
   final String time;
   final double quantity;

   const TransactionEntity({
    required this.typeTransaction,
    required this.time,
    required this.quantity,
  });



}