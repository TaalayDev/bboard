import 'package:another_flushbar/flushbar_helper.dart';
import 'package:bboard/res/globals.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:go_router/go_router.dart';

import '../../../bloc/user_bloc.dart';
import '../../../cubit/comments_cubit.dart';
import '../../../helpers/helper_functions.dart';
import '../../../res/theme.dart';
import '../../widgets/comments_list.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/dialogs.dart';

class CommentsScreen extends StatelessWidget {
  CommentsScreen({
    Key? key,
    required this.productId,
  }) : super(key: key);

  final int productId;

  final _commentsScrollController = ScrollController();
  final _commentFocus = FocusNode();
  final _commentTextCont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentsCubit, CommentsState>(
      bloc: CommentsCubit(productId, productRepo: getIt.get())
        ..fetchProductComments(),
      builder: (context, state) {
        return Scaffold(
          appBar: const CustomAppBar(
            title: 'Комментарии',
            actions: [],
          ),
          body: state.isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : state.comments.isNotEmpty
                  ? Column(
                      children: [
                        Flexible(
                          fit: FlexFit.tight,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 15, left: 15, right: 15),
                            child: CommentsList(
                              scrollController: _commentsScrollController,
                              comments: state.comments
                                  .where((element) => element.parentId == null)
                                  .toList(),
                              onReply: (comment) {
                                context
                                    .read<CommentsCubit>()
                                    .setReplyingComment(comment);
                              },
                              onRemove: (comment) {
                                defaultDialog(
                                  context: context,
                                  title: 'Вы действительно хотите удалить'
                                      ' этот комментарий?',
                                  titleStyle: const TextStyle(fontSize: 16),
                                  titlePadding: const EdgeInsets.only(
                                      top: 10, left: 15, right: 15),
                                  content: const SizedBox(),
                                  confirm: TextButton(
                                    onPressed: () async {
                                      context.pop();
                                      final loader = showLoader(context);
                                      final result = await context
                                          .read<CommentsCubit>()
                                          .removeComment(comment.id);
                                      if (!result) {
                                        FlushbarHelper.createInformation(
                                          message:
                                              'Проверьте ваше подключение!',
                                        ).show(context);
                                      }
                                      loader.remove();
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
                                    context
                                        .read<CommentsCubit>()
                                        .setReplyingComment(null);
                                  }
                                },
                                child: TextField(
                                  focusNode: _commentFocus,
                                  controller: _commentTextCont,
                                  decoration: InputDecoration(
                                    prefixIcon: state.replyingTo != null
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
                                                  color: context.theme.grey
                                                      .withOpacity(0.3),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                child: Text(
                                                  '@${state.replyingTo?.user?.name}',
                                                  style: TextStyle(
                                                    color: context
                                                        .theme.greyMedium,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                            ],
                                          )
                                        : null,
                                    hintText: 'your comment'.tr(),
                                  ),
                                ),
                              ),
                              BlocBuilder<UserBloc, UserState>(
                                builder: (context, userState) {
                                  return Positioned(
                                    right: 5,
                                    child: IconButton(
                                      onPressed: () async {
                                        if (userState.isLogin) {
                                          if (_commentTextCont
                                              .text.isNotEmpty) {
                                            final loader = showLoader(context);
                                            await context
                                                .read<CommentsCubit>()
                                                .createComment(
                                                    _commentTextCont.text);
                                            loader.remove();

                                            _commentTextCont.clear();
                                            _commentFocus.unfocus();
                                            if (state.replyingTo != null) {
                                              context
                                                  .read<CommentsCubit>()
                                                  .setReplyingComment(null);
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
                                          FlushbarHelper.createError(
                                            message:
                                                'login to leave comment'.tr(),
                                          ).show(context);
                                        }
                                      },
                                      icon: Icon(Icons.send),
                                    ),
                                  );
                                },
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
                          'Здесь пока нет комментариев \nБудьте первым'.tr(),
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
