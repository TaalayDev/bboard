part of 'favorites_cubit.dart';

class FavoritesState extends Equatable {
  const FavoritesState({
    this.isLoading = false,
    this.products = const [],
  });

  final bool isLoading;
  final List<Product> products;

  FavoritesState copyWith({
    bool? isLoading,
  }) => FavoritesState();

  @override
  List<Object> get props => [isLoading, products];
}
