part of 'select_category_cubit.dart';

class SelectCategoryState extends Equatable {
  const SelectCategoryState({
    this.categoryTree = const [],
    this.selectedCategory,
    this.stack = const [],
    this.isLoadingTree = false,
  });

  final List<Category> categoryTree;
  final Category? selectedCategory;
  final List<Category> stack;
  final bool isLoadingTree;

  List<Category> get showingCategories =>
      selectedCategory != null ? selectedCategory!.children : categoryTree;

  SelectCategoryState copyWith({
    List<Category>? categoryTree,
    Category? selectedCategory,
    List<Category>? stack,
    bool? isLoadingTree,
  }) =>
      SelectCategoryState(
        categoryTree: categoryTree ?? this.categoryTree,
        selectedCategory: selectedCategory ?? this.selectedCategory,
        stack: stack ?? this.stack,
        isLoadingTree: isLoadingTree ?? this.isLoadingTree,
      );
  
SelectCategoryState copyExceptCategory() => SelectCategoryState(
  categoryTree: categoryTree,
  selectedCategory: null,
  stack: stack,
  isLoadingTree: isLoadingTree,
);

  @override
  List<Object?> get props =>
      [categoryTree, selectedCategory, stack, isLoadingTree];
}
