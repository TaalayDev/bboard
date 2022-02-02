import 'package:bboard/resources/constants.dart';
import 'package:bboard/tools/app_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:jiffy/jiffy.dart';

import '../../../models/product.dart';
import '../../widgets/app_icon.dart';
import '../../../resources/theme.dart';
import '../app_image.dart';
import 'product_badge.dart';

class ProductGridItem extends StatelessWidget {
  final String heroTag;
  final Product product;
  final double? width;
  final bool top;

  const ProductGridItem({
    Key? key,
    required this.product,
    this.heroTag = 'product_item_',
    this.width,
    this.top = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = 260.0;
    return Container(
      // height: height,
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        color: product.color != null
            ? product.color?.withAlpha(80)
            : context.theme.surface,
        border: Border.all(color: context.theme.surface, width: 0),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 55,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        topRight: Radius.circular(8.0),
                      ),
                      child: product.media.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: product.media[0].originalUrl ?? '',
                              fit: BoxFit.cover,
                              errorWidget: (_, __, ___) => const Center(
                                child: AppIcon(
                                  AppIcons.icon,
                                  size: 30,
                                ),
                              ),
                              progressIndicatorBuilder:
                                  (context, url, progress) {
                                return const Center(
                                  child: AppIcon(
                                    AppIcons.icon,
                                    size: 30,
                                  ),
                                );
                              },
                            )
                          : Container(
                              color: Colors.grey[350],
                              child: const Icon(
                                Feather.image,
                                size: 80,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ),
                Positioned(
                  top: 6,
                  left: 6,
                  child: Row(
                    children: [
                      if (product.isVip)
                        const ProductBadge(type: ProductBadgeTypes.VIP),
                      if (product.isTop)
                        const ProductBadge(type: ProductBadgeTypes.TOP),
                      if (product.isUrgent)
                        const ProductBadge(type: ProductBadgeTypes.URGENT),
                    ],
                  ),
                ),
                if (product.user != null)
                  Positioned(
                    bottom: 6,
                    left: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 5),
                      decoration: BoxDecoration(
                        color: Get.theme.primary,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Text(
                        product.user?.name ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            flex: 30,
            child: Padding(
              padding: const EdgeInsets.only(top: 10, left: 10, right: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          product.getPrice,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      product.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Feather.calendar,
                        color: Color(0xFF727272),
                        size: 15,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        Jiffy(product.createdAt)
                            .fromNow(), // '${product.getDate}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10,
                          color: Get.theme.grey,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(
                        Feather.eye,
                        color: Color(0xFF727272),
                        size: 15,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        product.views.toString(),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10,
                          color: Get.theme.grey,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
