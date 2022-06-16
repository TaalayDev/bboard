part of 'filter_cubit.dart';

class FilterState extends Equatable {
  const FilterState({
    this.filter,
    this.regions = const [],
    this.resultsCount,
    this.isLoadingCategory = false,
    this.isLoadingRegion = false,
    this.isLoadingResults = false,
  });

  final Filter? filter;
  final List<Region> regions;
  final int? resultsCount;
  final bool isLoadingResults;
  final bool isLoadingCategory;
  final bool isLoadingRegion;

  FilterState copyWith({
    Filter? filter,
    List<Region>? regions,
    int? resultsCount,
    bool? isLoadingResults,
    bool? isLoadingCategory,
    bool? isLoadingRegion,
  }) =>
      FilterState(
        filter: filter ?? this.filter,
        regions: regions ?? this.regions,
        resultsCount: resultsCount ?? this.resultsCount,
        isLoadingCategory: isLoadingCategory ?? this.isLoadingCategory,
        isLoadingRegion: isLoadingRegion ?? this.isLoadingRegion,
        isLoadingResults: isLoadingResults ?? this.isLoadingResults,
      );

  @override
  List<Object?> get props => [
        filter,
        regions,
        resultsCount,
        isLoadingCategory,
        isLoadingRegion,
        isLoadingResults,
      ];
}
