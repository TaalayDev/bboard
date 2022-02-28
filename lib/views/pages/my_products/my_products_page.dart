import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';

import '../../../controllers/product_controller.dart';
import '../../../models/ads_menu_type.dart';
import '../../../resources/theme.dart';
import '../../../tools/app_router.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/product/sliver_products_grid.dart';
import '../../widgets/styled_app_dropdown.dart';
import 'my_products_page_controller.dart';

class MyProductsPage extends StatelessWidget {
  const MyProductsPage({Key? key}) : super(key: key);

  final menu = const [
    AdsMenuType(title: 'Активные', name: 'active', count: 0),
    AdsMenuType(title: 'Неактивные', name: 'inactive', count: 0),
    AdsMenuType(title: 'На модерации', name: 'moderation', count: 0),
    AdsMenuType(title: 'Отключено модератором', name: 'disabled', count: 0),
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyProductsPageController>(
      init: MyProductsPageController(),
      builder: (controller) {
        return Scaffold(
          appBar: const CustomAppBar(title: 'Мои объявления'),
          body: NestedScrollView(
            headerSliverBuilder: (context, _) => [
              SliverToBoxAdapter(
                child: Container(
                  decoration: BoxDecoration(color: context.theme.surface),
                  child: StyledAppDropDown<AdsMenuType>(
                    label: menu
                        .firstWhere(
                          (element) => element.name == controller.status,
                          orElse: () => menu[0],
                        )
                        .title,
                    color: context.theme.surface,
                    leading: const Icon(Feather.grid),
                    radius: 0,
                    list: menu,
                    displayItem: (item) => item.title,
                    onChanged: (value) {
                      controller
                        ..status = value.name
                        ..update();
                    },
                  ),
                ),
              ),
            ],
            body: RefreshIndicator(
              onRefresh: () async {
                controller.fetchUserProducts();
              },
              child: controller.isFetchingProducts
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : CustomScrollView(
                      slivers: [
                        const SliverToBoxAdapter(child: SizedBox(height: 15)),
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          sliver: SliverProductGrid(
                            list: controller.products
                                .where((element) =>
                                    element.status == controller.status)
                                .toList(),
                            onTap: (product) {
                              Get.find<ProductController>().selectedProduct =
                                  product;
                              Get.toNamed(AppRouter.productDetails);
                            },
                          ),
                        ),
                        const SliverToBoxAdapter(child: SizedBox(height: 30)),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }
}
