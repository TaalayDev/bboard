import 'dart:io';

import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';

import '../../../cubit/product/product_form_cubit.dart';
import '../../../data/data_provider.dart';
import '../../../data/models/product.dart';
import '../../../helpers/helper_functions.dart';
import '../../../res/routes.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/form_builder.dart';
import '../../widgets/product/product_fields.dart';
import '../create/select_category_screen.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({
    Key? key,
    required this.productId,
  }) : super(key: key);

  final int productId;

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  late final FormBuilderController formController;

  @override
  void initState() {
    WidgetsBinding.instance?.addPersistentFrameCallback((timeStamp) {
      context.read<ProductFormCubit>()
        ..fetchCurrencies()
        ..fetchRegions();
    });
    super.initState();
  }

  @override
  void dispose() {
    clearTemporaryFiles();
    super.dispose();
  }

  Future<List<File>> saveProductImages(Product product) async {
    final files = <File>[];
    for (final image in product.media) {
      final file = await fileFromUrl(image.originalUrl ?? '');
      if (file != null) {
        files.add(file);
      }
    }

    return files;
  }

  void clearTemporaryFiles() async {
    try {
      final dir = await getTemporaryDirectory();
      dir.deleteSync(recursive: true);
      dir.create();
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProductFormCubit>();
    return Scaffold(
      appBar: const CustomAppBar(
        backIcon: Icon(Icons.close),
        title: 'Изменить объявление',
      ),
      body: BlocListener<ProductFormCubit, ProductFormState>(
        listener: (context, state) {
          switch (state.status) {
            case ProductFormStatus.success:
              FlushbarHelper.createSuccess(
                message: 'Ваше объявление обновлено успешно!',
              ).show(context);
              break;
            case ProductFormStatus.error:
              FlushbarHelper.createError(
                message: 'Ошибка при добавлении! Проверьте ваше подключение',
              ).show(context);
              break;
            default:
          }
        },
        listenWhen: (oldState, newState) => oldState.status != newState.status,
        child: BlocListener<ProductFormCubit, ProductFormState>(
          listener: (context, state) async {
            final product = state.product;
            if (product == null) return;

            final customValues = <String, dynamic>{};
            if (product.hasCustomAttributeValues) {
              for (final ca in product.customAttributeValues!) {
                customValues[ca.customAttribute?.name ?? ''] = ca.value;
              }
            }

            formController = FormBuilderController(values: {
              'title': product.title,
              'description': product.description,
              'price': product.price.toString(),
              'video': product.video,
              'phones[]': product.phones,
              'category_id': product.categoryId.toString(),
              'region': product.region,
              'region_id': product.regiondId,
              'city': product.city,
              'city_id': product.cityId,
              'currency_id': product.currencyId,
              ...customValues,
            });
            cubit.setCategory(product.category);

            final files = await saveProductImages(product);
            cubit.changeProductImages(files);
          },
          listenWhen: (oldState, newState) =>
              oldState.isLoadingProduct != newState.isLoadingProduct,
          child: BlocBuilder<ProductFormCubit, ProductFormState>(
            builder: (context, state) {
              if (state.isLoadingProduct) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }

              return ProductFields(
                formController: formController,
                images: state.images,
                category: state.category,
                currencies: state.currencies,
                regions: state.regions,
                loadingCategory: state.isLoadingCategory,
                isSending: state.isLoading,
                onCategoryTap: () async {
                  final category = await Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => const SelectCategoryScreen()),
                  );
                  if (category != null) {
                    cubit.setCategory(category);
                    formController.setValue('category_id', category.id);
                  }
                },
                onPickImagesTap: cubit.pickImages,
                onRemoveImage: cubit.removeImage,
                buttonText: 'Сохранить объявление',
                onSendTap: (values) async {
                  final result =
                      await cubit.updateProduct(widget.productId, values);
                  if (result != null) {
                    context
                      ..read<DataProvider>().product.value = result
                      ..go(Routes.productDetails(result.id));
                    Navigator.pop(context);
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
