import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../bloc/user_bloc.dart';
import '../../../data/constants.dart';
import '../../../data/models/ads_menu_type.dart';
import '../../../res/routes.dart';
import '../../../res/theme.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_image.dart';
import '../../widgets/app_network_image.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text('Кабинет'),
        actions: [
          IconButton(
            onPressed: () {
              context.push(Routes.settings);
            },
            icon: const Icon(Feather.settings),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {},
        child: SingleChildScrollView(
          child: Column(
            children: const [
              _Header(),
              SizedBox(height: 10),
              MyProductsCount()
            ],
          ),
        ),
      ),
    );
  }
}

class MyProductsCount extends StatefulWidget {
  const MyProductsCount({
    Key? key,
  }) : super(key: key);

  @override
  State<MyProductsCount> createState() => _MyProductsCountState();
}

class _MyProductsCountState extends State<MyProductsCount> {
  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      context.read<UserBloc>().add(FetchProductsCountEvent());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      decoration: BoxDecoration(
        color: context.theme.surface,
      ),
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          final count = state.productsCount;

          final menu = [
            AdsMenuType(
              title: 'Активные',
              name: 'active',
              count: count?.active ?? 0,
            ),
            AdsMenuType(
              title: 'Неактивные',
              name: 'inactive',
              count: count?.inactive ?? 0,
            ),
            AdsMenuType(
              title: 'На модерации',
              name: 'moderation',
              count: count?.moderation ?? 0,
            ),
            AdsMenuType(
              title: 'Отключено модератором',
              name: 'disabled',
              count: count?.disabled ?? 0,
            ),
          ];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Мои объявления',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      context.push(Routes.myProducts, extra: menu[index].name);
                    },
                    contentPadding: const EdgeInsets.all(0),
                    title: Text(menu[index].title),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        state.isFetchingProductsCount
                            ? Shimmer.fromColors(
                                child: const Text('0'),
                                baseColor: Colors.white,
                                highlightColor: Colors.grey,
                              )
                            : Text(menu[index].count.toString()),
                        const SizedBox(width: 10),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemCount: menu.length,
              ),
              const Divider(height: 1),
              const SizedBox(height: 20),
              AppButton(
                text: 'Подать объявление',
                onPressed: () {
                  context.push(Routes.createProduct);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      decoration: BoxDecoration(
        color: context.theme.surface,
      ),
      child: InkWell(
        onTap: () {
          context.push(Routes.settings);
        },
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            return Row(
              children: [
                state.user?.media?.originalUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(45),
                        child: AppNetworkImage(
                          imageUrl: state.user?.media?.originalUrl ?? '',
                          height: 45,
                          width: 45,
                        ),
                      )
                    : const CircleAvatar(
                        child: AppImage(Assets.icon),
                      ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.user?.name ?? '',
                      style: TextStyle(
                        fontSize: 16,
                        color: context.theme.secondTextColor.withOpacity(0.7),
                      ),
                    ),
                    Text(
                      state.user?.phone ?? '',
                      style: TextStyle(
                        fontSize: 16,
                        color: context.theme.secondTextColor.withOpacity(0.7),
                      ),
                    ),
                  ],
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
