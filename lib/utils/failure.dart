






import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';



class Failure implements Exception{

  final String message;
  const Failure(this.message);


  @override
  String toString() => message;

  // factory Failure.fromAuthApiError(FirebaseAuthException exception){
  //   return Failure(firebaseAuthErrorToMessage(exception));
  // }

  // factory Failure.fromFirebaseFunctionError(FirebaseFunctionsException exception){
  //   return Failure(firebaseFunctionError(exception));
  // }

  factory Failure.fromDioError(DioError exception){
    return Failure(responseError(exception.response!.statusCode!));
  }


  static String responseError(int statusCode){
    switch (statusCode) {
      case 500:
        return 'Ошибка сервера'.tr();
      case 107:
        return 'Ошибка записи данных конфигурации пользователя'.tr();
      case 104:
        return 'Ошибка ввода данных в поле поддержки клиентов'.tr();
      case 105:
        return 'Ошибка записи данных в поле кошелька'.tr();
      case 106:
        return 'Ошибка записи пользовательских данных'.tr();
      default:
        return 'Произошла неизвестная ошибка'.tr();
    }
  }




  // static String firebaseAuthErrorToMessage(FirebaseAuthException exception){
  //   switch (exception.code) {
  //     case 'invalid-email':
  //       return 'Hеверный адрес электронной почты'.tr();
  //     case 'user-disabled':
  //       return 'Пользоваьель отключен'.tr();
  //     case 'user-not-found':
  //       return 'Пользователь не найден'.tr();
  //     case 'wrong-password':
  //       return 'Неправильный пароль'.tr();
  //     case 'email-already-in-use':
  //       return 'Этот электронный адрес уже занят'.tr();
  //     case 'account-exists-with-different-credential':
  //       return 'Учетная запись существует с другими учетными данными'.tr();
  //     case 'invalid-credential':
  //       return 'Недействительные учетные данные'.tr();
  //     case 'operation-not-allowed':
  //       return 'Операция запрещена'.tr();
  //     case 'weak-password':
  //       return 'Пароль менее 6 символов'.tr();
  //     case'network-request-failed':
  //       return 'Сбой сетевого запроса, проверь соединение'.tr();
  //
  //     case 'ERROR_MISSING_GOOGLE_AUTH_TOKEN':
  //     default:
  //       return 'Ошибка сервера'.tr();
  //   }
  // }

}