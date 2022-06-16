import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../cubit/product/product_form_cubit.dart';
import '../../../data/data_provider.dart';
import '../../../res/routes.dart';
import '../../../data/models/category.dart';
import '../../../data/storage.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/form_builder.dart';
import '../../widgets/product/product_fields.dart';
import 'select_category_screen.dart';

class CreateProductScreen extends StatefulWidget {
  const CreateProductScreen({
    Key? key,
    this.category,
  }) : super(key: key);

  final Category? category;

  @override
  State<CreateProductScreen> createState() => _CreateProductScreenState();
}

class _CreateProductScreenState extends State<CreateProductScreen> {
  final FormBuilderController formController = FormBuilderController(values: {
    'phones[]': [
      LocaleStorage.currentUser?.phone ?? '',
    ],
  });

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      final cubit = context.read<ProductFormCubit>()
        ..fetchCurrencies()
        ..fetchRegions();
      formController.setValue(
        'category_id',
        cubit.state.category?.id,
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProductFormCubit>();
    return Scaffold(
      appBar: const CustomAppBar(
        backIcon: Icon(Icons.close),
        title: 'Создать объявление',
      ),
      body: BlocListener<ProductFormCubit, ProductFormState>(
        listener: (context, state) {
          switch (state.status) {
            case ProductFormStatus.success:
              FlushbarHelper.createSuccess(
                message: 'Ваше объявление отправлено на модерацию!',
              ).show(context);
              break;
            case ProductFormStatus.error:
              FlushbarHelper.createError(
                message: 'Ошибка при добавлении! Проверьте ваше подключение',
              ).show(context);
              break;
            default:
              if (state.regions.isNotEmpty) {
                final region = state.regions[0];
                formController.setValue('region', state.regions[0]);
                if (region.cities != null && region.cities!.isNotEmpty) {
                  formController.setValue('city', region.cities![0]);
                }
              }
          }
        },
        listenWhen: (oldState, newState) =>
            (oldState.regions.isEmpty && newState.regions.isNotEmpty) ||
            oldState.status != newState.status,
        child: BlocBuilder<ProductFormCubit, ProductFormState>(
          builder: (context, state) {
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
                    builder: (_) => const SelectCategoryScreen(),
                  ),
                );
                if (category != null) {
                  cubit.setCategory(category);
                  formController.setValue('category_id', category.id);
                }
              },
              onPickImagesTap: cubit.pickImages,
              onRemoveImage: cubit.removeImage,
              onSendTap: (values) async {
                final result = await cubit.createProduct(values);
                print('result $result');
                if (result != null) {
                  context
                    ..read<DataProvider>().product.value = result
                    ..go(Routes.productDetails(result.id));
                }
              },
            );
          },
        ),
      ),
    );
  }
}
