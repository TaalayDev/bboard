import 'package:bboard/controllers/category_controller.dart';
import 'package:bboard/controllers/product_controller.dart';
import 'package:bboard/tools/app_router.dart';
import 'package:bboard/tools/locale_storage.dart';
import 'package:bboard/views/pages/auth/login_page.dart';
import 'package:bboard/views/pages/create/select_category_page.dart';
import 'package:bboard/views/pages/home/home_page.dart';
import 'package:bboard/views/pages/profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/category.dart';
import '../../widgets/bottom_navigation.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late int currentIndex;
  late final PageController _pageController;

  final screens = <Widget>[
    HomePage(key: UniqueKey()),
    HomePage(key: UniqueKey()),
    SelectCategoryPage(key: UniqueKey()),
    HomePage(key: UniqueKey()),
    ProfilePage(key: UniqueKey()),
  ];

  @override
  void initState() {
    currentIndex = 0;
    _pageController = PageController();
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
