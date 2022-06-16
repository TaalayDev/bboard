import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../cubit/product/product_cubit.dart';
import '../../../data/data_provider.dart';
import '../../../cubit/user_details_cubit.dart';
import '../../../res/routes.dart';
import '../../../data/models/user.dart';
import '../../../res/theme.dart';
import '../../widgets/app_network_image.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/product/sliver_products_grid.dart';
import '../../widgets/refresher.dart';

class UserProductsScreen extends StatelessWidget {
  const UserProductsScreen({
    Key? key,
    required this.userId,
    this.user,
  }) : super(key: key);

  final int userId;
  final User? user;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ProductCubit()..fetchUserProducts(userId),
        ),
        BlocProvider(create: (context) => UserDetailsCubit(userId, user: user)),
      ],
      child: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          return Scaffold(
            appBar: const CustomAppBar(title: 'Профиль'),
            body: NestedScrollView(
              headerSliverBuilder: (context, _) => [
                const SliverToBoxAdapter(child: SizedBox(height: 15)),
                BlocBuilder<UserDetailsCubit, UserDetailsState>(
                  builder: (context, state) {
                    return SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      sliver: SliverToBoxAdapter(
                        child: state.user != null
                            ? UserCard(user: state.user!)
                            : const CircularProgressIndicator.adaptive(),
                      ),
                    );
                  },
                ),
              ],
              body: state.isLoading && state.offset <= 1
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : NotificationListener<ScrollNotification>(
                      onNotification: (scrollInfo) {
                        if (scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent) {
                          context
                              .read<ProductCubit>()
                              .fetchUserProducts(userId);
                        }

                        return false;
                      },
                      child: Refresher(
                        header: BezierCircleHeader(
                          bezierColor: context.theme.surface,
                          circleColor: context.theme.primary,
                        ),
                        onRefresh: (refController) async {
                          context.read<ProductCubit>()
                            ..clearOffset()
                            ..fetchUserProducts(userId).then((value) {
                              refController.refreshCompleted();
                            });
                        },
                        child: CustomScrollView(
                          slivers: [
                            const SliverToBoxAdapter(
                              child: SizedBox(height: 15),
                            ),
                            SliverPadding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              sliver: SliverProductGrid(
                                list: state.products,
                                onTap: (product) {
                                  context
                                    ..read<DataProvider>().product.value =
                                        product
                                    ..go(Routes.productDetails(product.id));
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
                            const SliverToBoxAdapter(
                              child: SizedBox(height: 30),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          );
        },
      ),
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
