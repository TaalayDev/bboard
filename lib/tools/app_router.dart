import 'package:bboard/views/pages/auth/login_page.dart';
import 'package:bboard/views/pages/auth/register_page.dart';
import 'package:bboard/views/pages/auth/verify_phone_page.dart';
import 'package:bboard/views/pages/create/create_product_page.dart';
import 'package:bboard/views/pages/create/select_category_page.dart';
import 'package:bboard/views/pages/main/main_page.dart';
import 'package:bboard/views/pages/product_details/product_details_page.dart';
import 'package:bboard/views/pages/settings/settings_page.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../views/pages/home/home_page.dart';
import '../views/pages/splash/splash_page.dart';

class AppRouter {
  AppRouter._();

  static final navigatorKey = GlobalKey<NavigatorState>();

  static const String splash = '/splash';
  static const String login = '/login';
  static const String registration = '/registration';
  static const String verifyCode = '/verify_code';
  static const String resetPassword = '/reset_password';
  static const String changePassword = '/change_password';
  static const String main = '/main';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String productDetails = '/product_details';
  static const String settings = '/settings';
  static const String helpMenu = '/help_menu';
  static const String selectSellType = '/select_sell_type';
  static const String selectCategory = '/select_category';
  static const String submitProduct = '/submit_product';
  static const String createProduct = '/create';
  static const String search = '/search';
  static const String searchResults = '/search_results';
  static const String balance = '/balance';
  static const String paymentHistory = '/payment_history';
  static const String topUpWithCart = '/top_up_with_cart';
  static const String selectLocation = '/select_location';
  static const String filter = '/filter';
  static const String editAd = '/edit_ad';
  static const String topUpInfo = '/top_up_info';
  static const String urgentProducts = '/urgent_products';
  static const String adComments = '/ad_comments';
  static const String report = '/report';
  static const String about = '/about';
  static const String help = '/help';
  static const String userProfile = '/user_profile';
  static const String companies = '/companies';
  static const String constructionCompanies = '/construction_companies';
  static const String companyDetails = '/companyDetails';
  static const String selectTariff = '/select_tariff';
  static const String createCompany = '/create_company';
  static const String editCompany = '/edit_company';
  static const String residentialComplex = '/residential_complex';
  static const String residentialComplexDetails =
      '/residential_complex_details';
  static const String developers = '/developers';
  static const String developerDetails = '/developer_details';

  static String get initialRoute => splash;

  static final pages = [
    GetPage(name: splash, page: () => const SplashPage()),
    GetPage(name: login, page: () => const LoginPage()),
    GetPage(name: main, page: () => const MainPage()),
    GetPage(name: home, page: () => const HomePage()),
    GetPage(name: productDetails, page: () => const ProductDetailsPage()),
    GetPage(name: registration, page: () => const RegisterPage()),
    GetPage(name: verifyCode, page: () => const VerifyPhonePage()),
    GetPage(name: settings, page: () => const SettingsPage()),
    GetPage(name: selectCategory, page: () => const SelectCategoryPage()),
    GetPage(name: createProduct, page: () => const CreateProductPage()),
  ];
}
