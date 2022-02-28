import 'package:flutter/material.dart' hide KeepAlive;
import 'package:get/get.dart';

import '../../../controllers/product_controller.dart';
import '../../../tools/app_router.dart';
import '../../../tools/locale_storage.dart';
import '../../widgets/bottom_navigation.dart';
import '../../widgets/want_keep_alive.dart';
import '../create/select_category_page.dart';
import '../favorites/favorites_page.dart';
import '../home/home_page.dart';
import '../notifications/notifications_page.dart';
import '../profile/profile_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late int currentIndex;
  late final PageController _pageController;

  final screens = <Widget>[
    WantKeepAlive(child: HomePage(key: UniqueKey())),
    WantKeepAlive(child: FavoritesPage(key: UniqueKey())),
    WantKeepAlive(child: SelectCategoryPage(key: UniqueKey())),
    WantKeepAlive(child: NotificationsPage(key: UniqueKey())),
    WantKeepAlive(child: ProfilePage(key: UniqueKey())),
  ];

  @override
  void initState() {
    currentIndex = 0;
    _pageController = PageController(keepPage: true);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigation(
        currentTab: currentIndex,
        onTap: (index) async {
          if (!LocaleStorage.isLogin && index > 0) {
            Get.toNamed(AppRouter.login);
          }

          if (index == 2) {
            final category = await Get.toNamed(AppRouter.selectCategory);
            if (category != null) {
              Get.find<ProductController>().selectedCategory = category;
              Get.toNamed(AppRouter.createProduct);
            }

            return;
          }

          setState(() {
            currentIndex = index;
          });

          _pageController.animateToPage(index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut);
        },
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: screens,
      ),
    );
  }
}
