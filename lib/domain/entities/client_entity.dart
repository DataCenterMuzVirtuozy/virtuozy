

  import 'package:virtuozy/domain/entities/lesson_entity.dart';


 enum ClientStatus{
   action,
   archive,
   replacement,
   trial,
   empty,
   unknown
 }

class ClientEntity{

     final String name;
     final int idStudent;
     final String dateLestLesson;
     final LessonStatus statusLastLesson;
     final LessonStatus statusNearLesson;
     final String phoneNum;
     final int countAllLesson;
     final int countBalanceLesson;
     final String dateNearLesson;
     final String timeNearLesson;
     final bool actionSub;
     final String dateCreate;
     final String nameDir;
     final String idSchool;
     final String nameTeacher;
     final String nameSub;
     final String dOa;
     final ClientStatus  status;
     final int outL;
     final int cancelL;
     final int plannedL;
     final int unallocatedL;
     final String platform;
     final String login;

     ClientEntity(
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
}