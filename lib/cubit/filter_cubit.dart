import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';

import '../data/data_provider.dart';
import '../data/models/category.dart';
import '../data/models/filter.dart';
import '../data/models/region.dart';
import '../data/repositories/product_repo.dart';
import '../data/repositories/settings_repo.dart';

part 'filter_state.dart';

class FilterCubit extends Cubit<FilterState> {
  FilterCubit({Filter? filter})
      : super(FilterState(
          filter: filter,
        ));

  final _settingRepo = GetIt.I<SettingsRepo>();
  final _productRepo = GetIt.I<ProductRepo>();

  void addToFilter({
    int? categoryId,
    int? regionId,
    String? sortBy,
    bool? hasPhoto,
    bool? hasVideo,
    String? text,
    Category? category,
    Region? region,
  }) {
    final filter = (state.filter ?? Filter());
    emit(state.copyWith(
      filter: filter.copyWith(
        categoryId: categoryId,
        regionId: regionId,
        sortBy: sortBy,
        hasPhoto: hasPhoto,
        hasVideo: hasVideo,
        text: text,
        category: category,
        region: region,
      ),
    ));
    fetchResults();
  }

  void clearFilter() {
    emit(state.copyWith(filter: Filter()));
  }

  void fetchRegions() async {
    emit(state.copyWith(isLoadingRegion: true));
    final response = await _settingRepo.fetchRegions();
    emit(state.copyWith(isLoadingRegion: false, regions: response.result));
  }

  void fetchResults() async {
    emit(state.copyWith(isLoadingResults: true));
    final response = await _productRepo.fetchProducts(
      params: state.filter?.toMap(),
    );
    emit(state.copyWith(
      isLoadingResults: false,
      resultsCount: response.result?.length,
    ));
  }
}
