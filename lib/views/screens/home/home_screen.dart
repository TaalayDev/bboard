import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../data/data_provider.dart';
import '../../../res/globals.dart';
import '../../widgets/animated_list_item.dart';
import '../search/search_screen.dart';

import '../../../cubit/category_cubit.dart';
import '../../../cubit/product/product_cubit.dart';
import '../../../res/routes.dart';
import '../../widgets/custom_search_bar.dart';
import '../../widgets/product/sliver_products_grid.dart';
import '../../widgets/category/category_slider.dart';
import '../../widgets/loading_more_widget.dart';
import '../../widgets/refresher.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final TextEditingController searchFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ProductCubit(
            productRepo: getIt.get(),
          )..fetchProducts(),
        ),
        BlocProvider(
          create: (context) => CategoryCubit(
            categoryRepo: getIt.get(),
          )..fetchCategories(),
        ),
      ],
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: CustomSearchBar(
            textController: searchFieldController,
            onSearchPressed: () async {
              final result = await Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => SearchScreen(
                  filter: context.read<ProductCubit>().state.filter,
                ),
              ));
              if (result != null) {
                context.read<ProductCubit>()
                  ..clearOffset()
                  ..addFilter(result)
                  ..fetchProducts();
              }
            },
            onStopEditingSearchText: (value) {
              context.read<ProductCubit>()
                ..clearOffset()
                ..fetchProducts(search: value);
            },
          ),
          body: NotificationListener<ScrollNotification>(
            onNotification: (scrollInfo) {
              if (scrollInfo.metrics.pixels ==
                  scrollInfo.metrics.maxScrollExtent) {
                context
                    .read<ProductCubit>()
                    .fetchProducts(search: searchFieldController.text);
              }

              return false;
            },
            child: Refresher(
              onRefresh: (controller) async {
                context
                    .read<ProductCubit>()
                    .fetchProducts(search: searchFieldController.text);
                controller.refreshCompleted();
              },
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  const SliverToBoxAdapter(child: SizedBox(height: 10)),
                  SliverToBoxAdapter(
                    child: BlocBuilder<CategoryCubit, CategoryState>(
                      builder: (context, state) => AnimatedListItem(
                        index: 0,
                        child: CategorySlider(
                          horizontalPadding: 20,
                          list: state.categories,
                          onTap: (category) {
                            context.push(Routes.categoryProducts(category.id));
                          },
                        ),
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 20)),
                  BlocBuilder<ProductCubit, ProductState>(
                    builder: (context, state) {
                      return state.isLoading && state.offset <= 1
                          ? SliverToBoxAdapter(
                              child: Column(
                                children: const [
                                  CircularProgressIndicator(),
                                ],
                              ),
                            )
                          : SliverPadding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              sliver: SliverProductGrid(
                                list: state.products,
                                onTap: (product) {
                                  context
                                    ..read<DataProvider>().product.value =
                                        product
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
                            );
                    },
                  ),
                  BlocBuilder<ProductCubit, ProductState>(
                    builder: (context, state) =>
                        state.isLoading && state.offset > 1
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
      }),
    );
  }
}
