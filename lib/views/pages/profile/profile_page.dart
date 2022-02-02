import 'package:bboard/resources/constants.dart';
import 'package:bboard/views/widgets/app_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';

import '../../../tools/locale_storage.dart';
import '../../../resources/theme.dart';
import '../../../controllers/user_controller.dart';
import '../../../tools/app_router.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_network_image.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text('Кабинет'),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                value: '7',
                onTap: () {},
                child: Text('Выйти из аккаунта'),
              ),
            ],
            onSelected: (item) {
              LocaleStorage.token = null;
              Get.offAllNamed(AppRouter.main);
            },
            icon: Icon(Feather.settings),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {},
        child: SingleChildScrollView(
          child: Column(
            children: [
              const _Header(),
              const SizedBox(height: 10),
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
  final menu = const [
    AdsMenuType(title: 'Активные', count: 1),
    AdsMenuType(title: 'Неактивные', count: 1),
    AdsMenuType(title: 'На модерации', count: 0),
    AdsMenuType(title: 'Отключено модератором', count: 0),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      decoration: BoxDecoration(
        color: context.theme.surface,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
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
                onTap: () {},
                contentPadding: const EdgeInsets.all(0),
                title: Text(menu[index].title),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(menu[index].count.toString()),
                    const SizedBox(width: 10),
                    Icon(
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
              Get.toNamed(AppRouter.registration);
            },
          ),
        ],
      ),
    );
  }
}

class AdsMenuType {
  const AdsMenuType({
    required this.title,
    required this.count,
    this.onTap,
  });

  final String title;
  final int count;
  final Function? onTap;
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
          Get.toNamed('/settings');
        },
        child: GetBuilder<UserController>(builder: (controller) {
          return Row(
            children: [
              CircleAvatar(
                child: controller.user?.media?.originalUrl != null
                    ? AppNetworkImage(
                        imageUrl: controller.user?.media?.originalUrl ?? '',
                      )
                    : const AppImage(Assets.icon),
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.user?.name ?? '',
                    style: TextStyle(
                      fontSize: 16,
                      color: context.theme.secondTextColor.withOpacity(0.7),
                    ),
                  ),
                  Text(
                    controller.user?.phone ?? '',
                    style: TextStyle(
                      fontSize: 16,
                      color: context.theme.secondTextColor.withOpacity(0.7),
                    ),
                  ),
                ],
              )
            ],
          );
        }),
      ),
    );
  }
}
