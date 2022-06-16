import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:path/path.dart';

import '../../data/models/product.dart';
import '../../data/data_provider.dart';
import '../../data/models/category.dart';
import '../../data/repositories/product_repo.dart';
import '../../data/repositories/settings_repo.dart';
import '../../data/models/currency.dart';
import '../../data/models/region.dart';
import '../../data/storage.dart';
import '../../helpers/image_picker.dart';

part 'product_form_state.dart';

class ProductFormCubit extends Cubit<ProductFormState> {
  ProductFormCubit({
    required IProductRepo productRepo,
    required ISettingsRepo settingsRepo,
    DataProvider? dataProvider,
  })  : _productRepo = productRepo,
        _settingsRepo = settingsRepo,
        super(ProductFormState(
          category: dataProvider?.category.value,
          product: dataProvider?.product.value,
        ));

  final IProductRepo _productRepo;
  final ISettingsRepo _settingsRepo;

  void setCategory(Category? category) {
    emit(state.copyWith(category: category));
  }

  Future<void> fetchCurrencies() async {
    final response = await _settingsRepo.fetchCurrencies();
    emit(state.copyWith(currencies: response.result));
  }

  Future<void> fetchRegions() async {
    final response = await _settingsRepo.fetchRegions();
    emit(state.copyWith(regions: response.result));
  }

  Future<void> pickImages() async {
    final images = await ImagePicker.pickImages();
    emit(state.copyWith(images: images));
  }

  void removeImage(int index) {
    emit(state.copyWith(images: state.images..removeAt(index)));
  }

  void changeProductImages(List<File> images) async {
    emit(state.copyWith(images: images));
  }

  Future<Product?> createProduct(Map<String, dynamic> params) async {
    emit(state.copyWith(isLoading: true));

    if (state.images.isNotEmpty) {
      final multipartImages = <MultipartFile>[];
      for (final image in state.images) {
        multipartImages.add(MultipartFile.fromBytes(
          await image.readAsBytes(),
          filename: basename(image.path),
        ));
      }
      params['images[]'] = multipartImages;
    }
    params['user_id'] = LocaleStorage.currentUser?.id;
    final response = await _productRepo.createProduct(params);

    emit(state.copyWith(
      isLoading: false,
      status:
          response.status ? ProductFormStatus.success : ProductFormStatus.error,
      error: response.errorData?.toString(),
    ));

    return response.result;
  }

  Future<Product?> updateProduct(int id, Map<String, dynamic> params) async {
    emit(state.copyWith(isLoading: true));

    if (state.images.isNotEmpty) {
      final multipartImages = <MultipartFile>[];
      for (final image in state.images) {
        multipartImages.add(MultipartFile.fromBytes(
          await image.readAsBytes(),
          filename: basename(image.path),
        ));
      }
      params['images[]'] = multipartImages;
    }
    final response = await _productRepo.updateProduct(id, params);

    emit(state.copyWith(
      isLoading: false,
      status:
          response.status ? ProductFormStatus.success : ProductFormStatus.error,
      error: response.errorData?.toString(),
    ));

    return response.result;
  }
}
