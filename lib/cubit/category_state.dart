part of 'category_cubit.dart';

class CategoryState extends Equatable {
  const CategoryState({
    this.categories = const [],
    this.isLoading = false,
  });

  final List<Category> categories;
  final bool isLoading;

  CategoryState copyWith({
    List<Category>? categories,
    bool? isLoading,
  }) =>
      CategoryState(
        categories: categories ?? this.categories,
        isLoading: isLoading ?? this.isLoading,
      );

  @override
  List<Object> get props => [categories, isLoading];
}
