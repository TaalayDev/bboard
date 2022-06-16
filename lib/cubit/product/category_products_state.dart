part of 'category_products_cubit.dart';

class CategoryProductsState extends IProductState {
  const CategoryProductsState({
    this.category,
    List<Product> products = const [],
    this.searchText,
    bool isLoading = false,
    this.isLoadingCategory = false,
    int limit = 20,
    int offset = 1,
  }) : super(
            products: products,
            isLoading: isLoading,
            limit: limit,
            offset: offset);

  final Category? category;
  final String? searchText;
  final bool isLoadingCategory;

  @override
  CategoryProductsState copyWith({
    Filter? filter,
    List<Product>? products,
    String? searchText,
    bool? isLoading,
    bool? isLoadingMore,
    int? limit,
    int? offset,
  }) =>
      CategoryProductsState(
        category: category,
        products: products ?? this.products,
        searchText: searchText ?? this.searchText,
        isLoading: isLoading ?? this.isLoading,
        isLoadingCategory: isLoadingCategory,
        limit: limit ?? this.limit,
        offset: offset ?? this.offset,
      );

  CategoryProductsState withCategory(Category? category) =>
      CategoryProductsState(
        category: category ?? this.category,
        products: products,
        searchText: searchText,
        isLoading: isLoading,
        isLoadingCategory: isLoadingCategory,
        limit: limit,
        offset: offset,
      );

  @override
  List<Object?> get props => [
        category,
        products,
        searchText,
        isLoading,
        limit,
        offset,
        isLoadingCategory,
      ];
}
