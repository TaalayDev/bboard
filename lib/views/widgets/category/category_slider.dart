import 'package:flutter/material.dart';

import '../../../resources/theme.dart';
import '../../../models/category.dart';
import '../app_network_image.dart';

class CategorySlider extends StatelessWidget {
  const CategorySlider({
    Key? key,
    required this.list,
    this.horizontalPadding = 0,
    this.onTap,
  }) : super(key: key);

  final List<Category> list;
  final double horizontalPadding;
  final Function(Category category)? onTap;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 35),
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          primary: false,
          shrinkWrap: true,
          itemCount: list.length,
          itemBuilder: (context, index) {
            final _category = list[index];

            return Padding(
              padding: EdgeInsetsDirectional.only(
                start: index == 0 ? horizontalPadding : 10,
                end: index == list.length - 1 ? horizontalPadding : 0,
              ),
              child: InkWell(
                onTap: () => onTap?.call(_category),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.theme.surface,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Row(
                    children: [
                      if (_category.media != null)
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: AppNetworkImage(
                            imageUrl: _category.media!.originalUrl ?? '',
                            height: 30,
                            width: 30,
                          ),
                        ),
                      Text(_category.name),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
