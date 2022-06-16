import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/data_provider.dart';
import '../../data/models/app_reponse.dart';
import '../../data/models/product.dart';
import '../../data/repositories/product_repo.dart';

part 'product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  ProductDetailsCubit(
    int productId, {
    required IProductRepo productRepo,
    DataProvider? dataProvider,
  })  : _productRepo = productRepo,
        super(ProductDetailsState(
          productId: productId,
          product: dataProvider?.product.value,
        ));

  final IProductRepo _productRepo;

  Future<void> fetchProductDetails() async {
    emit(state.copyWith(isLoading: true));
    final response = await _productRepo.fetchProduct(state.productId);
    emit(state.copyWith(isLoading: false, product: response.result));
  }

  Future<AppResponse> deleteProduct() async {
    return _productRepo.deleteProduct(state.productId);
  }

  Future<bool> addToFavorites() async {
    final product = state.product?.copyWith(isFavorite: true);
    emit(state.copyWith(product: product));
    final response = await _productRepo.addToFavorites(state.productId);
    emit(state.copyWith(status: ProductDetailsStatus.addFav));
    return response.result;
  }

  Future<bool> removeFromFavorites() async {
    final product = state.product?.copyWith(isFavorite: false);
    emit(state.copyWith(product: product));
    final response = await _productRepo.removeFromFavorites(state.productId);
    emit(state.copyWith(status: ProductDetailsStatus.remFav));
    return response.result;
  }
}
