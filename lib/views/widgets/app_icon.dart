import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum AppIcons { icon, vip, raket }

class AppIcon extends StatelessWidget {
  final AppIcons icon;
  final double size;
  final Color? color;

  const AppIcon(
    this.icon, {
    Key? key,
    this.size = 25,
    this.color = const Color(0xff636363),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      child: Center(
        child: SvgPicture.asset(
          'assets/svg_icons/' + icon.name + '.svg',
          color: color,
          height: size,
          width: size,
        ),
      ),
    );
  }
}
