import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

import '../data/constants.dart';
import '../data/interceptors/auth_interceptor.dart';

final kCacheOptions = CacheOptions(
  store: MemCacheStore(),
  policy: CachePolicy.refresh,
  hitCacheOnErrorExcept: [401, 403],
  maxStale: const Duration(days: 7),
  priority: CachePriority.normal,
  cipher: null,
  keyBuilder: CacheOptions.defaultCacheKeyBuilder,
  allowPostMethod: false,
);

Dio initDio() {
  final _dio = Dio(BaseOptions(baseUrl: Constants.apiBaseUrl));
  _dio.interceptors.add(AuthInterceptor());
  _dio.interceptors.add(DioCacheInterceptor(options: kCacheOptions));

  return _dio;
}
