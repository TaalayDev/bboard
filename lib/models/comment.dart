import 'product.dart';
import 'user.dart';

class Comment {
  final int id;
  final String text;
  final int userId;
  final int productId;
  int? parentId;
  User? user;
  Product? product;
  List<Comment>? children;

  Comment({
    required this.id,
    required this.text,
    required this.userId,
    required this.productId,
    this.parentId,
    this.user,
    this.product,
    this.children,
  });

  factory Comment.fromMap(map) => Comment(
        id: map['id'],
        text: map['text'],
        userId: map['user_id'],
        productId: map['advertisement_id'],
        parentId: map['parent_id'],
        user: map['user'] != null ? User.fromMap(map['user']) : null,
        product: map['advertisement'] != null
            ? Product.fromMap(map['advertisement'])
            : null,
        children: map['children'] != null ? fromList(map['children']) : null,
      );

  static fromList(List list) => list.map((e) => Comment.fromMap(e)).toList();
}
