import 'package:get/get.dart';

import '../controllers/category_controller.dart';
import '../controllers/product_controller.dart';
import '../controllers/user_controller.dart';
import '../repositories/user_repo.dart';
import '../repositories/category_repo.dart';
import '../repositories/product_repo.dart';

class AppBindings implements Bindings {
  @override
  void dependencies() {
    // repositories
    Get.put(ProductRepo());
    Get.put(CategoryRepo());
    Get.put(UserRepo());

    // controllers
    Get.put(CategoryController());
    Get.put(ProductController());
    Get.put(UserController());
  }
}
