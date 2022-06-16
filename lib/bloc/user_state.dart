part of 'user_bloc.dart';

class UserState extends Equatable {
  const UserState({
    this.isLogin = false,
    this.isFetchingUser = false,
    this.isFetchingProductsCount = false,
    this.user,
    this.productsCount,
    this.image,
  });

  final bool isLogin;
  final User? user;
  final bool isFetchingUser;
  final bool isFetchingProductsCount;
  final UserProductsCount? productsCount;
  final File? image;

  UserState copyWith({
    bool? isLogin,
    User? user,
    bool? isFetchingUser,
    bool? isFetchingProductsCount,
    UserProductsCount? productsCount,
    File? image,
  }) =>
      UserState(
        isLogin: isLogin ?? this.isLogin,
        user: user ?? this.user,
        isFetchingUser: isFetchingUser ?? this.isFetchingUser,
        isFetchingProductsCount:
            isFetchingProductsCount ?? this.isFetchingProductsCount,
        productsCount: productsCount ?? this.productsCount,
        image: image ?? this.image,
      );

  @override
  List<Object?> get props => [
        isLogin,
        isFetchingUser,
        user,
        isFetchingProductsCount,
        productsCount,
        image,
      ];
}
