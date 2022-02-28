import 'package:bboard/tools/locale_storage.dart';
import 'package:get/get.dart';

import '../../../models/comment.dart';
import '../../../models/product.dart';
import '../../../repositories/product_repo.dart';

class CommentsPageController extends GetxController {
  late Product product;
  List<Comment> comments = [];

  bool fetchingComments = false;

  Comment? _replyingTo;
  Comment? get replyingTo => _replyingTo;
  set replyingTo(Comment? newVal) {
    _replyingTo = newVal;
    update();
  }

  final _productRepo = Get.find<ProductRepo>();

  @override
  void onInit() {
    final productId = Get.arguments;
    fetchProductDetails(productId);
    fetchProductComments(productId);
    super.onInit();
  }

  void fetchProductDetails(int productId) async {
    final appResponse = await _productRepo.fetchProduct(productId);
    if (appResponse.status) {
      product = appResponse.data!;
    }
  }

  Future<void> fetchProductComments(int productId) async {
    fetchingComments = true;
    update();

    await _fetchComments(productId);

    fetchingComments = false;
    update();
  }

  Future<void> _fetchComments(int id) async {
    final appResponse = await _productRepo.fetchProductComments(id);
    if (appResponse.status) {
      comments = appResponse.data!;
      filterComments();
    }
  }

  Future<void> createComment(String text) async {
    final appResponse = await _productRepo.createComment(
      text: text,
      productId: product.id,
      parentId: _replyingTo?.id,
    );
    if (appResponse.status) {
      final comment = appResponse.data!;
      comment.user = LocaleStorage.currentUser;
      if (comment.parentId != null) {
        for (var i = 0; i < comments.length; i++) {
          int? index;
          if (comments[i].id == comment.parentId) {
            index = i;
          } else {
            index = comments[i]
                .children
                ?.indexWhere((element) => element.id == comment.parentId);
          }
          if (index != null && index != -1) {
            comments[i].children?.add(comment);
            break;
          }
        }
      } else {
        comments.insert(0, comment);
      }
      update();
    }
  }

  Future<bool> removeComment(int id) async {
    final appResponse = await _productRepo.removeComment(id);
    if (appResponse.status) {
      await _fetchComments(product.id);
      return true;
    }

    return false;
  }

  void filterComments() {
    final topComments =
        comments.where((element) => element.parentId == null).toList();
    comments.removeWhere((element) => element.parentId == null);

    for (var i = 0; i < topComments.length; i++) {
      final children = List<Comment>.from(comments.where(
        (element) => element.parentId == topComments[i].id,
      ));
      topComments[i].children = filterCommentChildren(children);
    }
    comments = topComments;
    update();
  }

  List<Comment> filterCommentChildren(List<Comment> list) {
    for (final comment in list) {
      final children = List<Comment>.from(comments.where(
        (element) => element.parentId == comment.id,
      ));
      if (children.isNotEmpty) {
        list += filterCommentChildren(children);
      }
    }

    return list;
  }
}
