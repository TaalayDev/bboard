import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

import '../api_client.dart';
import '../models/app_reponse.dart';
import '../models/category.dart';

abstract class ICategoryRepo {
  Future<AppResponse<List<Category>>> fetchCategoryTree({
    Map<String, dynamic>? params,
  });

  Future<AppResponse<Category>> fetchCategoryDetails(int id);
}

class CategoryRepo implements ICategoryRepo {
  const CategoryRepo({required ApiClient client}) : _client = client;

  final ApiClient _client;

  @override
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

  @override
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
