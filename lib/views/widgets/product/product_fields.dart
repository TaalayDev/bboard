import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';

import '../../../resources/theme.dart';
import '../../widgets/styled_app_dropdown.dart';
import '../app_network_image.dart';
import '../custom_card.dart';

class ProductFields extends StatelessWidget {
  const ProductFields({
    Key? key,
    this.images = const [],
    this.onPickImagesTap,
  }) : super(key: key);

  final List<Asset> images;
  final Function()? onPickImagesTap;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const _Title(text: 'Фотографии'),
          CustomCard(
            child: ImagesGrid(
              images: images,
              onTap: onPickImagesTap,
            ),
          ),
          const SizedBox(height: 20),
          const _Title(text: 'Категория *'),
          CustomCard(
            padding: EdgeInsets.zero,
            child: ListTile(
              leading: const Icon(Feather.settings),
              title: const Text('Услуги > Красота и здоровье'),
              subtitle: Text(
                'Нарашивание ресниц',
                style: TextStyle(
                  color: Theme.of(context).primary,
                  fontSize: 16,
                ),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
          ),
          const SizedBox(height: 30),
          const _Title(text: 'Загаловок *'),
          CustomCard(
            padding: EdgeInsets.zero,
            child: TextFormField(
              maxLength: 100,
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
              decoration: const InputDecoration(
                hintText: 'Подробно опишите свой товар или услугу. '
                    'Напишите про хараутеристики, особенности и сосьояние',
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                counterText: '',
              ),
              maxLines: 5,
              maxLength: 550,
            ),
          ),
          const SizedBox(height: 30),
          const _Title(text: 'Цена'),
          CustomCard(
            padding: EdgeInsets.zero,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    maxLength: 100,
                    decoration: const InputDecoration(
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      counterText: '',
                    ),
                  ),
                ),
                Expanded(
                  child: StyledAppDropDown(
                    list: ['сом', '\$'],
                    displayItem: (item) => item.toString(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
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
                            ? AssetThumb(
                                asset: images[index - 1],
                                height: 500,
                                width: 500,
                              )
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
                                onRemove?.call(index);
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
