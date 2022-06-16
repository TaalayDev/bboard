import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../data/models/product.dart';
import '../data/repositories/product_repo.dart';

part 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit({required IProductRepo productRepo})
      : _productRepo = productRepo,
        super(const FavoritesState());

  final IProductRepo _productRepo;

  void fetchFavorites() async {
    final response = await _productRepo.fetchFavorites();
  }
}
