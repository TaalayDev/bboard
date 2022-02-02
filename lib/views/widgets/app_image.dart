import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppImage extends StatelessWidget {
  final String image;
  final double? height;
  final double? width;
  final Color? color;

  const AppImage(
    this.image, {
    key,
    this.width,
    this.height,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (image.endsWith('.svg')) {
      return SvgPicture.asset(image,
          height: height, width: width, color: color);
    }

    return Image.asset(image, height: height, width: width, color: color);
  }
}
