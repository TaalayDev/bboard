import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/models/comment.dart';
import '../../data/storage.dart';
import '../../res/theme.dart';
import 'app_network_image.dart';

class CommentsList extends StatelessWidget {
  final List<Comment> comments;
  final bool isChild;
  final Function(Comment comment)? onReply;
  final Function(Comment comment)? onRemove;
  final ScrollController? scrollController;

  const CommentsList({
    Key? key,
    this.comments = const [],
    this.isChild = false,
    this.onReply,
    this.onRemove,
    this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('dd.MM.yyyy');
    return ListView.builder(
      itemCount: comments.length,
      shrinkWrap: true,
      physics: isChild
          ? const NeverScrollableScrollPhysics()
          : const BouncingScrollPhysics(),
      controller: scrollController,
      itemBuilder: (context, index) {
        final comment = comments[index];
        final repliedTo = comment.parent?.user?.name;
        return Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50.0),
                  child: AppNetworkImage(
                    imageUrl: comment.user?.avatar ?? '',
                    height: isChild ? 30 : 35,
                    width: isChild ? 30 : 35,
                    // errorWidget: DefaultUserImage(size: 15),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: context.theme.greyWeak.withOpacity(0.5),
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  comment.user?.name ?? '',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Row(
                              children: [
                                if (repliedTo != null) ...[
                                  Text(
                                    '@$repliedTo',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.lightBlueAccent,
                                    ),
                                  ),
                                  const SizedBox(width: 3),
                                ],
                                Text(
                                  comment.text,
                                  style: TextStyle(
                                      color: context.theme.greyMedium),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          const SizedBox(width: 10),
                          Text(
                            formatter.format(DateTime.parse(comment.createdAt)),
                            style: TextStyle(
                              color: context.theme.grey,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 10),
                          TextButton(
                            onPressed: () {
                              onReply?.call(comment);
                            },
                            child: Text('reply'),
                          ),
                          if (LocaleStorage.currentUser?.id ==
                              comment.userId) ...[
                            TextButton(
                              onPressed: () {
                                onRemove?.call(comment);
                              },
                              child: Text(
                                'delete',
                                style: TextStyle(color: Colors.redAccent),
                              ),
                            ),
                          ],
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 36, top: 10),
              child: comment.children != null
                  ? CommentsList(
                      comments: comment.children!,
                      isChild: true,
                      onReply: onReply,
                      onRemove: onRemove,
                    )
                  : const SizedBox(),
            ),
          ],
        );
      },
    );
  }
}
