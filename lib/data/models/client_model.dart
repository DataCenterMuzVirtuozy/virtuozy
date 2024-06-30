


 class ClientModel{

   final String name;
   final int idStudent;
   final String dateLestLesson;
   final int statusLastLesson;
   final int statusNearLesson;
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
   final int outL;
   final int cancelL;
   final int plannedL;
   final int unallocatedL;
   final String platform;
   final String login;

   ClientModel(
      {
        required this.login,
        required this.platform,
        required this.unallocatedL,
        required this.outL,
        required this.plannedL,
        required this.cancelL,
        required this.statusNearLesson,
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
       login: map['login']??'@kjkdkfsdf',// add mokyy
       platform: map['platform']??'Telegram',// add mokyy
       unallocatedL: map['unallocatedL']??0, // add mokyy
         outL: map['outL'],
         plannedL: map['plannedL'],
         cancelL: map['cancelL'],
       statusNearLesson: map['statusNearLesson'],
       timeNearLesson: map['timeNearLesson'],
       status: map['status'],
         name: map['name'],
         idStudent: map['idStudent'],
         dateLestLesson: map['dateLastLesson'],
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