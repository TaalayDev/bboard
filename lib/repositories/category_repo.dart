import 'package:bboard/models/app_reponse.dart';
import 'package:bboard/models/category.dart';
import 'package:bboard/repositories/base_repo.dart';
import 'package:dio/dio.dart';

class CategoryRepo extends BaseRepo {
  Future<AppResponse<List<Category>>> fetchCategoryTree({
    Map<String, dynamic>? params,
  }) async {
    var model = AppResponse<List<Category>>();
    try {
      final response = await get('categories/tree', params: params);
      if (isOk(response)) {
        model = AppResponse.fromMap(response.data);
        model.data = Category.fromList(response.data['data']);
      }
    } on DioError catch (e) {
      model.message = e.message;
      model.errorData = e.response?.data;
    }

    return model;
  }

  Future<AppResponse<Category>> fetchCategoryDetails(int id) async {
    var model = AppResponse<Category>();
    try {
      final params = <String, dynamic>{
        'with': 'customAttribute',
        'parents': '1',
      };
      final response = await get('categories/$id', params: params);
      if (isOk(response)) {
        model = AppResponse.fromMap(response.data);
        model.data = Category.fromMap(response.data['data']);
      }
    } on DioError catch (e) {
      model.message = e.message;
      model.errorData = e.response?.data;
    }

    return model;
  }
}
