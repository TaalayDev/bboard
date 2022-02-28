import 'package:bboard/controllers/product_controller.dart';
import 'package:bboard/resources/theme.dart';
import 'package:bboard/views/pages/category_products/category_products_controller.dart';
import 'package:bboard/views/widgets/category/category_slider.dart';
import 'package:bboard/views/widgets/custom_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:get/get.dart';

import '../../../tools/app_router.dart';
import '../../widgets/loading_more_widget.dart';
import '../../widgets/product/sliver_products_grid.dart';

class CategoryProductsPage extends StatelessWidget {
  CategoryProductsPage({Key? key}) : super(key: key);

  String _searchText = '';

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryProductsController>(
      init: CategoryProductsController(),
      builder: (controller) {
        return Scaffold(
          appBar: CustomSearchBar(
            onSearchTextChanged: (value) {
              _searchText = value;
            },
            onStopEditingSearchText: (value) {
              if (value.isEmpty) {
                controller.fetchCategoryProducts();
              }
            },
            onSearchPressed: () {
              controller.fetchCategoryProducts(search: _searchText);
            },
            backIcon: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: context.theme.onPrimary,
              ),
              onPressed: () {
                Get.back();
              },
            ),
          ),
          body: NestedScrollView(
            headerSliverBuilder: (context, _) => [
              if (controller.hist.isNotEmpty)
                SliverToBoxAdapter(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                    color: context.theme.surface,
                    child: BreadCrumb(
                      items: controller.hist
                          .map((e) => BreadCrumbItem(
                                content: Text(e.name),
                                onTap: () {
                                  controller
                                    ..clearHist()
                                    ..changeSelectedCategory(e)
                                    ..fetchCategoryProducts();
                                },
                              ))
                          .toList(),
                      divider: Icon(Icons.chevron_right),
                    ),
                  ),
                ),
              if (controller.category.children.isNotEmpty) ...[
                const SliverToBoxAdapter(child: SizedBox(height: 10)),
                SliverToBoxAdapter(
                  child: CategorySlider(
                    horizontalPadding: 10,
                    list: controller.category.children,
                    onTap: (category) {
                      controller
                        ..changeSelectedCategory(category)
                        ..fetchCategoryProducts();
                    },
                  ),
                ),
              ],
            ],
            body: RefreshIndicator(
              onRefresh: () async {
                controller.fetchCategoryProducts(search: _searchText);
              },
              child: NotificationListener<ScrollNotification>(
                onNotification: (scrollInfo) {
                  if (scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent) {
                    controller.fetchMoreCategoryProducts(search: _searchText);
                  }

                  return false;
                },
                child: controller.isFetchingProducts
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : CustomScrollView(
                        physics: const ClampingScrollPhysics(),
                        slivers: [
                          const SliverToBoxAdapter(child: SizedBox(height: 10)),
                          SliverPadding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            sliver: SliverProductGrid(
                              list: controller.products,
                              onTap: (product) {
                                Get.find<ProductController>().selectedProduct =
                                    product;
                                Get.toNamed(AppRouter.productDetails);
                              },
                            ),
                          ),
                          controller.isFetchingMore
                              ? SliverToBoxAdapter(
                                  child: Column(
                                    children: const [
                                      SizedBox(height: 20),
                                      LoadingMoreWidget(),
                                    ],
                                  ),
                                )
                              : const SliverToBoxAdapter(child: SizedBox()),
                          const SliverToBoxAdapter(child: SizedBox(height: 50)),
                        ],
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}
