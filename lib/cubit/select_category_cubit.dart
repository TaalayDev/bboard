import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';

import '../data/data_provider.dart';
import '../data/models/category.dart';
import '../data/repositories/category_repo.dart';

part 'select_category_state.dart';

class SelectCategoryCubit extends Cubit<SelectCategoryState> {
  SelectCategoryCubit({
    required ICategoryRepo categoryRepo,
    DataProvider? dataProvider,
  })  : _categoryRepo = categoryRepo,
        _dataProvider = dataProvider,
        super(const SelectCategoryState());

  final DataProvider? _dataProvider;
  final ICategoryRepo _categoryRepo;

  void selectCategory(Category category) {
    emit(state.copyWith(
      selectedCategory: category,
      stack: [...state.stack, category],
    ));
  }

  void unselectCategory() {
    emit(state.copyExceptCategory());
  }

  Category? findInStack() {
    try {
      final stack = state.stack;
      final result = stack.firstWhere(
          (element) => element.id == state.selectedCategory?.parentId);
      stack.removeWhere((element) => element.id == result.id);
      emit(state.copyWith(stack: stack));
      return result;
    } catch (e) {
      return null;
    }
  }

  void fetchCategoryTree() async {
    if (!state.isLoadingTree) {
      emit(state.copyWith(isLoadingTree: true));
      final response = await _categoryRepo.fetchCategoryTree();
      emit(state.copyWith(
        isLoadingTree: false,
        categoryTree: response.result,
      ));
    }
  }
}
