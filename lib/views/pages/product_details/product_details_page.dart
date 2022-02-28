import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:oktoast/oktoast.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../controllers/product_controller.dart';
import '../../../models/product.dart';
import '../../../resources/constants.dart';
import '../../../resources/theme.dart';
import '../../../tools/app_router.dart';
import '../../../views/widgets/app_button.dart';
import '../../widgets/app_carousel.dart';
import '../../widgets/app_image.dart';
import '../../widgets/app_network_image.dart';
import '../../widgets/youtube_player.dart';

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
          GetBuilder<ProductController>(builder: (controller) {
            return IconButton(
              icon: const Icon(Feather.share),
              onPressed: () {
                final productDetails = controller.productDetails;
                Share.share(
                  '${productDetails?.title}\n${productDetails?.shareLink}',
                );
              },
            );
          }),
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Feather.more_horizontal),
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButton: GetBuilder<ProductController>(
        builder: (controller) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
            child: AppButton(
              text: 'call'.tr,
              onPressed: () {
                showPhonesBottomSheet(
                  context,
                  controller.productDetails?.phones ?? [],
                );
              },
            ),
          );
        },
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
                        Stack(
                          children: [
                            Container(
                              color: context.theme.surface,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    height: 350,
                                    child: AppCarousel(
                                      productDetails.media
                                          .map((e) => e.originalUrl!)
                                          .toList(),
                                      heroTag:
                                          'product_${productDetails.id}_image',
                                      video: productDetails.video,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    child: Row(
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
                                  ),
                                  const Divider(),
                                ],
                              ),
                            ),
                            if (productDetails.video != null &&
                                productDetails.video!.isNotEmpty)
                              Positioned(
                                bottom: 18,
                                right: 15,
                                child: Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                  child: SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: InkWell(
                                      child: Icon(
                                        MaterialCommunityIcons.youtube,
                                        color: context.theme.accent,
                                        size: 24,
                                      ),
                                      onTap: () {
                                        Get.dialog(
                                          Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                child: YoutubePlayer(
                                                  videoUrl:
                                                      productDetails.video!,
                                                ),
                                              ),
                                              Positioned(
                                                top: 10,
                                                right: 10,
                                                child: Material(
                                                  color: Colors.transparent,
                                                  child: CloseButton(
                                                    color: Colors.white,
                                                    onPressed: () {
                                                      Get.back();
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          color: context.theme.surface,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                                                  e.value ?? '',
                                                  style: const TextStyle(
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
                              Text(productDetails.description),
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
                                onTap: () {
                                  if (productDetails.comments.isNotEmpty) {
                                    Get.toNamed(AppRouter.comments,
                                        arguments: productDetails.id);
                                  }
                                },
                                title: Text(
                                  productDetails.comments.isEmpty
                                      ? 'Комментариев нет'
                                      : '${productDetails.comments.length} комментариев',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                              const Divider(height: 1),
                              ListTile(
                                onTap: () {
                                  Clipboard.setData(ClipboardData(
                                    text: productDetails.shareLink,
                                  )).then((value) {
                                    showToast('Ссылка скопирована');
                                  });
                                },
                                title: const Text(
                                  'Скопировать ссылку',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                              const Divider(height: 1),
                              ListTile(
                                onTap: () {
                                  Get.toNamed(AppRouter.complaint,
                                      arguments: productDetails);
                                },
                                title: const Text(
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
                                  /*CircleAvatar(
                                    child: AppImage(Assets.instagramRound),
                                  ),*/
                                  InkWell(
                                    onTap: () {
                                      launch(
                                          'https://www.facebook.com/sharer/sharer.php?u=${productDetails.shareLink}');
                                    },
                                    borderRadius: BorderRadius.circular(50),
                                    child: const CircleAvatar(
                                      child: AppImage(Assets.facebookRound),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      launch(
                                          'https://connect.ok.ru/offer?url=${productDetails.shareLink}&title=${productDetails.title}');
                                    },
                                    borderRadius: BorderRadius.circular(50),
                                    child: const CircleAvatar(
                                      child:
                                          AppImage(Assets.odnoklassnikiRound),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      launch(
                                          'http://vk.com/share.php?url=${productDetails.shareLink}&text=${productDetails.title}');
                                    },
                                    borderRadius: BorderRadius.circular(50),
                                    child: const CircleAvatar(
                                      child: AppImage(Assets.vkRound),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      launch(
                                          'http://twitter.com/share?url=${productDetails.shareLink}&text=${productDetails.title}');
                                    },
                                    borderRadius: BorderRadius.circular(50),
                                    child: const CircleAvatar(
                                      child: AppImage(Assets.twitterRound),
                                    ),
                                  ),
                                  Container(
                                    height: 38,
                                    width: 38,
                                    decoration: BoxDecoration(
                                      color:
                                          context.theme.grey.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(40),
                                      onTap: () {
                                        Share.share(
                                            '${productDetails.title}\n${productDetails.shareLink}');
                                      },
                                      child: const Icon(
                                        Icons.more_horiz,
                                        color: Colors.white,
                                      ),
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

  Future<void> showPhonesBottomSheet(
      BuildContext context, List<String> phones) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0, top: 5, bottom: 5),
                child: Row(
                  children: [
                    const Text(
                      'Выберите номер',
                      style: TextStyle(fontSize: 16),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(MaterialCommunityIcons.close),
                    ),
                  ],
                ),
              ),
            ),
            if (phones.isNotEmpty) ...[
              ...phones.map((e) {
                if (e.isNotEmpty) {
                  return ListTile(
                    title: Text('+ $e'),
                    onTap: () {
                      launch('tel: +$e');
                    },
                  );
                }

                return const SizedBox();
              }),
            ] else
              SizedBox(
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('Кажется, тут пусто'),
                  ],
                ),
              ),
            const SizedBox(height: 15),
          ],
        );
      },
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
        onTap: () {
          Get.toNamed(AppRouter.userProducts, arguments: productDetails.user);
        },
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
          style: const TextStyle(
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
                '${productDetails.user!.activeCount ?? 0} объявлений пользователя',
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
