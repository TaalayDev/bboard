import 'package:flutter/material.dart';

import '../models/badge.dart';
import '../views/widgets/app_icon.dart';

class Constants {
  static const String BASE_URL = 'http://univerosh.kg/testapp/public';
  static const String API_BASE_URL = 'http://univerosh.kg/testapp/public/api/';
}

class Assets {
  static const icon = 'assets/images/icon.png';
  static const instagramRound = 'assets/images/instagram_round.png';
  static const facebookRound = 'assets/images/facebook_round.png';
  static const odnoklassnikiRound = 'assets/images/odnoklassniki_round.png';
  static const vkRound = 'assets/images/vk_round.png';
  static const twitterRound = 'assets/images/twitter_round.png';
}

class ProductBadgeTypes {
  static const VIP = Badge('VIP', Colors.amber, icon: AppIcons.vip);
  static const TOP = Badge('TOP', Color(0xFFA72E85), icon: AppIcons.raket);
  static const URGENT = Badge('срочно', Colors.red);
}
