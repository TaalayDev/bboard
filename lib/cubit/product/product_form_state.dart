part of 'product_form_cubit.dart';

enum ProductFormStatus { none, success, error }

class ProductFormState extends Equatable {
  const ProductFormState({
    this.images = const [],
    this.currencies = const [],
    this.regions = const [],
    this.product,
    this.isLoadingProduct = false,
    this.category,
    this.isLoadingCategory = false,
    this.isLoading = false,
    this.status = ProductFormStatus.none,
    this.error,
  });

  final List<File> images;
  final List<Currency> currencies;
  final List<Region> regions;
  final Product? product;
  final bool isLoadingProduct;
  final Category? category;
  final bool isLoadingCategory;
  final bool isLoading;
  final ProductFormStatus status;
  final String? error;

  ProductFormState copyWith({
    List<File>? images,
    List<Currency>? currencies,
    List<Region>? regions,
    Product? product,
    bool? isLoadingProduct,
    Category? category,
    bool? isLoadingCategory,
    bool? isLoading,
    ProductFormStatus? status,
    String? error,
  }) =>
      ProductFormState(
        images: images ?? this.images,
        currencies: currencies ?? this.currencies,
        regions: regions ?? this.regions,
        product: product ?? this.product,
        isLoadingProduct: isLoadingProduct ?? this.isLoadingProduct,
        category: category ?? this.category,
        isLoadingCategory: isLoadingCategory ?? this.isLoadingCategory,
        isLoading: isLoading ?? this.isLoading,
        status: status ?? this.status,
        error: error ?? this.error,
      );

  @override
  List<Object?> get props => [
        images,
        currencies,
        regions,
        category,
        isLoadingCategory,
        product,
        isLoadingProduct,
        isLoading,
        status,
        error,
      ];
}
