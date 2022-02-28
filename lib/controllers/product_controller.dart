import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart' hide MultipartFile;
import 'package:path/path.dart';

import '../../models/product.dart';
import '../models/app_reponse.dart';
import '../models/category.dart';
import '../models/currency.dart';
import '../models/region.dart';
import '../repositories/category_repo.dart';
import '../repositories/product_repo.dart';
import '../repositories/settings_repo.dart';
import '../tools/image_picker.dart';
import '../tools/locale_storage.dart';

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
  bool hasReachedMax = false;

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

  Future<void> fetchProducts({String? search}) async {
    if (!isFetchingProducts) {
      offset = 0;
      hasReachedMax = false;

      isFetchingProducts = true;
      update();

      final params = {
        'offset': offset,
        'limit': limit,
        'with': 'user',
        'orderBy': 'created_at',
        'sortedBy': 'desc',
      };
      if (search != null && search.isNotEmpty) {
        params['search'] = 'title:$search;description:$search';
        params['searchFields'] = 'title:like;description:like';
      }

      products = await _fetchProducts(params: params);

      isFetchingProducts = false;
      update();
    }
  }

  Future<void> fetchMoreProducts({String? search}) async {
    if (!isFetchingMore && !hasReachedMax) {
      offset += limit;

      isFetchingMore = true;
      update();

      final params = {
        'offset': offset,
        'limit': limit,
        'with': 'user',
        'orderBy': 'created_at',
        'sortedBy': 'desc',
      };
      if (search != null && search.isNotEmpty) {
        params['search'] = search;
      }
      final p = await _fetchProducts(params: params);
      if (p.isNotEmpty) {
        products.addAll(p);
      } else {
        hasReachedMax = true;
      }

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

  Future<void> addToFavorites(Product product) async {
    product.isFavorite = true;
    update();

    final appResponse = await _productRepo.addToFavorites(product.id);
    if (appResponse.status) {
      favorites.add(product);
    } else {
      product.isFavorite = false;
    }

    update();
  }

  Future<void> removeFromFavorites(Product product) async {
    product.isFavorite = false;
    update();

    final appResponse = await _productRepo.removeFromFavorites(product.id);
    if (appResponse.status) {
      if (favorites.contains(product)) {
        favorites.remove(product);
      }
      update();
    } else {
      product.isFavorite = true;
    }

    update();
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

    isLoading = false;
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
