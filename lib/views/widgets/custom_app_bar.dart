import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../resources/theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    Key? key,
    required this.title,
    this.backIcon,
    this.actions,
    this.onBackPressed,
  }) : super(key: key);

  final String title;
  final Widget? backIcon;
  final List<Widget>? actions;
  final Function()? onBackPressed;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      leading: IconButton(
        onPressed: onBackPressed ??
            () {
              Get.back();
            },
        icon: backIcon ?? const Icon(Icons.arrow_back_ios),
      ),
      centerTitle: true,
      title: Text(
        title,
        style: TextStyle(
          color: Get.theme.onPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
