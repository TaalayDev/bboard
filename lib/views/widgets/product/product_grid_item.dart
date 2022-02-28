import 'package:bboard/helpers/sizer_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';

import '../../../controllers/product_controller.dart';
import '../../../models/product.dart';
import '../../../resources/constants.dart';
import '../../../resources/theme.dart';
import '../../widgets/app_icon.dart';
import 'product_badge.dart';

class ProductGridItem extends StatelessWidget {
  final String heroTag;
  final Product product;
  final double? width;
  final bool top;
  final Function()? onHeartTap;

  const ProductGridItem({
    Key? key,
    required this.product,
    this.heroTag = 'product_item_',
    this.width,
    this.top = false,
    this.onHeartTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final height = 260.0;
    return Container(
      // height: height,
      constraints: BoxConstraints(maxHeight: 260),
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        color: product.color != null
            ? product.color?.withAlpha(80)
            : context.theme.surface,
        border: Border.all(color: context.theme.surface, width: 0),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Flexible(
                flex: 75,
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
                              ? Hero(
                                  tag: 'product_${product.id}_image',
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        product.media[0].originalUrl ?? '',
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
                                  ),
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
                    Positioned(
                      top: 2,
                      right: 4,
                      child: IconButton(
                        onPressed: () {
                          if (product.isFavorite) {
                            Get.find<ProductController>()
                                .removeFromFavorites(product);
                          } else {
                            Get.find<ProductController>()
                                .addToFavorites(product);
                          }
                        },
                        icon: Icon(
                          product.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: product.isFavorite ? Colors.red : Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 35,
                child: Padding(
                  padding: const EdgeInsets.only(top: 5, left: 10, right: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.getPrice,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                product.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
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
                                Row(
                                  children: [
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
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
