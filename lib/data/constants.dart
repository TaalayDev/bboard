import 'package:flutter/material.dart';

import '../views/widgets/app_icon.dart';
import 'models/badge_model.dart';

class Constants {
  static const String baseUrl = 'http://onboard.biz.kg';
  static const String apiBaseUrl = 'http://onboard.biz.kg/api/';
}

class Assets {
  const Assets._();
  static const icon = 'assets/images/icon.png';
  static const instagramRound = 'assets/images/instagram_round.png';
  static const facebookRound = 'assets/images/facebook_round.png';
  static const odnoklassnikiRound = 'assets/images/odnoklassniki_round.png';
  static const vkRound = 'assets/images/vk_round.png';
  static const twitterRound = 'assets/images/twitter_round.png';
}

class ProductBadgeTypes {
  static const VIP = BadgeModel('VIP', Colors.amber, icon: AppIcons.vip);
  static const TOP = BadgeModel('TOP', Color(0xFFA72E85), icon: AppIcons.raket);
  static const URGENT = BadgeModel('срочно', Colors.red);
}
