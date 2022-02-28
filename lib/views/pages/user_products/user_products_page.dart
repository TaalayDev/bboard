import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

import '../../../controllers/product_controller.dart';
import '../../../models/user.dart';
import '../../../resources/theme.dart';
import '../../../tools/app_router.dart';
import '../../widgets/app_network_image.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/product/sliver_products_grid.dart';
import 'user_products_page_controller.dart';

class UserProductsPage extends StatelessWidget {
  const UserProductsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserProductsPageController>(
      init: UserProductsPageController(),
      builder: (controller) {
        return Scaffold(
          appBar: const CustomAppBar(title: 'Профиль'),
          body: NestedScrollView(
            headerSliverBuilder: (context, _) => [
              const SliverToBoxAdapter(child: SizedBox(height: 15)),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                sliver: SliverToBoxAdapter(
                  child: UserCard(user: controller.user),
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
                  : NotificationListener<ScrollNotification>(
                      onNotification: (scrollInfo) {
                        if (scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent) {
                          controller.fetchMoreProducts();
                        }

                        return false;
                      },
                      child: CustomScrollView(
                        slivers: [
                          const SliverToBoxAdapter(child: SizedBox(height: 15)),
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
                          const SliverToBoxAdapter(child: SizedBox(height: 30)),
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

class UserCard extends StatelessWidget {
  const UserCard({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    final date = DateTime.tryParse(user.createdAt ?? '');
    final formatter = DateFormat('dd.MM.yyyy');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      margin: const EdgeInsets.only(bottom: 15),
      color: context.theme.surface,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        leading: SizedBox(
          height: 50,
          width: 50,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40.0),
            child: AppNetworkImage(
              imageUrl: user.media?.originalUrl ?? '',
            ),
          ),
        ),
        title: Text(
          user.name ?? '',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Row(
          children: [
            if (date != null)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                margin: const EdgeInsets.only(top: 5.0),
                child: Text(
                  'Зарегистрирован с ${formatter.format(date)}',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
