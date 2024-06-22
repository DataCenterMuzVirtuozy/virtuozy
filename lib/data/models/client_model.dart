


 class ClientModel{

   final String name;
   final int idStudent;
   final String dateLestLesson;
   final int statusLastLesson;
   final String phoneNum;
   final int countAllLesson;
   final int countBalanceLesson;
   final String dateNearLesson;
   final bool actionSub;
   final String dateCreate;
   final String nameDir;
   final String idSchool;
   final String nameTeacher;
   final String nameSub;
   final String dOa;
   final int status;
   final String timeNearLesson;

   ClientModel(
      {
        required this.timeNearLesson,
        required this.status,
        required this.name,
      required this.idStudent,
      required this.dateLestLesson,
      required this.statusLastLesson,
      required this.phoneNum,
      required this.countAllLesson,
      required this.countBalanceLesson,
      required this.dateNearLesson,
      required this.actionSub,
      required this.dateCreate,
      required this.nameDir,
      required this.idSchool,
      required this.nameTeacher,
      required this.nameSub,
      required this.dOa});


   factory ClientModel.fromApi({required Map<String,dynamic> map}){
     return ClientModel(
       timeNearLesson: map['timeNearLesson'],
       status: map['status'],
         name: map['name'],
         idStudent: map['idStudent'],
         dateLestLesson: map['dateLestLesson'],
         statusLastLesson: map['statusLastLesson'],
         phoneNum: map['phoneNum'],
         countAllLesson: map['countAllLesson'],
         countBalanceLesson: map['countBalanceLesson'],
         dateNearLesson: map['dateNearLesson'],
         actionSub: map['actionSub'],
         dateCreate: map['dateCreate'],
         nameDir: map['nameDir'],
         idSchool: map['idSchool'],
         nameTeacher: map['nameTeacher'],
         nameSub: map['nameSub'],
         dOa: map['dOa']);
   }
}