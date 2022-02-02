import 'package:flutter/material.dart';

import '../../../helpers/sizer_utils.dart';
import '../../../models/product.dart';
import 'product_grid_item.dart';

class SliverProductGrid extends StatelessWidget {
  final List<Product> list;
  final String heroTag;
  final Function? onUpdate;
  final EdgeInsets? padding;
  final Function(Product item)? onTap;

  const SliverProductGrid({
    Key? key,
    required this.list,
    this.heroTag = 'product_grid_item_',
    this.padding,
    this.onUpdate,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
        (context, index) => InkWell(
          onTap: () {
            onTap?.call(list[index]);
          },
          child: ProductGridItem(
            product: list[index],
            heroTag: heroTag,
          ),
        ),
        childCount: list.length,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 0.68,
        crossAxisCount: SizerUtils.responsive(2, md: 4, lg: 4, xl: 4),
        crossAxisSpacing: 15,
        mainAxisSpacing: 10,
      ),
    );
  }
}
