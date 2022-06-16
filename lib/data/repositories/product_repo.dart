import 'package:dio/dio.dart';

import '../api_client.dart';
import '../models/app_reponse.dart';
import '../models/comment.dart';
import '../models/product.dart';
import '../storage.dart';

class ProductRepo {
  const ProductRepo({required ApiClient client}) : _client = client;

  final ApiClient _client;

  Future<AppResponse<List<Product>>> fetchProducts({
    Map<String, dynamic>? params,
  }) {
    return _client.getModel<List<Product>>(
      'products',
      params: params,
      decoder: (data) => Product.fromList(data),
    );
  }

  Future<AppResponse<List<Product>>> fetchFavorites({
    Map<String, dynamic>? params,
  }) async {
    return _client.getModel(
      'favorites',
      params: params,
      decoder: (data) => Product.fromList(data),
    );
  }

  Future<AppResponse<Product>> fetchProduct(
    int id, {
    Map<String, dynamic>? params,
  }) async {
    return _client.getModel(
      'products/$id',
      params: params ??
          {
            'with': 'category;region;city;user;'
                'customAttributeValues.customAttribute;comments.user',
            'category_parents_tree': true,
          },
      decoder: (data) => Product.fromMap(data),
    );
  }

  Future<AppResponse> deleteProduct(int id) async {
    return _client.deleteModel('products/$id');
  }

  Future<AppResponse<List<Product>>> fetchUserProducts({
    Map<String, dynamic>? params,
  }) async {
    return _client.getModel(
      'user/products',
      params: params,
      decoder: (data) => Product.fromList(data),
    );
  }

  Future<AppResponse> addToFavorites(int productId) async {
    return _client.postModel('products/$productId/addtofav');
  }

  Future<AppResponse> removeFromFavorites(int productId) async {
    return _client.postModel('products/$productId/remfromfav');
  }

  Future<AppResponse<Product>> createProduct(Map<String, dynamic>? data) async {
    return _client.postModel<Product>(
      'products',
      data: FormData.fromMap(data ?? {}),
      decoder: (data) => Product.fromMap(data),
    );
  }

  Future<AppResponse<Product>> updateProduct(
    int id,
    Map<String, dynamic> data,
  ) async {
    return _client.postModel<Product>(
      'products/$id',
      data: FormData.fromMap({'_method': 'PATCH', ...data}),
      decoder: (data) => Product.fromMap(data),
    );
  }

  Future<AppResponse<List<Comment>>> fetchProductComments(int productId) async {
    final params = {
      'search': 'advertisement_id:$productId',
      'searchFields': 'advertisement_id:=',
      'with': 'user;parent.user',
      'orderBy': 'created_at',
      'sortedBy': 'desc',
    };
    return _client.getModel<List<Comment>>(
      'comments',
      params: params,
      decoder: (data) => Comment.fromList(data),
    );
  }

  Future<AppResponse<Comment>> createComment({
    required String text,
    required int productId,
    int? parentId,
  }) async {
    return _client.postModel('comments', data: {
      'text': text,
      'advertisement_id': productId,
      'user_id': LocaleStorage.currentUser?.id,
      'parent_id': parentId,
    });
  }

  Future<AppResponse<Comment>> removeComment(int commentId) async {
    return _client.deleteModel('comments/$commentId');
  }
}
