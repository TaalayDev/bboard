import 'package:bboard/models/product.dart';
import 'package:bboard/repositories/product_repo.dart';
import 'package:get/get.dart';

import '../../../models/category.dart';

class CategoryProductsController extends GetxController {
  late Category category;

  List<Product> products = [];
  List<Category> hist = [];

  bool isFetchingProducts = false;
  bool isFetchingMore = false;

  final int limit = 20;
  int offset = 0;

  final _productRepo = Get.find<ProductRepo>();

  @override
  void onInit() {
    category = Get.arguments;
    hist.add(category);
    fetchCategoryProducts();
    super.onInit();
  }

  void clearHist() {
    hist.removeRange(1, hist.length);
    update();
  }

  void changeSelectedCategory(Category category) {
    this.category = category;
    if (!hist.contains(category)) {
      hist.add(category);
      update();
    }
  }

  void fetchCategoryProducts({String? search}) async {
    isFetchingProducts = true;
    offset = 0;
    update();

    final params = <String, dynamic>{
      'with': 'user',
      'limit': limit,
      'offset': offset,
      'orderBy': 'created_at',
      'sortedBy': 'desc',
      'categories': '${category.id}',
      if (search != null && search.isNotEmpty) ...{
        'search': 'title:$search;description:$search',
        'searchFields': 'title:like;description:like',
      }
    };
    final responseModel = await _productRepo.fetchProducts(params: params);

    if (responseModel.status) {
      products = responseModel.data!;
    }

    isFetchingProducts = false;
    update();
  }

  Future<void> fetchMoreCategoryProducts({String? search}) async {
    if (!isFetchingMore) {
      offset += limit;

      isFetchingMore = true;
      update();

      final params = <String, dynamic>{
        'with': 'user',
        'limit': limit,
        'offset': offset,
        'orderBy': 'created_at',
        'sortedBy': 'desc',
        'categories': '${category.id}',
        if (search != null && search.isNotEmpty) ...{
          'search': 'title:$search;description:$search',
          'searchFields': 'title:like;description:like',
        }
      };

      final responseModel = await _productRepo.fetchProducts(params: params);
      if (responseModel.status) {
        products.addAll(responseModel.data ?? []);
      }

      isFetchingMore = false;
      update();
    }
  }
}
