import 'package:flutter/material.dart';

import '../../../data/models/badge_model.dart';
import '../app_icon.dart';

class ProductBadge extends StatelessWidget {
  final BadgeModel type;

  const ProductBadge({
    Key? key,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 5),
      padding: const EdgeInsets.symmetric(horizontal: 5),
      height: 18,
      decoration: BoxDecoration(
        color: type.color,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Row(
        children: [
          if (type.icon != null) ...[
            AppIcon(type.icon!, color: Colors.white, size: 12),
            const SizedBox(width: 4),
          ],
          Text(
            type.title.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 8.0,
            ),
          ),
        ],
      ),
    );
  }
}
