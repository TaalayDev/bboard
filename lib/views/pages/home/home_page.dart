import 'package:bboard/tools/app_router.dart';
import 'package:bboard/views/widgets/custom_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/category_controller.dart';
import '../../../controllers/product_controller.dart';
import '../../widgets/product/sliver_products_grid.dart';
import '../../widgets/category/category_slider.dart';
import '../../widgets/loading_more_widget.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final TextEditingController searchFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomSearchBar(
        textController: searchFieldController,
        onSearchPressed: () {
          Get.find<ProductController>()
              .fetchProducts(search: searchFieldController.text);
        },
        onStopEditingSearchText: (value) {
          if (value.isEmpty) {
            Get.find<ProductController>().fetchProducts();
          }
        },
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Get.find<ProductController>()
              .fetchProducts(search: searchFieldController.text);
        },
        child: NotificationListener<ScrollNotification>(
          onNotification: (scrollInfo) {
            if (scrollInfo.metrics.pixels ==
                scrollInfo.metrics.maxScrollExtent) {
              Get.find<ProductController>()
                  .fetchMoreProducts(search: searchFieldController.text);
            }

            return false;
          },
          child: CustomScrollView(
            physics: const ClampingScrollPhysics(),
            slivers: [
              const SliverToBoxAdapter(child: SizedBox(height: 10)),
              SliverToBoxAdapter(
                child: GetBuilder<CategoryController>(
                  builder: (controller) => CategorySlider(
                    horizontalPadding: 20,
                    list: controller.categoryTree,
                    onTap: (category) {
                      Get.toNamed(
                        AppRouter.categoryProducts,
                        arguments: category,
                      );
                    },
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 20)),
              GetBuilder<ProductController>(
                initState: (state) {
                  WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
                    state.controller?.fetchProducts();
                  });
                },
                builder: (controller) {
                  return controller.isFetchingProducts
                      ? SliverToBoxAdapter(
                          child: Column(
                            children: const [
                              CircularProgressIndicator(),
                            ],
                          ),
                        )
                      : SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          sliver: SliverProductGrid(
                            list: controller.products,
                            onTap: (product) {
                              controller.selectedProduct = product;
                              Get.toNamed(AppRouter.productDetails);
                            },
                          ),
                        );
                },
              ),
              GetBuilder<ProductController>(
                builder: (controller) => controller.isFetchingMore
                    ? SliverToBoxAdapter(
                        child: Column(
                          children: const [
                            SizedBox(height: 20),
                            LoadingMoreWidget(),
                          ],
                        ),
                      )
                    : const SliverToBoxAdapter(child: SizedBox()),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 50)),
            ],
          ),
        ),
      ),
    );
  }
}
