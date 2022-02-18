import 'package:bboard/models/region.dart';
import 'package:dio/dio.dart';

import '../models/app_reponse.dart';
import '../models/currency.dart';
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
}
