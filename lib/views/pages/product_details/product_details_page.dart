import 'package:bboard/models/custom_attribute.dart';
import 'package:bboard/models/custom_attribute_values.dart';
import 'package:bboard/models/product.dart';
import 'package:bboard/resources/constants.dart';
import 'package:bboard/views/widgets/app_image.dart';
import 'package:bboard/views/widgets/app_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../controllers/product_controller.dart';
import '../../../views/widgets/app_button.dart';
import '../../../views/widgets/image_slider.dart';
import '../../../resources/theme.dart';

final testPhones = ['996775776775', '8875546643'];

class ProductDetailsPage extends StatelessWidget {
  const ProductDetailsPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        actions: [
          IconButton(
            icon: const Icon(Feather.share),
            onPressed: () {},
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Feather.more_horizontal),
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButton: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
        child: _FloatingCallButton(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: RefreshIndicator(
        onRefresh: () async {
          await Get.find<ProductController>().fetchProductDetails();
        },
        child: GetBuilder<ProductController>(
          builder: (controller) {
            final productDetails = controller.productDetails;
            return productDetails != null
                ? SingleChildScrollView(
                    child: Column(
                      children: [
                        ImagesSlider(
                          images: productDetails.media
                              .map((e) => e.originalUrl!)
                              .toList(),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          color: context.theme.surface,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Icon(
                                    Feather.eye,
                                    size: 20,
                                    color: context.theme.grey,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    productDetails.views.toString(),
                                    style: TextStyle(
                                      color: context.theme.grey,
                                    ),
                                  )
                                ],
                              ),
                              const Divider(),
                              Text(
                                'Добавлено ' +
                                    Jiffy(productDetails.createdAt).fromNow(),
                                style: TextStyle(
                                  color: context.theme.secondTextColor,
                                ),
                              ),
                              const SizedBox(height: 15),
                              Text(
                                productDetails.title,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                productDetails.getPrice,
                                style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              if (productDetails.city != null) ...[
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    Icon(
                                      Feather.map_pin,
                                      color: context.theme.grey,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      productDetails.city!.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                              const SizedBox(height: 20),
                              Text(
                                'Категория',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: context.theme.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  if (productDetails.categoryParentsTree !=
                                      null)
                                    ...productDetails
                                        .categoryParentsTree!.reversed
                                        .map((e) => Text('${e.name} > '))
                                        .toList(),
                                  Text(productDetails.category?.name ?? '')
                                ],
                              ),
                              const SizedBox(height: 10),
                              if (productDetails.customAttributeValues != null)
                                ...productDetails.customAttributeValues!
                                    .map((e) => Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 8.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  e.customAttribute?.title ??
                                                      '',
                                                  style: TextStyle(
                                                    color: context
                                                        .theme.secondTextColor,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  e.value,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ))
                                    .toList(),
                              const Divider(),
                              const SizedBox(height: 5),
                              Text(productDetails.description +
                                  ' hbhsdbckbd shbcksbdkvb skjdbksdbvk skdjbcvkljsdbnv skjdbkjsbdv ksjdbk'),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (productDetails.user != null)
                          UserCard(productDetails: productDetails),
                        ListView.separated(
                          shrinkWrap: true,
                          itemBuilder: (context, index) => ListTile(
                            onTap: () {
                              launch('tel: ' + productDetails.phones[index]);
                            },
                            title: Text(
                              productDetails.phones[index],
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.blue,
                              ),
                            ),
                            trailing: const Icon(
                              Entypo.mobile,
                              color: Colors.blue,
                              size: 20,
                            ),
                            tileColor: context.theme.surface,
                          ),
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemCount: productDetails.phones.length,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: context.theme.surface,
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                onTap: () {},
                                title: Text(
                                  'Комментариев нет',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                              const Divider(height: 1),
                              ListTile(
                                onTap: () {},
                                title: Text(
                                  'Скопировать ссылку',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                              const Divider(height: 1),
                              ListTile(
                                onTap: () {},
                                title: Text(
                                  'Пожаловаться на объявление',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            color: context.theme.surface,
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Поделиться с друзьями',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 15),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CircleAvatar(
                                    child: AppImage(Assets.instagramRound),
                                  ),
                                  CircleAvatar(
                                    child: AppImage(Assets.facebookRound),
                                  ),
                                  CircleAvatar(
                                    child: AppImage(Assets.odnoklassnikiRound),
                                  ),
                                  CircleAvatar(
                                    child: AppImage(Assets.vkRound),
                                  ),
                                  CircleAvatar(
                                    child: AppImage(Assets.twitterRound),
                                  ),
                                  Container(
                                    height: 38,
                                    width: 38,
                                    decoration: BoxDecoration(
                                      color:
                                          context.theme.grey.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                    child: Icon(
                                      Icons.more_horiz,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 180),
                      ],
                    ),
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  );
          },
        ),
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  const UserCard({
    Key? key,
    required this.productDetails,
  }) : super(key: key);

  final Product productDetails;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      margin: const EdgeInsets.only(bottom: 15),
      color: context.theme.surface,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        leading: SizedBox(
          height: 50,
          width: 50,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40.0),
            child: AppNetworkImage(
              imageUrl: productDetails.user!.media?.originalUrl ?? '',
            ),
          ),
        ),
        title: Text(
          productDetails.user!.name ?? '',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 5.0,
                vertical: 5.0,
              ),
              margin: const EdgeInsets.only(top: 5.0),
              decoration: BoxDecoration(
                color: context.theme.greyWeak,
                borderRadius: BorderRadius.circular(6.0),
              ),
              child: Text(
                '7 объявлений пользователя',
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
        trailing: Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}

class _FloatingCallButton extends StatelessWidget {
  const _FloatingCallButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: 'call'.tr,
      onPressed: () {},
    );
  }
}
