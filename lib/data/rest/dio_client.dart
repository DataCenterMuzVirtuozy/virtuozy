import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';

import 'endpoints.dart';




class DioClient {
  static SecurityContext? securityContext;

  Dio init() {
    final dio = Dio(
      BaseOptions(
        baseUrl: Endpoints.baseUrl,
        connectTimeout: const Duration(milliseconds: 15000),
        receiveTimeout: const Duration(milliseconds: 100000),
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
       headers: {'X-Requested-With': 'XMLHttpRequest'},
      ),
    );

    final httpClientAdapter = dio.httpClientAdapter;
    if (httpClientAdapter is DefaultHttpClientAdapter) {
      httpClientAdapter.onHttpClientCreate = (_) => HttpClient(
            context: securityContext,
          );
    }

    return dio;
  }

  Dio initApi() {
    final dio = Dio(
      BaseOptions(
        baseUrl: Endpoints.baseApi,
        connectTimeout: const Duration(milliseconds: 15000),
        receiveTimeout: const Duration(milliseconds: 100000),
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        headers: {'X-Requested-With': 'XMLHttpRequest'},
      ),
    );

    final httpClientAdapter = dio.httpClientAdapter;
    if (httpClientAdapter is DefaultHttpClientAdapter) {
      httpClientAdapter.onHttpClientCreate = (_) => HttpClient(
        context: securityContext,
      );
    }

    return dio;
  }



}

