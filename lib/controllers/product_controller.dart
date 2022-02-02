import 'package:bboard/tools/image_picker.dart';
import 'package:get/get.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';

import '../../models/product.dart';
import '../repositories/product_repo.dart';

class ProductController extends GetxController {
  List<Product> products = [];
  List<Product> favorites = [];
  List<Asset> images = [];

  bool isFetchingProducts = false;
  bool isFetchingMore = false;
  bool isFetchingProductDetails = false;
  bool isFetchingFavorites = false;

  final int limit = 20;
  int offset = 0;

  Product? _selectedProduct;
  Product? _productDetail;

  final _productRepo = Get.find<ProductRepo>();

  set selectedProduct(Product product) {
    _selectedProduct = product;
    fetchProductDetails();
  }

  Product? get productDetails => _productDetail ?? _selectedProduct;

  Future<void> fetchProducts() async {
    if (!isFetchingProducts && products.isEmpty) {
      offset = 0;

      isFetchingProducts = true;
      update();

      products =
          await _fetchProducts(params: {'offset': offset, 'limit': limit});

      isFetchingProducts = false;
      update();
    }
  }

  Future<void> fetchMoreProducts() async {
    if (!isFetchingMore) {
      offset += limit;

      isFetchingMore = true;
      update();

      products.addAll(await _fetchProducts(
        params: {'offset': offset, 'limit': limit},
      ));

      isFetchingMore = false;
      update();
    }
  }

  Future<void> fetchFavorites() async {
    if (!isFetchingFavorites) {
      isFetchingFavorites = true;
      update();

      final appResponse = await _productRepo.fetchFavorites();
      if (appResponse.status) {
        favorites = appResponse.data!;
      }

      isFetchingFavorites = false;
      update();
    }
  }

  Future<void> fetchProductDetails() async {
    if (_selectedProduct != null) {
      isFetchingProductDetails = true;
      update();

      final appReponse = await _productRepo.fetchProduct(_selectedProduct!.id);
      if (appReponse.status) {
        _productDetail = appReponse.data!;
        _selectedProduct?.views++;
      }

      isFetchingProductDetails = false;
      update();
    }
  }

  Future<List<Product>> _fetchProducts({Map<String, dynamic>? params}) async {
    final appResponse = await _productRepo.fetchProducts(params: params);
    if (appResponse.status) {
      return appResponse.data!;
    }
    return const [];
  }

  Future<void> pickImages() async {
    images = await ImagePicker.pickImages(images);
    update();
  }
}
