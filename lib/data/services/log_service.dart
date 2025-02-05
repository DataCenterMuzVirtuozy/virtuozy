import 'dart:io';

import 'package:dio/dio.dart';
import 'package:virtuozy/data/models/log_model.dart';

import '../../di/locator.dart';
import '../rest/dio_client.dart';
import '../rest/endpoints.dart';

class LogService {
  static sendLog(TypeLog type, [StackTrace? stackTrace]) async {
    try{
      final dioApi = locator.get<DioClient>().initApi();
      final time = DateTime.now().toString();
      final stack = stackTrace!=null?stackTrace.toString():'';
      final platform =
      Platform.isAndroid ? TypePlatform.android : TypePlatform.ios;
      var formData = FormData.fromMap(LogModel(
          time: time,
          typeLog: type,
          platform: platform,
          stackTrace:stack)
          .toMap());

      await dioApi.post(Endpoints.log, data: formData);
    } on DioException catch(e){

    }

  }
}
