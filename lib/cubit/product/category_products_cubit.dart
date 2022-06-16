import 'package:get_it/get_it.dart';

import '../../data/data_provider.dart';
import '../../data/events/events.dart';
import '../../data/models/category.dart';
import '../../data/models/filter.dart';
import '../../data/models/product.dart';
import '../../data/repositories/category_repo.dart';
import '../../data/repositories/product_repo.dart';
import 'product_cubit.dart';

part 'category_products_state.dart';

class CategoryProductsCubit extends IProductCubit<CategoryProductsState>
    with ProdCubitMixin {
  CategoryProductsCubit({DataProvider? dataProvider})
      : _dataProvider = dataProvider,
        super(CategoryProductsState(category: dataProvider?.category.value)) {
    productEvents + productsListener;
  }

  DataProvider? _dataProvider;
  final _categoryRepo = GetIt.I.get<CategoryRepo>();
  final _productRepo = GetIt.I.get<ProductRepo>();

  void setSearchText(String text) {
    emit(state.copyWith(searchText: text));
  }

  void changeCategory(Category category) {
    emit(state
      ..copyWith(offset: 1)
      ..withCategory(category));
  }

  void fetchCategoryDetails(int id) async {
    final response = await _categoryRepo.fetchCategoryDetails(id);
    emit(state.withCategory(response.result));
  }

  Future<void> fetchCategoryProducts(int categoryId) async {
    emit(state.copyWith(isLoading: true));
    final response = await _productRepo.fetchProducts(
      params: {
        'with': 'user',
        'limit': state.limit,
        'offset': state.offset,
        'orderBy': 'created_at',
        'sortedBy': 'desc',
        'categories': '$categoryId',
        if (state.searchText != null && state.searchText!.isNotEmpty) ...{
          'search': 'title:${state.searchText};description:${state.searchText}',
          'searchFields': 'title:like;description:like',
        }
      },
    );
    emit(state.copyWith(
      isLoading: false,
      products: [...state.products, ...response.result ?? []],
      offset: response.status ? state.offset + state.limit : null,
    ));
  }

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
