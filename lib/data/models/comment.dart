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
  Comment? parent;
  List<Comment>? children;
  final String createdAt;
  final String updatedAt;

  Comment({
    required this.id,
    required this.text,
    required this.userId,
    required this.productId,
    this.parentId,
    this.user,
    this.product,
    this.parent,
    this.children,
    this.createdAt = '',
    this.updatedAt = '',
  });

  factory Comment.fromMap(map) => Comment(
        id: map['id'],
        text: map['text']?.toString() ?? '',
        userId: map['user_id'],
        productId: map['advertisement_id'],
        parentId: map['parent_id'],
        user: map['user'] != null ? User.fromMap(map['user']) : null,
        product: map['advertisement'] != null
            ? Product.fromMap(map['advertisement'])
            : null,
        parent: map['parent'] != null ? Comment.fromMap(map['parent']) : null,
        children: map['children'] != null ? fromList(map['children']) : null,
        createdAt: map['created_at']?.toString() ?? '',
        updatedAt: map['updated_at']?.toString() ?? '',
      );

  static fromList(List list) => list.map((e) => Comment.fromMap(e)).toList();

  Map<String, dynamic> toMap() => {
        'id': id,
        'text': text,
        'parent_id': parentId,
        'children': children?.map((e) => e.toMap()).toList(),
      };
}
