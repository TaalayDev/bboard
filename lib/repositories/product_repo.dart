import 'package:dio/dio.dart';

import '../models/app_reponse.dart';
import '../models/product.dart';
import 'base_repo.dart';

class ProductRepo extends BaseRepo {
  Future<AppResponse<List<Product>>> fetchProducts({
    Map<String, dynamic>? params,
  }) async {
    var model = AppResponse<List<Product>>();
    try {
      final response = await get('products', params: params);
      if (isOk(response)) {
        model = AppResponse.fromMap(response.data);
        model.data = Product.fromList(response.data['data']);
      }
    } on DioError catch (e) {
      model.message = e.message;
      model.errorData = e.response?.data;
    }

    return model;
  }

  Future<AppResponse<List<Product>>> fetchFavorites({
    Map<String, dynamic>? params,
  }) async {
    var model = AppResponse<List<Product>>();
    try {
      final response = await get('favorites', params: params);
      if (isOk(response)) {
        model = AppResponse.fromMap(response.data);
        model.data = Product.fromList(response.data['data']);
      }
    } on DioError catch (e) {
      model.message = e.message;
      model.errorData = e.response?.data;
    }

    return model;
  }

  Future<AppResponse<Product>> fetchProduct(
    int id, {
    Map<String, dynamic>? params,
  }) async {
    var model = AppResponse<Product>();
    try {
      params ??= {
        'with':
            'category;region;city;user;customAttributeValues.customAttribute;comments',
        'category_parents_tree': true,
      };
      final response = await get('products/$id', params: params);
      if (isOk(response)) {
        model = AppResponse.fromMap(response.data);
        model.data = Product.fromMap(response.data['data']);
      }
    } on DioError catch (e) {
      model.message = e.message;
      model.errorData = e.response?.data;
    }

    return model;
  }

  Future<AppResponse<Product>> createProduct(Map<String, dynamic>? data) async {
    var model = AppResponse<Product>();
    try {
      final response =
          await post('products', data: FormData.fromMap(data ?? {}));
      if (isOk(response)) {
        model = AppResponse.fromMap(response.data);
        model.data = Product.fromMap(response.data['data']);
      }
    } on DioError catch (e) {
      print('error ${e.response?.data} ${e.message}');
      model.message = e.message;
      model.errorData = e.response?.data;
    }

    return model;
  }
}
