import 'package:bboard/helpers/helper.dart';
import 'package:bboard/tools/locale_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';

import '../../../resources/theme.dart';
import '../../widgets/comments_list.dart';
import '../../widgets/custom_app_bar.dart';
import 'comments_page_controller.dart';

class CommentsPage extends StatelessWidget {
  CommentsPage({
    Key? key,
  }) : super(key: key);

  final _commentsScrollController = ScrollController();
  final _commentFocus = FocusNode();
  final _commentTextCont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CommentsPageController>(
      init: CommentsPageController(),
      builder: (controller) {
        return Scaffold(
          appBar: const CustomAppBar(
            title: 'Комментарии',
            actions: [],
          ),
          body: controller.fetchingComments
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : controller.comments.isNotEmpty
                  ? Column(
                      children: [
                        Flexible(
                          fit: FlexFit.tight,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 15, left: 15, right: 15),
                            child: CommentsList(
                              scrollController: _commentsScrollController,
                              comments: controller.comments
                                  .where((element) => element.parentId == null)
                                  .toList(),
                              onReply: (comment) {
                                controller.replyingTo = comment;
                              },
                              onRemove: (comment) {
                                Get.defaultDialog(
                                  title: 'Вы действительно хотите удалить'
                                      ' этот комментарий?',
                                  titleStyle: const TextStyle(fontSize: 16),
                                  titlePadding: const EdgeInsets.only(
                                      top: 10, left: 15, right: 15),
                                  content: const SizedBox(),
                                  confirm: TextButton(
                                    onPressed: () async {
                                      Get.back();
                                      final loader = Helper.showLoader(context);
                                      final result = await controller
                                          .removeComment(comment.id);
                                      if (!result) {
                                        Get.snackbar('app_title'.tr,
                                            'Проверьте ваше подключение!');
                                      }
                                      loader.remove();
                                    },
                                    child: Text('yes'.tr),
                                  ),
                                  cancel: TextButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: Text(
                                      'no'.tr,
                                      style: TextStyle(color: Colors.redAccent),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 15.0, left: 15, right: 15),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              RawKeyboardListener(
                                focusNode: FocusNode(),
                                onKey: (event) {
                                  if (event.logicalKey ==
                                          LogicalKeyboardKey.backspace &&
                                      _commentTextCont.text.isEmpty) {
                                    controller.replyingTo = null;
                                  }
                                },
                                child: TextField(
                                  focusNode: _commentFocus,
                                  controller: _commentTextCont,
                                  decoration: InputDecoration(
                                    prefixIcon: controller.replyingTo != null
                                        ? Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const SizedBox(width: 10),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 5,
                                                        horizontal: 5),
                                                decoration: BoxDecoration(
                                                  color: Get.theme.grey
                                                      .withOpacity(0.3),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                child: Text(
                                                  '@${controller.replyingTo?.user?.name}',
                                                  style: TextStyle(
                                                      color:
                                                          Get.theme.greyMedium),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                            ],
                                          )
                                        : null,
                                    hintText: 'your comment'.tr,
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 5,
                                child: IconButton(
                                  onPressed: () async {
                                    if (LocaleStorage.isLogin) {
                                      if (_commentTextCont.text.isNotEmpty) {
                                        final loader =
                                            Helper.showLoader(context);
                                        await controller.createComment(
                                            _commentTextCont.text);
                                        loader.remove();

                                        _commentTextCont.clear();
                                        _commentFocus.unfocus();
                                        if (controller.replyingTo != null) {
                                          controller.replyingTo = null;
                                        } else {
                                          await _commentsScrollController
                                              .animateTo(
                                            _commentsScrollController
                                                .position.minScrollExtent,
                                            duration: const Duration(
                                                milliseconds: 500),
                                            curve: Curves.fastOutSlowIn,
                                          );
                                        }
                                      }
                                    } else {
                                      Get.snackbar('app_title'.tr,
                                          'login to leave comment'.tr);
                                    }
                                  },
                                  icon: Icon(Icons.send),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Feather.message_square, color: context.theme.grey),
                        const SizedBox(height: 15, width: double.infinity),
                        Text(
                          'Здесь пока нет комментариев \nБудьте первым'.tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: context.theme.grey),
                        ),
                      ],
                    ),
        );
      },
    );
  }
}
