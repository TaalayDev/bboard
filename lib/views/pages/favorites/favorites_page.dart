import 'package:bboard/views/pages/product_details/product_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';

import '../../../controllers/product_controller.dart';
import '../../../resources/theme.dart';
import '../../widgets/product/sliver_products_grid.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      Get.find<ProductController>().fetchFavorites();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          'favorites'.tr,
          style: TextStyle(
            color: Get.theme.onPrimary,
            fontSize: 16,
          ),
        ),
      ),
      body: GetBuilder<ProductController>(
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
                controller: ScrollController(),
                slivers: [
                  SliverProductGrid(
                    onTap: (product) {
                      Get.find<ProductController>().selectedProduct = product;
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ProductDetailsPage(),
                      ));
                    },
                    list: controller.favorites,
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 50),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
