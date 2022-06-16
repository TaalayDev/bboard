import 'package:bboard/res/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:go_router/go_router.dart';

import '../../../cubit/product/category_products_cubit.dart';
import '../../../data/data_provider.dart';
import '../../../data/events/events.dart';
import '../../../res/routes.dart';
import '../../../res/theme.dart';
import '../../widgets/category/category_slider.dart';
import '../../widgets/custom_search_bar.dart';
import '../../widgets/loading_more_widget.dart';
import '../../widgets/product/sliver_products_grid.dart';
import '../../widgets/refresher.dart';

class CategoryProductsScreen extends StatelessWidget {
  const CategoryProductsScreen({
    Key? key,
    required this.categoryId,
  }) : super(key: key);

  final int categoryId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoryProductsCubit(
        categoryRepo: getIt.get(),
        productRepo: getIt.get(),
        dataProvider: context.read<DataProvider>(),
      )
        ..fetchCategoryDetails(categoryId)
        ..fetchCategoryProducts(categoryId),
      child: Builder(builder: (context) {
        final categoryProductsCubit = context.read<CategoryProductsCubit>();

        return Scaffold(
          appBar: CustomSearchBar(
            onSearchTextChanged: (value) {
              categoryProductsCubit.setSearchText(value);
            },
            onStopEditingSearchText: (value) {
              if (value.isEmpty) {
                categoryProductsCubit.fetchCategoryProducts(categoryId);
              }
            },
            onSearchPressed: () {
              context.push(Routes.search);
            },
            backIcon: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: context.theme.onPrimary,
              ),
              onPressed: () {
                context.pop();
              },
            ),
          ),
          body: BlocBuilder<CategoryProductsCubit, CategoryProductsState>(
            bloc: categoryProductsCubit,
            builder: (context, state) {
              final category = state.category;

              if (state.isLoadingCategory && category == null) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }

              if (category == null) return const SizedBox();

              return NestedScrollView(
                headerSliverBuilder: (context, _) => [
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 12,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            category.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 3),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(Icons.close, size: 15),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (category.children.isNotEmpty) ...[
                    const SliverToBoxAdapter(child: SizedBox(height: 6)),
                    SliverToBoxAdapter(
                      child: CategorySlider(
                        horizontalPadding: 10,
                        list: category.children,
                        onTap: (category) {
                          categoryProductsCubit
                            ..changeCategory(category)
                            ..fetchCategoryProducts(categoryId);
                        },
                      ),
                    ),
                  ],
                ],
                body: NotificationListener<ScrollNotification>(
                  onNotification: (scrollInfo) {
                    if (scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent) {
                      categoryProductsCubit.fetchCategoryProducts(categoryId);
                    }

                    return false;
                  },
                  child: Refresher(
                    onRefresh: (refreshController) async {
                      await categoryProductsCubit
                        ..clearOffset()
                        ..fetchCategoryProducts(categoryId);
                      refreshController.refreshCompleted();
                    },
                    child: state.isLoading && state.products.isEmpty
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : CustomScrollView(
                            physics: const ClampingScrollPhysics(),
                            slivers: [
                              const SliverToBoxAdapter(
                                child: SizedBox(height: 10),
                              ),
                              SliverPadding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
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
                                          .read<CategoryProductsCubit>()
                                          .removeFromFavorites(product.id)
                                          .then((value) {
                                        sendRemovedFromFavoriteEvent(product);
                                      });
                                    } else {
                                      context
                                          .read<CategoryProductsCubit>()
                                          .addToFavorites(product.id)
                                          .then((value) {
                                        sendAddedToFavoriteEvent(product);
                                      });
                                    }
                                  },
                                ),
                              ),
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
                              const SliverToBoxAdapter(
                                child: SizedBox(height: 50),
                              ),
                            ],
                          ),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
