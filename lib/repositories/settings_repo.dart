import 'package:bboard/models/complaint.dart';
import 'package:bboard/models/complaint_type.dart';
import 'package:bboard/models/region.dart';
import 'package:dio/dio.dart';

import '../models/app_reponse.dart';
import '../models/currency.dart';
import '../models/notification_model.dart';
import 'base_repo.dart';

class SettingsRepo extends BaseRepo {
  Future<AppResponse<List<Currency>>> fetchCurrencies() async {
    var model = AppResponse<List<Currency>>();
    try {
      final response = await get('currencies');
      if (isOk(response)) {
        model = AppResponse.fromMap(response.data);
        model.data =
            List.from(response.data['data'].map((e) => Currency.fromMap(e)));
      }
    } on DioError catch (e) {
      model.message = e.message;
      model.errorData = e.response?.data;
    }

    return model;
  }

  Future<AppResponse<List<Region>>> fetchRegions() async {
    var model = AppResponse<List<Region>>();
    try {
      final response =
          await get('regions', params: {'with': 'cities.districts'});
      if (isOk(response)) {
        model = AppResponse.fromMap(response.data);
        model.data =
            List.from(response.data['data'].map((e) => Region.fromMap(e)));
      }
    } on DioError catch (e) {
      model.message = e.message;
      model.errorData = e.response?.data;
    }

    return model;
  }

  Future<AppResponse<List<NotificationModel>>> fetchNotifications({
    Map<String, dynamic>? params,
  }) async {
    var model = AppResponse<List<NotificationModel>>();
    try {
      final response = await get('notifications', params: params);
      if (isOk(response)) {
        model = AppResponse.fromMap(response.data);
        model.data = List.from(
            response.data['data'].map((e) => NotificationModel.fromMap(e)));
      }
    } on DioError catch (e) {
      model.message = e.message;
      model.errorData = e.response?.data;
    }

    return model;
  }

  Future<AppResponse<List<ComplaintType>>> fetchComplaintTypes({
    Map<String, dynamic>? params,
  }) async {
    var model = AppResponse<List<ComplaintType>>();
    try {
      final response = await get('complaints/types', params: params);
      if (isOk(response)) {
        model = AppResponse.fromMap(response.data);
        model.data = List.from(
            response.data['data'].map((e) => ComplaintType.fromMap(e)));
      }
    } on DioError catch (e) {
      model.message = e.message;
      model.errorData = e.response?.data;
    }

    return model;
  }

  Future<AppResponse<Complaint>> sendComplaint(Complaint complaint) async {
    var model = AppResponse<Complaint>();
    try {
      final response = await post('complaints', data: complaint.toMap());
      if (isOk(response)) {
        model = AppResponse.fromMap(response.data);
        model.data = Complaint.fromMap(response.data['data']);
      }
    } on DioError catch (e) {
      model.message = e.message;
      model.errorData = e.response?.data;
    }

    return model;
  }
}
