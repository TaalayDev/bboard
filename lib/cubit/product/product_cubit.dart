import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';

import '../../data/events/events.dart';
import '../../data/events/product_events.dart';
import '../../data/models/filter.dart';
import '../../data/repositories/product_repo.dart';
import '../../data/models/product.dart';

part 'product_state.dart';
part 'product_cubit_mixin.dart';

abstract class IProductCubit<T extends IProductState> extends Cubit<T> {
  IProductCubit(T state) : super(state);
}

class ProductCubit extends IProductCubit<ProductState> with ProdCubitMixin {
  ProductCubit() : super(const ProductState()) {
    productEvents + productsListener;
  }

  final _productRepo = GetIt.I.get<ProductRepo>();

  void fetchFavorites() async {
    emit(state.copyWith(isLoading: true));
    final response = await _productRepo.fetchFavorites();
    emit(state.copyWith(isLoading: false, products: response.result));
  }

  void fetchCurrentUserProducts() async {
    if (state.isLoading) return;

    emit(state.copyWith(isLoading: true));
    final response = await _productRepo.fetchUserProducts(params: {
      'limit': state.limit,
      'offset': state.offset,
    });
    emit(state.copyWith(
      isLoading: false,
      products: response.result,
      offset: state.offset + state.limit,
    ));
  }

  Future<void> fetchUserProducts(int userId) async {
    if (state.isLoading) return;

    emit(state.copyWith(isLoading: true));
    final response = await _productRepo.fetchProducts(params: {
      'search': 'user_id:$userId',
      'searchFields': 'user_id:=',
      'limit': state.limit,
      'offset': state.offset
    });
    emit(state.copyWith(
      isLoading: false,
      offset: state.offset + state.limit,
      products: List.from(state.products)..addAll(response.result ?? []),
    ));
  }

  void fetchProducts({String? search}) async {
    if (state.isLoading) return;

    emit(state.copyWith(isLoading: true));
    final response = await _productRepo.fetchProducts(params: {
      ...state.filter?.copyWith(text: search).toMap() ?? {'search': search},
      'limit': state.limit,
      'offset': state.offset,
    });
    emit(state.copyWith(
      isLoading: false,
      offset: state.offset + state.limit,
      products: List.from(state.products)..addAll(response.result ?? []),
    ));
  }

  void fetchMoreProducts({String? search}) async {}

  Future<bool> addToFavorites(int id) async {
    final index = indexOfProduct(id);
    emit(state.copyWith(
      products: List.from(state.products)
        ..[index] = state.products[index].copyWith(isFavorite: true),
    ));
    final response = await _productRepo.addToFavorites(id);
    return response.status;
  }

  Future<bool> removeFromFavorites(int id) async {
    final index = indexOfProduct(id);
    emit(state.copyWith(
      products: List.from(state.products)
        ..[index] = state.products[index].copyWith(isFavorite: false),
    ));
    final response = await _productRepo.removeFromFavorites(id);
    return response.status;
  }

  @override
  Future<void> close() {
    productEvents - productsListener;
    return super.close();
  }
}
