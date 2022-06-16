import 'package:flutter/cupertino.dart';

import '../../../views/widgets/app_icon.dart';

class BadgeModel {
  final String title;
  final Color color;
  final AppIcons? icon;

  const BadgeModel(this.title, this.color, {this.icon});
}
