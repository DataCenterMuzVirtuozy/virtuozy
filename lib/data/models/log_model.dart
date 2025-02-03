

    import 'dart:io';

enum TypeLog{
     login,
      registration,
      logout,
      errorLogin,
      errorRegistration,
      errorLogout,
      errorData,
      errorInitApp,
      errorResetPass,
      errorDeleteAccount,
      editedPass
    }

    enum TypePlatform{
      android,
      ios
    }


    class LogModel{

      final TypeLog typeLog;
      final TypePlatform platform;
      final String stackTrace;
      final String time;

      const LogModel({
        required this.time,
    required this.typeLog,
    required this.platform,
    required this.stackTrace,
  });





      Map<String, dynamic> toMap() {
    return {
      'time': time,
      'typeLog': typeLog.name,
      'platform': platform.name,
      'stackTrace': stackTrace,
      'os':'', //todo
      'versionApp': '', //todo
      'tokenUser' : '' //todo
    };
  }

  factory LogModel.fromMap(Map<String, dynamic> map) {
    return LogModel(
      time: map['time'] as String,
      typeLog: map['typeLog'] as TypeLog,
      platform: map['platform'] as TypePlatform,
      stackTrace: map['stackTrace'] as String,
    );
  }
}