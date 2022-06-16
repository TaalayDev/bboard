import 'package:bboard/res/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubit/select_category_cubit.dart';
import '../../../data/constants.dart';
import '../../../data/models/category.dart';
import '../../widgets/animated_list_item.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_image.dart';
import '../../widgets/app_network_image.dart';
import '../../widgets/custom_app_bar.dart';

class SelectCategoryScreen extends StatelessWidget {
  const SelectCategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SelectCategoryCubit(categoryRepo: getIt.get())..fetchCategoryTree(),
      child: BlocBuilder<SelectCategoryCubit, SelectCategoryState>(
        builder: (context, state) {
          return WillPopScope(
            onWillPop: () => onBackPressed(context.read<SelectCategoryCubit>()),
            child: Scaffold(
              appBar: CustomAppBar(
                title: 'Выберите категорию',
                backIcon: state.selectedCategory == null
                    ? const Icon(Icons.close)
                    : null,
                onBackPressed: () => Navigator.pop(context),
              ),
              body: state.isLoadingTree
                  ? const Center(
                      child: CircularProgressIndicator.adaptive(),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Stack(
                        children: [
                          CategoryList(
                            list: state.showingCategories,
                            onTap: (index, category) {
                              if (category.children.isEmpty) {
                                Navigator.pop(context, category);
                              }

                              context
                                  .read<SelectCategoryCubit>()
                                  .selectCategory(category);
                            },
                          ),
                          state.selectedCategory != null
                              ? Positioned(
                                  bottom: 10,
                                  left: 0,
                                  right: 0,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    child: AppButton(
                                      text: 'Выбрать '
                                          '${state.selectedCategory?.name}',
                                      onPressed: () {
                                        Navigator.pop(
                                            context, state.selectedCategory);
                                      },
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }

  Future<bool> onBackPressed(SelectCategoryCubit cubit) async {
    if (cubit.state.selectedCategory == null) {
      return false;
    }

    final category = cubit.findInStack();
    if (category != null) {
      cubit.selectCategory(category);
    } else {
      cubit.unselectCategory();
    }

    return false;
  }
}

class CategoryList extends StatelessWidget {
  const CategoryList({
    Key? key,
    required this.list,
    this.onTap,
  }) : super(key: key);

  final List<Category> list;
  final Function(int index, Category category)? onTap;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        final category = list[index];
        return AnimatedListItem(
          index: index,
          duration: const Duration(milliseconds: 100),
          child: ListTile(
            onTap: () => onTap?.call(index, category),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
            leading: category.parentId != null
                ? null
                : category.media?.originalUrl != null
                    ? Container(
                        constraints: const BoxConstraints(maxWidth: 40),
                        child: AppNetworkImage(
                          imageUrl: category.media!.originalUrl!,
                        ),
                      )
                    : const CircleAvatar(child: AppImage(Assets.icon)),
            title: Text(category.name),
            trailing: category.children.isEmpty
                ? null
                : const Icon(Icons.arrow_forward_ios),
          ),
        );
      },
      separatorBuilder: (context, index) => const Divider(height: 0),
      itemCount: list.length,
    );
  }
}
