import 'package:flutter/cupertino.dart';

import '../../../views/widgets/app_icon.dart';

class Badge {
  final String title;
  final Color color;
  final AppIcons? icon;

  const Badge(this.title, this.color, {this.icon});
}
