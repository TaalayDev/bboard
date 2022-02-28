import 'package:bboard/models/user_products_count.dart';
import 'package:dio/dio.dart';

import '../../models/app_reponse.dart';
import '../../models/user.dart';
import '../../repositories/base_repo.dart';

class UserRepo extends BaseRepo {
  Future<AppResponse<User>> login(String phone, String password) async {
    var model = AppResponse<User>();
    try {
      final response = await post('login', data: {
        'phone': phone,
        'password': password,
      });
      if (isOk(response)) {
        model.data = User.fromMap(response.data['data']);
        model.status = true;
      }
    } on DioError catch (e) {
      model.message = e.message;
      model.errorData = e.response?.data;
    }

    return model;
  }

  Future<AppResponse<User>> register(Map<String, dynamic> data) async {
    var model = AppResponse<User>();
    try {
      final response = await post('register', data: data);
      if (isOk(response)) {
        model.data = User.fromMap(response.data['data']);
        model.status = true;
      }
    } on DioError catch (e) {
      model.message = e.message;
      model.errorData = e.response?.data;
    }

    return model;
  }

  Future<AppResponse<User>> fetchUser({Map<String, dynamic>? params}) async {
    var model = AppResponse<User>();
    try {
      final response = await get('user', params: params);
      if (isOk(response) && response.data is Map) {
        model.data = response.data?['data'] != null
            ? User.fromMap(response.data['data'])
            : null;
        model.status = true;
      }
    } on DioError catch (e) {
      model.message = e.message;
      model.errorData = e.response?.data;
    }

    return model;
  }

  Future<AppResponse<User>> updateUser(FormData data) async {
    var model = AppResponse<User>();
    try {
      final response = await post('user', data: data);
      if (isOk(response) && response.data is Map) {
        model.data = response.data?['data'] != null
            ? User.fromMap(response.data['data'])
            : null;
        model.status = true;
      }
    } on DioError catch (e) {
      model.message = e.message;
      model.errorData = e.response?.data;
    }

    return model;
  }

  Future<AppResponse<UserProductsCount>> fetchUserProductsCount() async {
    var model = AppResponse<UserProductsCount>();
    try {
      final response = await get('user/products/count');
      if (isOk(response) && response.data is Map) {
        model.data = UserProductsCount.fromMap(response.data['data']);
        model.status = true;
      }
    } on DioError catch (e) {
      model.message = e.message;
      model.errorData = e.response?.data;
    }

    return model;
  }

  Future<AppResponse> changePassword(
      String newPassword, String repeatPassword) async {
    var model = AppResponse();
    try {
      final response = await post('user/changePassword', data: {
        'new_password': newPassword,
        'repeat_password': repeatPassword,
      });
      if (isOk(response) && response.data is Map) {
        model.status = true;
      }
    } on DioError catch (e) {
      model.message = e.message;
      model.errorData = e.response?.data;
    }
    return model;
  }
}
