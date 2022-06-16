part of 'product_cubit.dart';

mixin ProdCubitMixin<T extends IProductState> on IProductCubit<T> {
  void productsListener(ProductEvent? event) {
    if (event != null) {
      switch (event.type) {
        case ProductEventType.update:
          updateProductOnList(event.product);
          break;
        case ProductEventType.delete:
          removeProductFromList(event.product.id);
          break;
      }
    }
  }

  int indexOfProduct(int productId) {
    return state.products.indexWhere(
      (element) => element.id == productId,
    );
  }

  void removeProductFromList(int id) async {
    if (indexOfProduct(id) != -1) {
      emit(state.copyWith(
        products: List.from(
          state.products..removeWhere((element) => element.id == id),
        ),
      ) as T);
    }
  }

  void addProductToListIfNotExists(Product product) {
    if (indexOfProduct(product.id) == -1) {
      emit(state.copyWith(products: [...state.products, product]) as T);
    }
  }

  void updateProductOnList(Product product) {
    final index = indexOfProduct(product.id);
    if (index != -1) {
      emit(state.copyWith(
        products: List.from(state.products)..[index] = product,
      ) as T);
    }
  }

  void clearOffset() {
    emit((state.copyWith(offset: 1, products: []) as T));
  }

  void addFilter(Filter filter) {
    emit(state.copyWith(filter: filter) as T);
  }

  void clearFilter() {
    emit(state.copyWith(filter: Filter()) as T);
  }
}
