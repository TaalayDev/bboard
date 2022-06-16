import 'package:dio/dio.dart';

import '../api_client.dart';
import '../models/app_reponse.dart';
import '../models/register_model.dart';
import '../models/user.dart';
import '../models/user_products_count.dart';

class UserRepo {
  const UserRepo({required ApiClient client}) : _client = client;

  final ApiClient _client;

  Future<AppResponse<User>> login(String phone, String password) async {
    return _client.postModel(
      'login',
      data: {
        'phone': phone,
        'password': password,
      },
      decoder: (data) => User.fromMap(data),
    );
  }

  Future<AppResponse<User>> register(RegisterModel model) async {
    return _client.postModel(
      'register',
      data: model.toMap(),
      decoder: (data) => User.fromMap(data),
    );
  }

  Future<AppResponse<User>> fetchUser({Map<String, dynamic>? params}) async {
    return _client.getModel(
      'user',
      params: params,
      decoder: (data) => User.fromMap(data),
    );
  }

  Future<AppResponse<User>> updateUser(FormData data) async {
    var model = AppResponse<User>();
    try {
      final response = await _client.post('user', data: data);
      model.result = User.fromMap(response.data);
    } on DioError catch (e) {
      model.errorData = e.response?.data;
    }

    return model;
  }

  Future<AppResponse<UserProductsCount>> fetchUserProductsCount() async {
    return _client.getModel(
      'user/products/count',
      decoder: (data) => UserProductsCount.fromMap(data),
    );
  }

  Future<AppResponse> changePassword(
    String newPassword,
    String repeatPassword,
  ) async {
    return _client.postModel('user/changePassword', data: {
      'new_password': newPassword,
      'repeat_password': repeatPassword,
    });
  }

  Future<AppResponse> checkUserExists(String phone) async {
    return _client.getModel('user/check', decoder: (data) => data);
  }

  Future<AppResponse> sendDeviceToken(String deviceToken) async {
    return _client.postModel(
      'user/deviceToken',
      data: {'device_token': deviceToken},
    );
  }
}
