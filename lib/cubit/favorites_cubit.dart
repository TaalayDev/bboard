import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';

import '../data/models/product.dart';
import '../data/repositories/product_repo.dart';

part 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit() : super(const FavoritesState());

  final _productRepo = GetIt.I.get<ProductRepo>();

  void fetchFavorites() async {
    final response = await _productRepo.fetchFavorites();
  }
}
