import '../models/category.dart';
import '../repositories/category_repo.dart';

import 'package:get/get.dart';

class CategoryController extends GetxController {
  List<Category> categoryTree = [];
  Category? selectedCategory;
  List<Category> get showingCategories =>
      selectedCategory != null ? selectedCategory!.children : categoryTree;

  final List<Category> _stack = [];

  bool isFetchingCategoryTree = false;

  final _categoryRepo = Get.find<CategoryRepo>();

  void selectCategory(Category category) {
    selectedCategory = category;
    _stack.add(category);

    update();
  }

  Category? findInStack() {
    try {
      final result = _stack
          .firstWhere((element) => element.id == selectedCategory?.parentId);
      _stack.removeWhere((element) => element.id == result.id);
      return result;
    } catch (e) {
      return null;
    }
  }

  @override
  void onInit() {
    fetchCategoryTree();
    super.onInit();
  }

  void fetchCategoryTree() async {
    if (!isFetchingCategoryTree) {
      isFetchingCategoryTree = true;
      update();

      final appResponse = await _categoryRepo.fetchCategoryTree();
      if (appResponse.status) {
        categoryTree = appResponse.data!;
      }

      isFetchingCategoryTree = false;
      update();
    }
  }

  void unSelectCategory() {
    selectedCategory = null;
    update();
  }
}
