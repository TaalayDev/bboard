import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../data/models/product.dart';
import '../data/models/user.dart';

part 'user_products_state.dart';

class UserProductsCubit extends Cubit<UserProductsState> {
  UserProductsCubit() : super(const UserProductsState());

  void fetchUserDetails(int id) {}
}
