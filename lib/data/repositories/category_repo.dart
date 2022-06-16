import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

import '../api_client.dart';
import '../models/app_reponse.dart';
import '../models/category.dart';

class CategoryRepo {
  const CategoryRepo({required ApiClient client}) : _client = client;

  final ApiClient _client;

  Future<AppResponse<List<Category>>> fetchCategoryTree({
    Map<String, dynamic>? params,
  }) async {
    return _client.getModel<List<Category>>(
      'categories/tree',
      params: params,
      decoder: (data) => Category.fromList(data),
      cachePolicy: CachePolicy.request,
    );
  }

  Future<AppResponse<Category>> fetchCategoryDetails(int id) async {
    return _client.getModel(
      'categories/$id',
      params: {
        'with': 'customAttribute',
        'parents': '1',
      },
      decoder: (data) => Category.fromMap(data),
      cachePolicy: CachePolicy.request,
    );
  }
}
