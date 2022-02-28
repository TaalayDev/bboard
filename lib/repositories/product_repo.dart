import 'package:dio/dio.dart';

import '../models/app_reponse.dart';
import '../models/comment.dart';
import '../models/product.dart';
import '../tools/locale_storage.dart';
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
        'with': 'category;region;city;user;'
            'customAttributeValues.customAttribute;comments.user',
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

  Future<AppResponse<List<Product>>> fetchUserProducts({
    Map<String, dynamic>? params,
  }) async {
    var model = AppResponse<List<Product>>();
    try {
      final response = await get('user/products', params: params);
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

  Future<AppResponse> addToFavorites(int productId) async {
    var model = AppResponse();
    try {
      final response = await post('products/$productId/addtofav');
      if (isOk(response)) {
        model.status = true;
      }
    } on DioError catch (e) {
      model.errorData = e.response?.data;
    }
    return model;
  }

  Future<AppResponse> removeFromFavorites(int productId) async {
    var model = AppResponse();
    try {
      final response = await post('products/$productId/remfromfav');
      if (isOk(response)) {
        model.status = true;
      }
    } on DioError catch (e) {
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
      model.message = e.message;
      model.errorData = e.response?.data;
    }

    return model;
  }

  Future<AppResponse<List<Comment>>> fetchProductComments(int productId) async {
    var model = AppResponse<List<Comment>>();
    try {
      final params = {
        'search': 'advertisement_id:$productId',
        'searchFields': 'advertisement_id:=',
        'with': 'user;parent.user',
        'orderBy': 'created_at',
        'sortedBy': 'desc',
      };
      final response = await get('comments', params: params);
      if (isOk(response)) {
        model.data = Comment.fromList(response.data['data']);
        model.status = true;
      }
    } on DioError catch (e) {
      model.errorData = e.response?.data;
    }

    return model;
  }

  Future<AppResponse<Comment>> createComment({
    required String text,
    required int productId,
    int? parentId,
  }) async {
    var model = AppResponse<Comment>();
    try {
      final response = await post('comments', data: {
        'text': text,
        'advertisement_id': productId,
        'user_id': LocaleStorage.currentUser?.id,
        'parent_id': parentId,
      });
      if (isOk(response)) {
        model.data = Comment.fromMap(response.data['data']);
        model.status = true;
      }
    } on DioError catch (e) {
      model.errorData = e.response?.data;
    }

    return model;
  }

  Future<AppResponse<Comment>> removeComment(int commentId) async {
    var model = AppResponse<Comment>();
    try {
      final response = await delete('comments/$commentId');
      if (isOk(response)) {
        model.status = true;
      }
    } on DioError catch (e) {
      model.errorData = e.response?.data;
    }

    return model;
  }
}
