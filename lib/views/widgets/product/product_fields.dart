import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';

import '../../../res/theme.dart';
import '../../../data/models/category.dart';
import '../../../data/models/city.dart';
import '../../../data/models/currency.dart';
import '../../../data/models/custom_attribute.dart';
import '../../../data/models/district.dart';
import '../../../data/models/region.dart';
import '../../../helpers/helper_functions.dart' as helper;
import '../../screens/add_phone/add_phone_screen.dart';
import '../app_button.dart';
import '../app_network_image.dart';
import '../custom_card.dart';
import '../custom_select.dart';
import '../form_builder.dart';

class ProductFields extends StatelessWidget {
  const ProductFields({
    Key? key,
    required this.formController,
    required this.category,
    this.images = const [],
    this.currencies = const [],
    this.regions = const [],
    this.loadingCategory = false,
    this.isSending = false,
    this.onPickImagesTap,
    this.onRemoveImage,
    this.onCategoryTap,
    this.onSendTap,
    this.buttonText,
  }) : super(key: key);

  final String? buttonText;
  final FormBuilderController formController;
  final bool loadingCategory;
  final bool isSending;
  final Category? category;
  final List<File> images;
  final List<Currency> currencies;
  final List<Region> regions;
  final Function()? onPickImagesTap;
  final Function(int index)? onRemoveImage;
  final Function()? onCategoryTap;
  final Function(Map<String, dynamic> params)? onSendTap;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FormBuilder(
          controller: formController,
          builder: (context) {
            final category = this.category;
            final region = formController.getValue<Region>('region');
            final city = formController.getValue<City>('city');
            final phones = formController.getValue<List<String>>('phones[]');

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const _Title(text: 'Фотографии'),
                CustomCard(
                  child: ImagesGrid(
                    images: images,
                    onTap: onPickImagesTap,
                    onRemove: onRemoveImage,
                  ),
                ),
                if (category != null) ...[
                  const SizedBox(height: 20),
                  const _Title(text: 'Категория *'),
                  CustomCard(
                    padding: EdgeInsets.zero,
                    child: ListTile(
                      onTap: onCategoryTap,
                      leading: const Icon(Feather.settings),
                      title: loadingCategory
                          ? Shimmer.fromColors(
                              child: const Text('Загрузка категорий...'),
                              baseColor: Colors.white,
                              highlightColor: Colors.grey,
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (category.parent != null)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 3.0),
                                    child: Text(helper
                                        .getParentsTree(category.parent!)),
                                  ),
                                Text(
                                  category.name,
                                  style: TextStyle(
                                    color: context.theme.primary,
                                    fontSize: 16,
                                  ),
                                )
                              ],
                            ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                    ),
                  ),
                ],
                const SizedBox(height: 30),
                const _Title(text: 'Загаловок *'),
                CustomCard(
                  padding: EdgeInsets.zero,
                  child: TextFormField(
                    maxLength: 100,
                    initialValue: formController.getValue('title'),
                    onChanged: (value) {
                      formController.setValue('title', value);
                    },
                    decoration: const InputDecoration(
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      counterText: '',
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const _Title(text: 'Описание *'),
                CustomCard(
                  padding: EdgeInsets.zero,
                  child: TextFormField(
                    initialValue: formController.getValue('description'),
                    onChanged: (value) {
                      formController.setValue('description', value);
                    },
                    decoration: const InputDecoration(
                      hintText: 'Подробно опишите свой товар или услугу. '
                          'Напишите про характеристики, особенности и состояние',
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      counterText: '',
                    ),
                    maxLines: 5,
                    maxLength: 550,
                  ),
                ),
                const SizedBox(height: 30),
                const _Title(text: 'Цена *'),
                CustomCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      TextFormField(
                        maxLength: 100,
                        keyboardType: TextInputType.number,
                        initialValue: formController.getValue('price'),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (value) {
                          formController.setValue('price', value);
                        },
                        decoration: const InputDecoration(
                          hintText: 'Цена',
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          counterText: '',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: CustomSelect<Currency>(
                          title: 'Валюта ',
                          list: currencies,
                          value: formController.getValue('currency_id'),
                          onChanged: (value) {
                            formController.setValue('currency_id', value);
                          },
                          valueItem: (item) => item.id,
                          displayItem: (item) => item.symbol,
                        ),
                      ),
                      /*
                      const Divider(height: 0),
                      ListTile(
                        contentPadding:
                            const EdgeInsets.only(left: 25, right: 15),
                        title: const Text('Договорная'),
                        trailing: Switch.adaptive(
                          value: formController.getValue('negotiable') ?? false,
                          onChanged: (value) {
                            formController.setValue('negotiable', value);
                          },
                        ),
                      ),
                      */
                    ],
                  ),
                ),
                if (category?.customAttributes != null &&
                    category!.customAttributes.isNotEmpty) ...[
                  const SizedBox(height: 30),
                  const _Title(text: 'Дополнительные параметры'),
                  CustomCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: category.customAttributes.map((e) {
                        if (e.type == CustomAttributeType.STRING ||
                            e.type == CustomAttributeType.TEXT) {
                          return TextFormField(
                            maxLength: 100,
                            initialValue: formController.getValue(e.name),
                            onChanged: (value) {
                              formController.setValue(e.name, value);
                            },
                            decoration: InputDecoration(
                              hintText: e.title,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              counterText: '',
                            ),
                          );
                        }

                        if (e.type == CustomAttributeType.SELECT ||
                            e.type == CustomAttributeType.MULTISELECT) {
                          var values = jsonDecode(e.values ?? '');
                          if (values is Map) {
                            values = values.values.map((e) => e).toList();
                          }

                          return CustomSelect(
                            list:
                                values != null && values is List ? values : [],
                            displayItem: (value) => value.toString(),
                            value: formController.getValue(e.name),
                            onChanged: (value) {
                              formController.setValue(e.name, value);
                            },
                            title: e.title,
                            multiple: e.type == CustomAttributeType.MULTISELECT,
                          );
                        }

                        if (e.type == CustomAttributeType.INT ||
                            e.type == CustomAttributeType.DOUBLE) {
                          return TextFormField(
                            maxLength: 100,
                            keyboardType: TextInputType.number,
                            initialValue: formController.getValue(e.name),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onChanged: (value) {
                              formController.setValue(e.name, value);
                            },
                            decoration: InputDecoration(
                              hintText: e.title,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              counterText: '',
                            ),
                          );
                        }

                        if (e.type == CustomAttributeType.BOOLEAN) {
                          return ListTile(
                            contentPadding:
                                const EdgeInsets.only(left: 25, right: 15),
                            title: Text(e.title),
                            trailing: Switch.adaptive(
                              value: formController.getValue(e.name) ?? false,
                              onChanged: (value) {
                                formController.setValue(e.name, value);
                              },
                            ),
                          );
                        }

                        return Text(e.title);
                      }).toList(),
                    ),
                  ),
                ],
                const SizedBox(height: 30),
                const _Title(text: 'Видео'),
                CustomCard(
                  padding: EdgeInsets.zero,
                  child: TextFormField(
                    maxLength: 100,
                    initialValue: formController.getValue('video'),
                    onChanged: (value) {
                      formController.setValue('video', value);
                    },
                    decoration: const InputDecoration(
                      hintText: 'Ссылка на YouTube',
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      counterText: '',
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const _Title(text: 'Расположение *'),
                CustomCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      CustomSelect<Region>(
                        list: regions,
                        displayItem: (value) => value.name,
                        valueItem: (value) => value,
                        value: formController.getValue('region'),
                        onChanged: (value) {
                          formController.setValue('region', value);
                        },
                        title: 'Регион',
                      ),
                      CustomSelect<City>(
                        list: region?.cities ?? [],
                        displayItem: (value) => value.name,
                        valueItem: (value) => value,
                        value: formController.getValue('city'),
                        onChanged: (value) {
                          formController.setValue('city', value);
                        },
                        title: 'Город',
                      ),
                      CustomSelect<District>(
                        list: city?.districts ?? [],
                        displayItem: (value) => value.name,
                        valueItem: (value) => value.name,
                        value: formController.getValue('district'),
                        onChanged: (value) {
                          formController.setValue('district', value);
                        },
                        title: 'Район',
                      ),
                    ],
                  ),
                ),
                if (phones != null) ...[
                  const SizedBox(height: 30),
                  const _Title(text: 'Телефон *'),
                  CustomCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...phones.asMap().entries.map((item) {
                          return ListTile(
                            title: Text('+${item.value}'),
                            trailing: item.key != 0
                                ? TextButton(
                                    onPressed: () {
                                      phones.remove(item.value);
                                      formController.setValue(
                                          'phones[]', phones);
                                    },
                                    child: Icon(
                                      Icons.delete_outline,
                                      size: 18,
                                      color: context.theme.accent,
                                    ),
                                  )
                                : null,
                          );
                        }).toList(),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: TextButton(
                            onPressed: () async {
                              final phone = await Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) => AddPhoneScreen()));
                              if (phone != null && !phones.contains(phone)) {
                                phones.add(phone);
                                formController.setValue('phones[]', phones);
                              }
                            },
                            child: const Text('Добавить телефон'),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: AppButton(
                    text: buttonText ?? 'Подать объявление',
                    loading: isSending,
                    onPressed: () {
                      final values = {...formController.getValues()};
                      final requiredKeys = [
                        'title',
                        'description',
                        'category_id',
                        'region',
                        'city'
                      ];
                      bool hasErrors = false;
                      for (final key in requiredKeys) {
                        if (!values.containsKey(key)) {
                          hasErrors = true;
                          formController.seError(key, 'Это поле обязательна');
                        }
                      }
                      if (hasErrors) {
                        /*Get.snackbar(
                          'app_title'.tr,
                          'Вы не заполнили все обязательные поля',
                        );*/
                        // TODO: add snackbar
                        return;
                      }
                      values['region_id'] = values['region'].id;
                      values.remove('region');
                      values['city_id'] = values['city'].id;
                      values.remove('city');

                      onSendTap?.call(values);
                    },
                  ),
                ),
                const SizedBox(height: 100),
              ],
            );
          }),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, bottom: 8),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}

class ImagesGrid extends StatelessWidget {
  const ImagesGrid({
    Key? key,
    required this.images,
    this.isAsset = true,
    this.onTap,
    this.onRemove,
  }) : super(key: key);

  final List images;
  final bool isAsset;
  final Function()? onTap;
  final Function(int index)? onRemove;

  @override
  Widget build(BuildContext context) {
    return StaggeredGridView.countBuilder(
      primary: false,
      shrinkWrap: true,
      crossAxisCount: 6,
      itemCount: images.length + 1,
      itemBuilder: (BuildContext context, int index) {
        return index == 0
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    // color: Theme.of(context).greyWeak,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: InkWell(
                    onTap: onTap,
                    radius: 8.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera,
                          size: 30,
                          color: Theme.of(context).greyMedium,
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: Text(
                            'Добавить изображение',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Theme.of(context).primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : Container(
                height: 110,
                width: 110,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Theme.of(context).greyWeak,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: isAsset
                            ? images[index - 1] != null
                                ? kIsWeb
                                    ? Image.network(
                                        images[index - 1].path,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.file(
                                        images[index - 1],
                                        fit: BoxFit.cover,
                                      )
                                : SizedBox()
                            : AppNetworkImage(
                                imageUrl: images[index - 1].image,
                              ),
                      ),
                    ),
                    isAsset
                        ? Positioned(
                            top: -10,
                            right: -10,
                            child: IconButton(
                              onPressed: () {
                                onRemove?.call(index - 1);
                              },
                              icon: Container(
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                  color: Colors.redAccent,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
              );
      },
      staggeredTileBuilder: (int index) =>
          StaggeredTile.fit(images.isEmpty ? 6 : 2),
      mainAxisSpacing: 10,
      crossAxisSpacing: 15,
    );
  }
}
