import 'dart:io';

import 'package:virtuozy/data/models/log_model.dart';

import '../../di/locator.dart';
import '../rest/dio_client.dart';
import '../rest/endpoints.dart';

class LogService {
  static sendLog(TypeLog type, [StackTrace? stackTrace]) async {
    // final dioApi = locator.get<DioClient>().initApi();
    // final time = DateTime.now().toString();
    // final stack = stackTrace!=null?stackTrace.toString():'';
    // final platform =
    //     Platform.isAndroid ? TypePlatform.android : TypePlatform.ios;
    // await dioApi.post(Endpoints.log,
    //     queryParameters: LogModel(
    //             time: time,
    //             typeLog: type,
    //             platform: platform,
    //             stackTrace:stack)
    //         .toMap());
  }
}
