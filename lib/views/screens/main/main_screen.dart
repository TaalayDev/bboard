import 'package:flutter/material.dart' hide KeepAlive;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../data/data_provider.dart';
import '../../../data/storage.dart';
import '../../../res/routes.dart';
import '../../widgets/bottom_navigation.dart';
import '../../widgets/want_keep_alive.dart';
import '../create/select_category_screen.dart';
import '../favorites/favorites_page.dart';
import '../home/home_screen.dart';
import '../notifications/notifications_screen.dart';
import '../profile/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int currentIndex;
  late final PageController _pageController;

  final screens = <Widget>[
    WantKeepAlive(child: HomeScreen(key: UniqueKey())),
    WantKeepAlive(child: FavoritesScreen(key: UniqueKey())),
    WantKeepAlive(child: SelectCategoryScreen(key: UniqueKey())),
    WantKeepAlive(child: NotificationsScreen(key: UniqueKey())),
    WantKeepAlive(child: ProfileScreen(key: UniqueKey())),
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
            context.go(Routes.login);
            return;
          }

          if (index == 2) {
            final category = await Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => const SelectCategoryScreen(),
            ));
            if (category != null) {
              context
                ..read<DataProvider>().category.value = category
                ..push(Routes.createProduct);
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
