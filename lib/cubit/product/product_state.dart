part of 'product_cubit.dart';

abstract class IProductState extends Equatable {
  const IProductState({
    this.products = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.offset = 1,
    this.limit = 10,
    this.filter,
  });

  final List<Product> products;
  final bool isLoading;
  final bool isLoadingMore;
  final int offset;
  final int limit;
  final Filter? filter;

  IProductState copyWith({
    List<Product>? products,
    bool? isLoading,
    bool? isLoadingMore,
    int? offset,
    Filter? filter,
  });

  @override
  List<Object?> get props => [];
}

class ProductState extends IProductState {
  const ProductState({
    List<Product> products = const [],
    bool isLoading = false,
    bool isLoadingMore = false,
    int offset = 1,
    int limit = 10,
    Filter? filter,
  }) : super(
          products: products,
          isLoading: isLoading,
          isLoadingMore: isLoadingMore,
          offset: offset,
          filter: filter,
        );

  @override
  ProductState copyWith({
    List<Product>? products,
    bool? isLoading,
    bool? isLoadingMore,
    int? offset,
    Filter? filter,
  }) =>
      ProductState(
        products: products ?? this.products,
        isLoading: isLoading ?? this.isLoading,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
        offset: offset ?? this.offset,
        filter: filter ?? this.filter,
      );

  @override
  List<Object?> get props =>
      [products, isLoading, isLoadingMore, offset, filter];
}
