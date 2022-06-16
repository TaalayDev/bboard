import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import '../../res/theme.dart';
import 'search_field.dart';

class CustomSearchBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomSearchBar({
    Key? key,
    this.backIcon,
    this.textController,
    this.onSearchPressed,
    this.onSearchTextChanged,
    this.onStopEditingSearchText,
  }) : super(key: key);

  final Widget? backIcon;
  final TextEditingController? textController;
  final Function()? onSearchPressed;
  final Function(String value)? onSearchTextChanged;
  final Function(String value)? onStopEditingSearchText;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 60,
      elevation: 0.0,
      leading: backIcon,
      titleSpacing: backIcon != null ? 0 : null,
      title: Hero(
        tag: 'search_bar_field',
        child: SizedBox(
          height: 40,
          child: SearchField(
            controller: textController,
            onChanged: onSearchTextChanged,
            onStopEditing: onStopEditingSearchText,
          ),
        ),
      ),
      actions: [
        backIcon != null ? const SizedBox(width: 5) : const SizedBox(),
        Hero(
          tag: 'search_bar_button',
          child: Material(
            color: Colors.transparent,
            child: Badge(
              position: const BadgePosition(top: 3, end: 0),
              badgeContent: const Text(
                '!',
                style: TextStyle(color: Colors.white),
              ),
              showBadge: false,
              child: SizedBox(
                height: double.infinity,
                child: IconButton(
                  onPressed: onSearchPressed,
                  color: context.theme.onPrimary,
                  icon: const Icon(Feather.search, size: 30),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 15),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
