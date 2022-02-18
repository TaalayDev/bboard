import 'dart:io';

import 'package:bboard/models/app_reponse.dart';
import 'package:bboard/models/region.dart';
import 'package:bboard/tools/locale_storage.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide MultipartFile;
import 'package:get/get_connect/http/src/interceptors/get_modifiers.dart';

import '../../models/product.dart';
import '../models/category.dart';
import '../models/currency.dart';
import '../repositories/category_repo.dart';
import '../repositories/product_repo.dart';
import '../repositories/settings_repo.dart';
import '../tools/image_picker.dart';
import 'package:path/path.dart';

class ProductController extends GetxController {
  List<Product> products = [];
  List<Product> favorites = [];
  List<File> images = [];
  List<Currency> currencies = [];
  List<Region> regions = [];

  bool isFetchingProducts = false;
  bool isFetchingMore = false;
  bool isFetchingProductDetails = false;
  bool isFetchingFavorites = false;
  bool isFetchingCategory = false;
  bool isLoading = false;

  Category? _selectedCategory;

  final int limit = 20;
  int offset = 0;

  Product? _selectedProduct;
  Product? _productDetail;

  final _productRepo = Get.find<ProductRepo>();
  final _settingsRepo = Get.find<SettingsRepo>();
  final _categoryRepo = Get.find<CategoryRepo>();

  set selectedProduct(Product product) {
    _selectedProduct = product;
    fetchProductDetails();
  }

  Category? get selectedCategory => _selectedCategory;
  set selectedCategory(Category? category) {
    _selectedCategory = category;
    _fetchCategoryDetails();
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

  Future<AppResponse<Product>> createNewProduct(params) async {
    isLoading = true;
    update();

    if (images.isNotEmpty) {
      final multipartImages = <MultipartFile>[];
      for (final image in images) {
        multipartImages.add(MultipartFile.fromBytes(
          await image.readAsBytes(),
          filename: basename(image.path),
        ));
      }
      params['images[]'] = multipartImages;
    }
    params['user_id'] = LocaleStorage.currentUser?.id;
    final result = await _productRepo.createProduct(params);

    isLoading = true;
    update();

    return result;
  }

  Future<void> _fetchCategoryDetails() async {
    if (_selectedCategory != null) {
      isFetchingCategory = true;
      update();

      final response =
          await _categoryRepo.fetchCategoryDetails(_selectedCategory!.id);
      if (response.status) {
        _selectedCategory = response.data;
      }

      isFetchingCategory = false;
      update();
    }
  }

  Future<void> fetchCurrencies() async {
    final response = await _settingsRepo.fetchCurrencies();
    if (response.status) {
      currencies = response.data!;
      update();
    }
  }

  Future<void> fetchRegions() async {
    final response = await _settingsRepo.fetchRegions();
    if (response.status) {
      regions = response.data!;
      update();
    }
  }

  Future<void> pickImages() async {
    images = await ImagePicker.pickImages();
    update();
  }

  void removeImage(int index) {
    images.removeAt(index);
    update();
  }
}
