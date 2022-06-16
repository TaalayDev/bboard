import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import '../../res/theme.dart';
import '../../data/models/key_value.dart';

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
      selectedItemColor: context.theme.primary,
      unselectedItemColor: context.theme.mainTextColor,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      onTap: (index) {
        onTap?.call(index);
      },
      items: [
        KeyValue(key: 'Поиск', value: Feather.search),
        KeyValue(key: 'Избранное', value: Feather.heart),
        KeyValue(key: 'Подать', value: Feather.plus_circle),
        KeyValue(key: 'Уведомления', value: Feather.bell),
        KeyValue(key: 'Кабинет', value: Feather.user),
      ]
          .map((item) => BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(bottom: 3.0),
                  child: Icon(item.value),
                ),
                label: item.key,
              ))
          .toList(),
    );
  }
}
