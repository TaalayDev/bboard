import 'package:bboard/controllers/product_controller.dart';
import 'package:bboard/tools/locale_storage.dart';
import 'package:bboard/views/widgets/custom_app_bar.dart';
import 'package:bboard/views/widgets/product/product_fields.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../tools/app_router.dart';
import '../../widgets/form_builder.dart';

class CreateProductPage extends StatelessWidget {
  CreateProductPage({Key? key}) : super(key: key);

  final FormBuilderController formController = FormBuilderController(values: {
    'phones': [
      LocaleStorage.currentUser?.phone ?? '',
    ],
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        backIcon: Icon(Icons.close),
        title: 'Создать объявление',
      ),
      body: GetBuilder<ProductController>(
        initState: (state) {
          WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
            state.controller?.fetchCurrencies();
            formController.setValue(
              'category_id',
              state.controller?.selectedCategory?.id,
            );
            state.controller?.fetchRegions().then((value) {
              if (state.controller!.regions.isNotEmpty) {
                final region = state.controller!.regions[0];
                formController.setValue('region', state.controller!.regions[0]);
                if (region.cities != null && region.cities!.isNotEmpty) {
                  formController.setValue('city', region.cities![0]);
                }
              }
            });
          });
        },
        builder: (controller) {
          return ProductFields(
            formController: formController,
            images: controller.images,
            category: controller.selectedCategory,
            currencies: controller.currencies,
            regions: controller.regions,
            loadingCategory: controller.isFetchingCategory,
            isSending: controller.isLoading,
            onCategoryTap: () async {
              final category = await Get.toNamed(AppRouter.selectCategory);
              if (category != null) {
                controller.selectedCategory = category;
                formController.setValue('category_id', category.id);
              }
            },
            onPickImagesTap: controller.pickImages,
            onRemoveImage: controller.removeImage,
            onSendTap: (values) async {
              final result = await controller.createNewProduct(values);
              if (result.status) {
                controller.selectedProduct = result.data!;
                Get.offAndToNamed(AppRouter.productDetails);
              } else {
                Get.snackbar('app_title'.tr, 'Ошибка');
                print(
                    'product creating error ${result.errorData} ${result.status}');
              }
            },
          );
        },
      ),
    );
  }
}
