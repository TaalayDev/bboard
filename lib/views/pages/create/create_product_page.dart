import 'package:bboard/controllers/product_controller.dart';
import 'package:bboard/views/widgets/custom_app_bar.dart';
import 'package:bboard/views/widgets/product/product_fields.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateProductPage extends StatelessWidget {
  const CreateProductPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        backIcon: const Icon(Icons.close),
        title: 'Создать объявление',
      ),
      body: GetBuilder<ProductController>(builder: (controller) {
        return ProductFields(
          images: controller.images,
          onPickImagesTap: () {
            controller.pickImages();
          },
        );
      }),
    );
  }
}
