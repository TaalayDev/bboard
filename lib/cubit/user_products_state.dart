part of 'user_products_cubit.dart';

class UserProductsState extends Equatable {
  const UserProductsState({
    this.user,
    this.products = const [],
  });

  final User? user;
  final List<Product> products;

  @override
  List<Object?> get props => [user, products];
}
