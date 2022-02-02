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
}
