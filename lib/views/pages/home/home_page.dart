import 'package:bboard/tools/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';

import '../../../controllers/category_controller.dart';
import '../../../controllers/product_controller.dart';
import '../../widgets/product/sliver_products_grid.dart';
import '../../../resources/theme.dart';
import '../../widgets/category/category_slider.dart';
import '../../widgets/loading_more_widget.dart';
import '../../widgets/bottom_navigation.dart';
import 'home_page_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        elevation: 0.0,
        title: SizedBox(
          height: 40,
          child: TextField(
            decoration: InputDecoration(
              fillColor: AppTheme.theme.onPrimaryColor,
              filled: true,
              prefixIcon: const Icon(Feather.search),
              hintText: 'Я ищу...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Feather.search, size: 30),
          ),
          const SizedBox(width: 15),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Get.find<ProductController>().fetchProducts();
        },
        child: NotificationListener<ScrollNotification>(
          onNotification: (scrollInfo) {
            if (scrollInfo.metrics.pixels ==
                scrollInfo.metrics.maxScrollExtent) {
              Get.find<ProductController>().fetchMoreProducts();
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
