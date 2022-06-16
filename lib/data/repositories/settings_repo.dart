import '../api_client.dart';
import '../models/app_reponse.dart';
import '../models/complaint.dart';
import '../models/complaint_type.dart';
import '../models/currency.dart';
import '../models/notification_model.dart';
import '../models/region.dart';

abstract class ISettingsRepo {
  Future<AppResponse<List<Currency>>> fetchCurrencies();

  Future<AppResponse<List<Region>>> fetchRegions();

  Future<AppResponse<List<NotificationModel>>> fetchNotifications({
    Map<String, dynamic>? params,
  });

  Future<AppResponse<List<ComplaintType>>> fetchComplaintTypes({
    Map<String, dynamic>? params,
  });

  Future<AppResponse<Complaint>> sendComplaint(Complaint complaint);
}

class SettingsRepo implements ISettingsRepo {
  const SettingsRepo({required ApiClient client}) : _client = client;

  final ApiClient _client;

  @override
  Future<AppResponse<List<Currency>>> fetchCurrencies() async {
    return _client.getModel(
      'currencies',
      decoder: (data) => List.from(data.map((e) => Currency.fromMap(e))),
    );
  }

  @override
  Future<AppResponse<List<Region>>> fetchRegions() async {
    return _client.getModel(
      'regions',
      params: {'with': 'cities.districts'},
      decoder: (data) => List.from(data.map((e) => Region.fromMap(e))),
    );
  }

  @override
  Future<AppResponse<List<NotificationModel>>> fetchNotifications({
    Map<String, dynamic>? params,
  }) async {
    return _client.getModel<List<NotificationModel>>(
      'notifications',
      params: params,
      decoder: (data) => List.from(
        data.map((e) => NotificationModel.fromMap(e)),
      ),
    );
  }

  @override
  Future<AppResponse<List<ComplaintType>>> fetchComplaintTypes({
    Map<String, dynamic>? params,
  }) async {
    return _client.getModel(
      'complaints/types',
      params: params,
      decoder: (data) => List.from(data.map((e) => ComplaintType.fromMap(e))),
    );
  }

  @override
  Future<AppResponse<Complaint>> sendComplaint(Complaint complaint) async {
    return _client.postModel(
      'complaints',
      data: complaint.toMap(),
      decoder: (data) => Complaint.fromMap(data),
    );
  }
}
