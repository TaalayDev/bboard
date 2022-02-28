import 'package:bboard/models/user.dart';
import 'package:get/get.dart';

import '../../../models/product.dart';
import '../../../repositories/product_repo.dart';

class UserProductsPageController extends GetxController {
  bool isFetchingProducts = false;
  bool isFetchingMoreProducts = false;
  List<Product> products = [];

  late User user;

  final int limit = 20;
  int offset = 0;

  final _productRepo = Get.find<ProductRepo>();

  @override
  void onInit() {
    user = Get.arguments;
    fetchUserProducts();
    super.onInit();
  }

  void fetchUserProducts() async {
    offset = 0;
    isFetchingProducts = true;
    update();

    final responseModel = await _productRepo.fetchProducts(params: {
      'search': 'user_id:${user.id}',
      'searchFields': 'user_id:=',
      'limit': limit,
      'offset': offset
    });
    if (responseModel.status) {
      products = responseModel.data!;
    }

    isFetchingProducts = false;
    update();
  }

  void fetchMoreProducts() async {
    if (!isFetchingMoreProducts) {
      offset += limit;

      isFetchingMoreProducts = true;
      update();

      final responseModel = await _productRepo.fetchProducts(params: {
        'search': 'user_id:${user.id}',
        'searchFields': 'user_id:=',
        'limit': limit,
        'offset': offset
      });
      if (responseModel.status) {
        products = responseModel.data!;
      }

      isFetchingMoreProducts = false;
      update();
    }
  }
}
