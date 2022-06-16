import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../data/models/comment.dart';
import '../data/repositories/product_repo.dart';
part 'comments_state.dart';

class CommentsCubit extends Cubit<CommentsState> {
  CommentsCubit(int productId, {required IProductRepo productRepo})
      : _productRepo = productRepo,
        super(CommentsState(productId: productId));

  final IProductRepo _productRepo;

  void setReplyingComment(Comment? comment) {
    emit(state.copyWith(replyingTo: comment));
  }

  void fetchProductComments() async {
    emit(state.copyWith(isLoading: true));
    await _fetchComments();
    emit(state.copyWith(isLoading: false));
  }

  Future<void> _fetchComments() async {
    final response = await _productRepo.fetchProductComments(state.productId);
    if (response.status) {
      filterComments(response.result!);
    }
  }

  Future<bool> createComment(String text) async {
    final response = await _productRepo.createComment(
      text: text,
      productId: state.productId,
      parentId: state.replyingTo?.id,
    );

    await _fetchComments();

    return response.status;
  }

  Future<bool> removeComment(int id) async {
    final response = await _productRepo.removeComment(id);

    await _fetchComments();

    return response.status;
  }

  void filterComments(List<Comment> comments) {
    final topComments =
        comments.where((element) => element.parentId == null).toList();
    comments.removeWhere((element) => element.parentId == null);

    for (var i = 0; i < topComments.length; i++) {
      final children = List<Comment>.from(comments.where(
        (element) => element.parentId == topComments[i].id,
      ));
      topComments[i].children = filterCommentChildren(comments, children);
    }

    emit(state.copyWith(comments: topComments));
  }

  List<Comment> filterCommentChildren(
      List<Comment> comments, List<Comment> list) {
    for (final comment in list) {
      final children = List<Comment>.from(comments.where(
        (element) => element.parentId == comment.id,
      ));
      if (children.isNotEmpty) {
        list += filterCommentChildren(comments, children);
      }
    }

    return list;
  }
}
