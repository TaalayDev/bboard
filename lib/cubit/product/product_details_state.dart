part of 'product_details_cubit.dart';

enum ProductDetailsStatus { pure, addFav, remFav }

class ProductDetailsState extends Equatable {
  const ProductDetailsState({
    required this.productId,
    this.isLoading = false,
    this.product,
    this.status = ProductDetailsStatus.pure,
  });

  final Product? product;
  final int productId;
  final bool isLoading;
  final ProductDetailsStatus status;

  ProductDetailsState copyWith({
    bool? isLoading,
    Product? product,
    ProductDetailsStatus? status,
  }) =>
      ProductDetailsState(
        productId: productId,
        isLoading: isLoading ?? this.isLoading,
        product: product ?? this.product,
        status: status ?? this.status,
      );

  @override
  List<Object?> get props => [productId, product, isLoading, status];
}
