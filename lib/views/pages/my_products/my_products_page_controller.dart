import 'package:bboard/repositories/product_repo.dart';
import 'package:get/get.dart';

import '../../../models/product.dart';

class MyProductsPageController extends GetxController {
  bool isFetchingProducts = false;
  List<Product> products = [];

  String? status;

  final _productRepo = Get.find<ProductRepo>();

  @override
  void onInit() {
    fetchUserProducts();
    status = Get.arguments;
    super.onInit();
  }

  void fetchUserProducts() async {
    isFetchingProducts = true;
    update();

    final responseModel = await _productRepo.fetchUserProducts();
    if (responseModel.status) {
      products = responseModel.data!;
    }

    isFetchingProducts = false;
    update();
  }
}
