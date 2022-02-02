import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';

import '../../resources/theme.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({
    Key? key,
    this.currentTab = 0,
    this.onTap,
  }) : super(key: key);

  final int currentTab;
  final Function(int index)? onTap;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentTab,
      selectedItemColor: Get.theme.primary,
      unselectedItemColor: Get.theme.mainTextColor,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      onTap: (index) {
        onTap?.call(index);
      },
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Feather.search).paddingOnly(bottom: 3),
          label: 'Поиск',
        ),
        BottomNavigationBarItem(
          icon: const Icon(Feather.heart).paddingOnly(bottom: 3),
          label: 'Избранное',
        ),
        BottomNavigationBarItem(
          icon: const Icon(Feather.plus_circle).paddingOnly(bottom: 3),
          label: 'Подать',
        ),
        BottomNavigationBarItem(
          icon: const Icon(Feather.bell).paddingOnly(bottom: 3),
          label: 'Уведомления',
        ),
        BottomNavigationBarItem(
          icon: const Icon(Feather.user).paddingOnly(bottom: 3),
          label: 'Кабинет',
        ),
      ],
    );
  }
}
