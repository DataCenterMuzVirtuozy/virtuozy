
enum TypeTransaction{
   minusLesson,
   addBalance
}

 class TransactionEntity{

   final int idDir;
   final int idUser;
   final TypeTransaction typeTransaction;
   final String time;
   final double quantity;
   final String date;

   const TransactionEntity({
     required this.idUser,
     required this.idDir,
     required this.date,
    required this.typeTransaction,
    required this.time,
    required this.quantity,
  });



}