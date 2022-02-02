import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../resources/constants.dart';
import '../../resources/theme.dart';

class AppNetworkImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit? fit;
  final double? height;
  final double? width;
  final Widget? errorWidget;

  const AppNetworkImage({
    key,
    required this.imageUrl,
    this.fit,
    this.height,
    this.width,
    this.errorWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit ?? BoxFit.cover,
      height: height,
      width: width,
      errorWidget: (context, url, _) =>
          errorWidget ??
          Image.asset(
            Assets.icon,
            fit: BoxFit.fill,
          ),
      progressIndicatorBuilder: (context, url, progress) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(context.theme.primary),
                value: progress.totalSize != null
                    ? progress.downloaded / progress.totalSize!
                    : null),
          ),
        );
      },
    );
  }
}
