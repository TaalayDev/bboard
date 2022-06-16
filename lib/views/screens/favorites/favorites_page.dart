import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:go_router/go_router.dart';

import '../../../cubit/product/product_cubit.dart';
import '../../../data/data_provider.dart';
import '../../../data/events/events.dart';
import '../../../data/events/product_events.dart';
import '../../../res/routes.dart';
import '../../../res/theme.dart';

import '../../widgets/event_subscriber.dart';
import '../../widgets/product/sliver_products_grid.dart';
import '../../widgets/refresher.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductCubit()..fetchFavorites(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text(
            'favorites'.tr(),
            style: TextStyle(
              color: context.theme.onPrimary,
              fontSize: 16,
            ),
          ),
        ),
        body: EventSubscriber<FavoriteEvent>(
          event: favoriteEvents,
          rebuildOnEvent: false,
          onEvent: (context, event) {
            print('favorites event ${event?.favorite}');
            if (event != null) {
              if (event.favorite) {
                context
                    .read<ProductCubit>()
                    .addProductToListIfNotExists(event.product);
              } else {
                context
                    .read<ProductCubit>()
                    .removeProductFromList(event.product.id);
              }
            }
          },
          builder: (context, event) => BlocBuilder<ProductCubit, ProductState>(
            builder: (context, state) {
              if (state.isLoading) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Center(child: CircularProgressIndicator()),
                  ],
                );
              }

              if (state.products.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Feather.heart),
                      const SizedBox(height: 20),
                      Text(
                        'you dont have any favorites yet'.tr(),
                        style:
                            TextStyle(fontSize: 16, color: context.theme.grey),
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
                child: Refresher(
                  onRefresh: (controller) async {
                    context.read<ProductCubit>()
                      ..clearOffset()
                      ..fetchFavorites();
                    controller.refreshCompleted();
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 17),
                    child: CustomScrollView(
                      physics: const ClampingScrollPhysics(),
                      controller: ScrollController(),
                      slivers: [
                        SliverProductGrid(
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
                          list: state.products,
                        ),
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
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
