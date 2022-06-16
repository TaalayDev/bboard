import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:go_router/go_router.dart';

import '../../../cubit/product/product_cubit.dart';
import '../../../data/data_provider.dart';
import '../../../res/routes.dart';
import '../../../res/theme.dart';
import '../../../data/models/ads_menu_type.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/product/sliver_products_grid.dart';
import '../../widgets/styled_app_dropdown.dart';

class MyProductsScreen extends StatefulWidget {
  const MyProductsScreen({
    Key? key,
    this.initialStatus,
  }) : super(key: key);

  final String? initialStatus;

  @override
  State<MyProductsScreen> createState() => _MyProductsScreenState();
}

class _MyProductsScreenState extends State<MyProductsScreen> {
  final menu = const [
    AdsMenuType(title: 'Активные', name: 'active', count: 0),
    AdsMenuType(title: 'Неактивные', name: 'inactive', count: 0),
    AdsMenuType(title: 'На модерации', name: 'moderation', count: 0),
    AdsMenuType(title: 'Отключено модератором', name: 'disabled', count: 0),
  ];

  String status = '';

  @override
  void initState() {
    status = widget.initialStatus ?? 'active';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductCubit()..fetchCurrentUserProducts(),
      child: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
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
                            (element) => element.name == status,
                            orElse: () => menu[0],
                          )
                          .title,
                      color: context.theme.surface,
                      leading: const Icon(Feather.grid),
                      radius: 0,
                      list: menu,
                      displayItem: (item) => item.title,
                      onChanged: (value) {
                        setState(() => status = value.name);
                      },
                    ),
                  ),
                ),
              ],
              body: RefreshIndicator(
                onRefresh: () async {
                  context.read<ProductCubit>().fetchCurrentUserProducts();
                },
                child: state.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : CustomScrollView(
                        slivers: [
                          const SliverToBoxAdapter(child: SizedBox(height: 15)),
                          SliverPadding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            sliver: SliverProductGrid(
                              list: state.products.where((element) {
                                return element.status == status;
                              }).toList(),
                              onTap: (product) {
                                context
                                  ..read<DataProvider>().product.value = product
                                  ..push(Routes.productDetails(product.id));
                              },
                              onHeartTap: (product) {
                                if (product.isFavorite) {
                                  context
                                      .read<ProductCubit>()
                                      .removeFromFavorites(product.id);
                                } else {
                                  context
                                      .read<ProductCubit>()
                                      .addToFavorites(product.id);
                                }
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
      ),
    );
  }
}
