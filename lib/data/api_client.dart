import 'dart:async';

import 'package:bboard/helpers/network_helpers.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

import 'storage.dart';
import 'models/app_reponse.dart';

class ApiClient {
  ApiClient(this._dio);

  final Dio _dio;

  Future<Response<T>> get<T>(
    String url, {
    Map<String, dynamic>? params,
    Options? options,
  }) {
    return _dio.get<T>(url, queryParameters: params, options: options);
  }

  Future<AppResponse<T>> getModel<T>(
    String url, {
    required T Function(dynamic data) decoder,
    Map<String, dynamic>? params,
    CachePolicy? cachePolicy,
  }) =>
      requestModel<T>(
        url,
        'GET',
        decoder: decoder,
        params: params,
        policy: cachePolicy,
      );

  Future<Response<T>> post<T>(String url, {dynamic data, Options? options}) {
    return _dio.post(url, data: data, options: options);
  }

  Future<AppResponse<T>> postModel<T>(
    String url, {
    T Function(dynamic data)? decoder,
    dynamic data,
  }) =>
      requestModel<T>(
        url,
        'POST',
        decoder: decoder,
        data: data,
      );

  Future<Response<T>> put<T>(String url, {dynamic data, Options? options}) {
    return _dio.put<T>(url, data: data, options: options);
  }

  Future<AppResponse<T>> putModel<T>(
    String url, {
    T Function(dynamic data)? decoder,
    dynamic data,
  }) =>
      requestModel<T>(
        url,
        'PUT',
        decoder: decoder,
        params: data,
      );

  Future<Response<T>> patch<T>(String url, {dynamic data, Options? options}) {
    return _dio.patch<T>(url, data: data, options: options);
  }

  Future<AppResponse<T>> patchModel<T>(
    String url, {
    T Function(dynamic data)? decoder,
    dynamic data,
  }) =>
      requestModel(
        url,
        'PATCH',
        decoder: decoder,
        params: data,
      );

  Future<Response<T>> delete<T>(String url, {dynamic data, Options? options}) {
    return _dio.delete<T>(url, data: data, options: options);
  }

  Future<AppResponse<T>> deleteModel<T>(
    String url, {
    T Function(dynamic data)? decoder,
    dynamic data,
  }) =>
      requestModel(
        url,
        'DELETE',
        decoder: decoder,
        params: data,
      );

  Future<AppResponse<T>> requestModel<T>(
    String url,
    String method, {
    required T Function(dynamic data)? decoder,
    Map<String, dynamic>? params,
    dynamic data,
    CachePolicy? policy,
  }) async {
    final model = AppResponse<T>();
    try {
      final response = await _dio.request(
        url,
        queryParameters: params,
        data: data,
        options: kCacheOptions.copyWith(policy: policy).toOptions(),
      );
      model.statusCode = response.statusCode;
      if (response.data is Map && response.data['data'] != null) {
        model.result = decoder?.call(response.data['data']);
      }
    } on DioError catch (e) {
      model.statusCode = e.response?.statusCode;
      model.errorData = e.response?.data;
    }

    return model;
  }

  Future<void> _refreshToken() async {
    String? refreshToken = LocaleStorage.token;
    final response = await _dio
        .post('/account/token/refresh/', data: {'refresh': refreshToken});
    if (response.statusCode == 200 && response.data is Map) {
      LocaleStorage.token = response.data['access_token'];
    }
  }

  Future<void> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    await _dio.request<dynamic>(requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options);
  }
}
