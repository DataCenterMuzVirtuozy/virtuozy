

 class LidsModel{


   final String name;
   final String dateCreated;
   final String nameDir;
   final String dateTrial;
   final String dateLastLesson;
   final int lessonLastStatus;
   final String idSchool;

   LidsModel(
       {required this.name,
         required this.dateCreated,
         required this.nameDir,
         required this.dateTrial,
         required this.dateLastLesson,
         required this.lessonLastStatus,
         required this.idSchool});


   factory LidsModel.fromApi({required Map<String,dynamic> map}){
     return LidsModel(
         name: map['name'] as String,
         dateCreated: map['dateCreated'] as String,
         nameDir: map['nameDir'] as String,
         dateTrial: map['dateTrial'] as String,
         dateLastLesson: map['dateLastLesson'] as String,
         lessonLastStatus: map['lessonLastStatus'] as int,
         idSchool: map['idSchool'] as String);
   }
 }