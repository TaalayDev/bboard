import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../data/models/category.dart';
import '../data/repositories/category_repo.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit({required ICategoryRepo categoryRepo})
      : _categoryRepo = categoryRepo,
        super(const CategoryState());

  final ICategoryRepo _categoryRepo;

  void fetchCategories() async {
    emit(state.copyWith(isLoading: true));
    final response = await _categoryRepo.fetchCategoryTree();
    emit(state.copyWith(isLoading: false, categories: response.result));
  }
}
