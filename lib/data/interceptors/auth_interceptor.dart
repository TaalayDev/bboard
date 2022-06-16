import 'dart:io';

import 'package:dio/dio.dart';

import '../storage.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (LocaleStorage.token != null) {
      options.headers[HttpHeaders.authorizationHeader] =
          'Bearer ${LocaleStorage.token}';
    }

    return handler.next(options);
  }

  @override
  void onError(DioError error, ErrorInterceptorHandler handler) {
    try {
      final statusCode = error.response?.statusCode;
      if (statusCode == 401) {
        /*
          await _refreshToken();
          await _retry(error.requestOptions, dio);
        */
        handler.next(error);
      } else {
        handler.next(error);
      }
    } catch (e) {
      handler.next(error);
    }
  }
}
