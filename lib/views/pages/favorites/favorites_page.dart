import 'package:bboard/controllers/product_controller.dart';
import 'package:bboard/views/widgets/app_icon.dart';
import 'package:bboard/views/widgets/product/sliver_products_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';

import '../../../resources/theme.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'favorites'.tr,
          style: TextStyle(
            color: Get.theme.onPrimary,
            fontSize: 16,
          ),
        ),
      ),
      body: GetBuilder<ProductController>(
        initState: (state) {
          WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
            state.controller?.fetchFavorites();
          });
        },
        builder: (controller) {
          if (controller.isFetchingFavorites) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Center(child: CircularProgressIndicator()),
              ],
            );
          }

          if (controller.favorites.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Feather.heart),
                  const SizedBox(height: 20),
                  Text(
                    'you dont have any favorites yet'.tr,
                    style: TextStyle(fontSize: 16, color: Get.theme.grey),
                  ),
                ],
              ),
            );
          }

          return NotificationListener<ScrollNotification>(
            onNotification: (scrollInfo) {
              if (scrollInfo.metrics.pixels ==
                  scrollInfo.metrics.maxScrollExtent) {}
              return false;
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 17),
              child: CustomScrollView(
                physics: const ClampingScrollPhysics(),
                slivers: [
                  SliverProductGrid(
                    list: controller.favorites,
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
