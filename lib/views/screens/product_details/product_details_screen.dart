import 'package:another_flushbar/flushbar_helper.dart';
import 'package:bboard/res/globals.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:jiffy/jiffy.dart';
import 'package:oktoast/oktoast.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../cubit/product/product_details_cubit.dart';
import '../../../data/constants.dart';
import '../../../data/models/user.dart';
import '../../../data/storage.dart';
import '../../../helpers/helper_functions.dart';
import '../../../views/widgets/app_button.dart';
import '../../../data/data_provider.dart';
import '../../../data/events/events.dart';
import '../../../res/routes.dart';
import '../../../res/theme.dart';
import '../../widgets/app_carousel.dart';
import '../../widgets/app_image.dart';
import '../../widgets/app_network_image.dart';
import '../../widgets/dialogs.dart';
import '../../widgets/refresher.dart';
import '../../widgets/youtube_player.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({
    Key? key,
    required this.productId,
  }) : super(key: key);

  final int productId;

  void _copyLink(String link) {
    Clipboard.setData(ClipboardData(
      text: link,
    )).then((value) {
      showToast('Ссылка скопирована');
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductDetailsCubit(
        productId,
        productRepo: getIt.get(),
        dataProvider: context.read<DataProvider>(),
      )..fetchProductDetails(),
      child: BlocConsumer<ProductDetailsCubit, ProductDetailsState>(
        listener: (context, state) {
          switch (state.status) {
            case ProductDetailsStatus.addFav:
              sendAddedToFavoriteEvent(state.product!);
              break;
            case ProductDetailsStatus.remFav:
              sendRemovedFromFavoriteEvent(state.product!);
              break;
            default:
          }
        },
        listenWhen: (oldState, newState) => oldState.status != newState.status,
        builder: (context, state) {
          final product = state.product;
          if (state.isLoading && product == null) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }

          if (product == null) return const SizedBox();

          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Feather.share),
                  onPressed: () {
                    Share.share(
                      '${product.title}\n${product.shareLink}',
                    );
                  },
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: () async {
                    if (!product.isFavorite) {
                      context.read<ProductDetailsCubit>().addToFavorites();
                    } else {
                      context.read<ProductDetailsCubit>().removeFromFavorites();
                    }
                  },
                  icon: Icon(
                    product.isFavorite ? Icons.favorite : Icons.favorite_border,
                  ),
                ),
                const SizedBox(width: 10),
                PopupMenuButton(
                  icon: const Icon(Feather.more_horizontal),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: const Text('Скопировать ссылку'),
                      onTap: () => _copyLink(product.shareLink),
                    ),
                    PopupMenuItem(
                      child: const Text('Пожаловаться на объявление'),
                      onTap: () {
                        context.push(Routes.complaint(state.productId));
                      },
                    ),
                  ],
                  onSelected: (item) {},
                ),
              ],
            ),
            floatingActionButton: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 20,
              ),
              child: AppButton(
                text: 'call'.tr(),
                onPressed: () {
                  showPhonesBottomSheet(context, product.phones);
                },
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            body: Refresher(
              onRefresh: (refController) async {
                await context.read<ProductDetailsCubit>().fetchProductDetails();
                refController.refreshCompleted();
              },
              child: SingleChildScrollView(
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
                                  product.media
                                      .map((e) => e.originalUrl!)
                                      .toList(),
                                  heroTag: 'product_${product.id}_image',
                                  video: product.video,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Row(
                                  children: [
                                    Icon(
                                      Feather.eye,
                                      size: 20,
                                      color: context.theme.grey,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      product.views.toString(),
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
                        if (product.video != null && product.video!.isNotEmpty)
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
                                    showGeneralDialog(
                                      context: context,
                                      pageBuilder: (context, _, __) {
                                        return Dismissible(
                                          key: const ValueKey(
                                              'youtube_video_key'),
                                          direction: DismissDirection.vertical,
                                          onDismissed: (direction) {
                                            Navigator.pop(context);
                                          },
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 8.0,
                                                ),
                                                child: YoutubePlayer(
                                                  videoUrl: product.video!,
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
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
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
                            'Добавлено ' + Jiffy(product.createdAt).fromNow(),
                            style: TextStyle(
                              color: context.theme.secondTextColor,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            product.title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            product.getPrice,
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (product.city != null) ...[
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
                                  product.city!.name,
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
                              if (product.categoryParentsTree != null)
                                ...product.categoryParentsTree!.reversed
                                    .map((e) => Text('${e.name} > '))
                                    .toList(),
                              Text(product.category?.name ?? '')
                            ],
                          ),
                          const SizedBox(height: 10),
                          if (product.customAttributeValues != null)
                            ...product.customAttributeValues!
                                .map((e) => Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              e.customAttribute?.title ?? '',
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
                          Text(product.description),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (product.user != null) UserCard(user: product.user!),
                    ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context, index) => ListTile(
                        onTap: () {
                          launch('tel: ' + product.phones[index]);
                        },
                        title: Text(
                          product.phones[index],
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
                      itemCount: product.phones.length,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: context.theme.surface,
                      ),
                      child: Column(
                        children: [
                          if (product.canComment == 'all') ...[
                            ListTile(
                              onTap: () {
                                context.go(Routes.comments(product.id));
                              },
                              title: Text(
                                product.comments.isEmpty
                                    ? 'Комментариев нет'
                                    : '${product.comments.length} комментариев',
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                            const Divider(height: 1),
                          ],
                          ListTile(
                            onTap: () => _copyLink(product.shareLink),
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
                              context.go(Routes.complaint(product.id));
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
                    if (product.userId == LocaleStorage.currentUser?.id) ...[
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: context.theme.surface,
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              onTap: () {
                                context.push(Routes.editProduct(product.id));
                              },
                              title: const Text(
                                'Редактировать',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                            const Divider(height: 1),
                            ListTile(
                              onTap: () {
                                defaultDialog(
                                  context: context,
                                  title: 'Вы действительно хотите удалить'
                                      ' этот объявление?',
                                  titleStyle: const TextStyle(fontSize: 16),
                                  titlePadding: const EdgeInsets.only(
                                      top: 10, left: 15, right: 15),
                                  content: const SizedBox(),
                                  confirm: TextButton(
                                    onPressed: () async {
                                      context.pop();
                                      final loader = showLoader(context);

                                      final result = await context
                                          .read<ProductDetailsCubit>()
                                          .deleteProduct();

                                      loader.remove();

                                      if (result.status) {
                                        sendProductDeletedEvent(product);

                                        FlushbarHelper.createSuccess(
                                          message: 'Ваше объявление удалено!',
                                        ).show(context);

                                        Navigator.pop(context);
                                      } else {
                                        FlushbarHelper.createError(
                                          message:
                                              'Не удалось удалить объявление!',
                                        ).show(context);
                                      }
                                    },
                                    child: Text('yes'.tr()),
                                  ),
                                  cancel: TextButton(
                                    onPressed: () {
                                      context.pop();
                                    },
                                    child: Text(
                                      'no'.tr(),
                                      style: const TextStyle(
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              title: const Text(
                                'Удалить',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              /*CircleAvatar(
                                              child: AppImage(Assets.instagramRound),
                                            ),*/
                              InkWell(
                                onTap: () {
                                  launch(
                                      'https://www.facebook.com/sharer/sharer.php?u=${product.shareLink}');
                                },
                                borderRadius: BorderRadius.circular(50),
                                child: const CircleAvatar(
                                  child: AppImage(Assets.facebookRound),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  launch(
                                      'https://connect.ok.ru/offer?url=${product.shareLink}&title=${product.title}');
                                },
                                borderRadius: BorderRadius.circular(50),
                                child: CircleAvatar(
                                  backgroundColor: context.theme.surface,
                                  child: const AppImage(
                                    Assets.odnoklassnikiRound,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  launch(
                                      'http://vk.com/share.php?url=${product.shareLink}&text=${product.title}');
                                },
                                borderRadius: BorderRadius.circular(50),
                                child: const CircleAvatar(
                                  child: AppImage(Assets.vkRound),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  launch(
                                      'http://twitter.com/share?url=${product.shareLink}&text=${product.title}');
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
                                  color: context.theme.grey.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(40),
                                  onTap: () {
                                    Share.share(
                                      '${product.title}\n${product.shareLink}',
                                    );
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
              ),
            ),
          );
        },
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
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      margin: const EdgeInsets.only(bottom: 15),
      color: context.theme.surface,
      child: ListTile(
        onTap: () {
          context.push(Routes.userProducts(user.id ?? 0), extra: user);
        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        leading: SizedBox(
          height: 50,
          width: 50,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40.0),
            child: AppNetworkImage(
              imageUrl: user.media?.originalUrl ?? '',
            ),
          ),
        ),
        title: Text(
          user.name ?? '',
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
                '${user.activeCount ?? 0} объявлений пользователя',
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
