import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:jiffy/jiffy.dart';

import '../../../data/constants.dart';
import '../../../data/models/product.dart';
import '../../../res/theme.dart';
import '../../widgets/app_icon.dart';
import '../app_network_image.dart';
import 'product_badge.dart';

class ProductGridItem extends StatefulWidget {
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
  State<ProductGridItem> createState() => _ProductGridItemState();
}

class _ProductGridItemState extends State<ProductGridItem> {
  @override
  Widget build(BuildContext context) {
    // final height = 260.0;
    return Container(
      // height: height,
      constraints: const BoxConstraints(maxHeight: 260),
      width: widget.width ?? double.infinity,
      decoration: BoxDecoration(
        color: widget.product.color != null
            ? widget.product.color?.withAlpha(80)
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
                          child: widget.product.media.isNotEmpty
                              ? Hero(
                                  tag: 'product_${widget.product.id}_image',
                                  child: AppNetworkImage(
                                    imageUrl:
                                        widget.product.media[0].originalUrl ??
                                            '',
                                    fit: BoxFit.cover,
                                    errorWidget: const Center(
                                      child: AppIcon(
                                        AppIcons.icon,
                                        size: 30,
                                      ),
                                    ),
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
                          if (widget.product.isVip)
                            const ProductBadge(type: ProductBadgeTypes.VIP),
                          if (widget.product.isTop)
                            const ProductBadge(type: ProductBadgeTypes.TOP),
                          if (widget.product.isUrgent)
                            const ProductBadge(type: ProductBadgeTypes.URGENT),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 2,
                      right: 4,
                      child: IconButton(
                        onPressed: () async {
                          widget.onHeartTap?.call();
                        },
                        icon: Icon(
                          widget.product.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: widget.product.isFavorite
                              ? Colors.red
                              : Colors.white,
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
                        widget.product.getPrice,
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
                                widget.product.title,
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
                                  Jiffy(widget.product.createdAt)
                                      .fromNow(), // '${product.getDate}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: context.theme.grey,
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
                                      widget.product.views.toString(),
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: context.theme.grey,
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
