import 'package:bboard/models/category.dart';
import 'package:bboard/views/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/category_controller.dart';
import '../../../resources/constants.dart';
import '../../widgets/app_image.dart';
import '../../widgets/app_network_image.dart';
import '../../widgets/custom_app_bar.dart';

class SelectCategoryPage extends StatelessWidget {
  const SelectCategoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryController>(
      initState: (state) {
        WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
          state.controller?.unSelectCategory();
        });
      },
      builder: (controller) {
        return WillPopScope(
          onWillPop: () => onBackPressed(controller),
          child: Scaffold(
            appBar: CustomAppBar(
              title: 'Выберите категорию',
              backIcon: controller.selectedCategory == null
                  ? const Icon(Icons.close)
                  : null,
              onBackPressed: () => onBackPressed(controller),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Stack(
                children: [
                  CategoryList(
                    list: controller.showingCategories,
                    onTap: (index, category) {
                      if (category.children.isEmpty) {
                        Get.back(result: category);
                      }

                      controller.selectCategory(category);
                    },
                  ),
                  controller.selectedCategory != null
                      ? Positioned(
                          bottom: 10,
                          left: 0,
                          right: 0,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: AppButton(
                              text: 'Выбрать '
                                  '${controller.selectedCategory?.name}',
                              onPressed: () {
                                Get.back(result: controller.selectedCategory);
                              },
                            ),
                          ),
                        )
                      : SizedBox(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<bool> onBackPressed(CategoryController controller) async {
    if (controller.selectedCategory == null) {
      Get.back();
      return false;
    }

    final category = controller.findInStack();
    if (category != null) {
      controller.selectCategory(category);
    } else {
      controller.unSelectCategory();
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
        return ListTile(
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
        );
      },
      separatorBuilder: (context, index) => const Divider(height: 0),
      itemCount: list.length,
    );
  }
}
