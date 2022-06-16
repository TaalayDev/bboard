import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../data/data_provider.dart';
import '../views/screens/auth/phone_auth_screen.dart';
import '../cubit/product/product_form_cubit.dart';
import '../data/models/category.dart';
import '../data/models/user.dart';
import '../helpers/helper_functions.dart';
import '../views/screens/add_phone/add_phone_screen.dart';
import '../views/screens/auth/login_screen.dart';
import '../views/screens/auth/register_screen.dart';
import '../views/screens/auth/verify_phone_screen.dart';
import '../views/screens/category_products/category_products_page.dart';
import '../views/screens/change_password/change_password_page.dart';
import '../views/screens/comments/comments_screen.dart';
import '../views/screens/complaint/complaint_screen.dart';
import '../views/screens/create/create_product_screen.dart';
import '../views/screens/create/select_category_screen.dart';
import '../views/screens/edit/edit_product_screen.dart';
import '../views/screens/home/home_screen.dart';
import '../views/screens/main/main_screen.dart';
import '../views/screens/my_products/my_products_screen.dart';
import '../views/screens/product_details/product_details_screen.dart';
import '../views/screens/profile/profile_screen.dart';
import '../views/screens/search/search_screen.dart';
import '../views/screens/settings/settings_screen.dart';
import '../views/screens/splash/splash_screen.dart';
import '../views/screens/user_products/user_products_screen.dart';

class Routes {
  Routes._();

  static get routeInformationParser => _router.routeInformationParser;
  static get routerDelegate => _router.routerDelegate;

  static final _router = GoRouter(
    routes: [
      GoRoute(
        path: main,
        builder: (context, state) => const MainScreen(),
        routes: [
          GoRoute(
            path: productDetailsPath,
            builder: (context, state) {
              final id = parseInt(state.params['id']) ?? 0;
              return ProductDetailsScreen(productId: id);
            },
            routes: [
              GoRoute(
                path: editProductPath,
                builder: (context, state) {
                  final id = parseInt(state.params['id']) ?? 0;

                  return BlocProvider(
                    create: (context) => ProductFormCubit(
                      dataProvider: context.read<DataProvider>(),
                    ),
                    child: EditProductScreen(productId: id),
                  );
                },
              ),
              GoRoute(
                path: commentsPath,
                builder: (context, state) {
                  final id = parseInt(state.params['id']) ?? 0;
                  return CommentsScreen(productId: id);
                },
              ),
              GoRoute(
                path: complaintPath,
                builder: (context, state) {
                  final id = parseInt(state.params['id']) ?? 0;
                  return ComplaintScreen(productId: id);
                },
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: signIn,
        builder: (context, state) => PhoneAuthScreen(),
      ),
      GoRoute(
        path: registration,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: verifyCode,
        builder: (context, state) => const VerifyPhoneScreen(),
      ),
      GoRoute(
        path: changePassword,
        builder: (context, state) => const ChangePasswordScreen(),
      ),
      GoRoute(
        path: home,
        builder: (context, state) => HomeScreen(),
      ),
      GoRoute(
        path: createProduct,
        builder: (context, state) {
          final category = state.extra != null ? state.extra as Category : null;

          return BlocProvider(
            create: (context) => ProductFormCubit(
              dataProvider: context.read<DataProvider>(),
            ),
            child: CreateProductScreen(category: category),
          );
        },
      ),
      GoRoute(
        path: settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: selectCategory,
        builder: (context, state) => const SelectCategoryScreen(),
      ),
      GoRoute(
        path: profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: addPhone,
        builder: (context, state) => const AddPhoneScreen(),
      ),
      GoRoute(
        path: categoryProductsPath,
        builder: (context, state) {
          final id = parseInt(state.params['id']) ?? 0;
          final user = state.extra != null ? state.extra as User : null;

          return CategoryProductsScreen(categoryId: id);
        },
      ),
      GoRoute(
        path: myProducts,
        builder: (context, state) {
          final data = state.extra?.toString();
          return MyProductsScreen(initialStatus: data);
        },
      ),
      GoRoute(
        path: userProductsPath,
        builder: (context, state) {
          final id = parseInt(state.params['id']) ?? 0;
          final user = state.extra != null ? state.extra as User : null;

          return UserProductsScreen(userId: id, user: user);
        },
      ),
      GoRoute(
        path: changePassword,
        builder: (context, state) => const ChangePasswordScreen(),
      ),
      GoRoute(
        path: search,
        builder: (context, state) => SearchScreen(),
      ),
    ],
    initialLocation: splash,
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Route not found ${state.location}'),
      ),
    ),
  );

  static const String splash = '/splash';
  static const String login = '/login';
  static const String signIn = '/signin';
  static const String registration = '/registration';
  static const String verifyCode = '/verify/phone';
  static const String resetPassword = '/reset/password';
  static const String changePassword = '/user/password';
  static const String myProducts = '/user/products';
  static const String main = '/';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String helpMenu = '/help/menu';
  static const String selectCategory = '/categories/select';
  static const String submitProduct = '/products/submit';
  static const String createProduct = '/create';
  static const String search = '/search';
  static const String searchResults = '/search/results';
  static const String balance = '/balance';
  static const String filter = '/filter';
  static const String report = '/report';
  static const String about = '/about';
  static const String help = '/help';
  static const String addPhone = '/phone';
  static const String categoryProductsPath = '/categories/:id/products';
  static const String userProfile = '/users/:id';
  static const String userProductsPath = '/users/:id/products';

  static const String productDetailsPath = 'products/:id';
  static const String complaintPath = 'complaint';
  static const String editProductPath = 'edit';
  static const String commentsPath = 'comments';

  static String categoryProducts(int id) =>
      categoryProductsPath.replaceAll(':id', '$id');
  static String userProducts(int id) =>
      userProductsPath.replaceAll(':id', '$id');

  static String productDetails(int id) =>
      '/' + productDetailsPath.replaceAll(':id', '$id');
  static String complaint(int id) => productDetails(id) + '/complaint';
  static String editProduct(int id) => productDetails(id) + '/edit';
  static String comments(int id) => productDetails(id) + '/comments';
}
