import 'custom_attribute.dart';
import 'media.dart';

class Category {
  final int id;
  final String name;
  int? parentId;
  Category? parent;
  Media? media;
  final List<Category> children;
  final List<CustomAttribute> customAttributes;
  final String createdAt;
  final String updatedAt;

  Category({
    required this.id,
    required this.name,
    this.parentId,
    this.parent,
    this.media,
    this.children = const [],
    this.customAttributes = const [],
    this.createdAt = '',
    this.updatedAt = '',
  });

  factory Category.fromMap(map) => Category(
        id: map['id'],
        name: map['name'],
        parentId: map['parent_id'],
        parent: map['parent'] != null ? Category.fromMap(map['parent']) : null,
        media:
            (map['has_media'] ?? false) ? Media.fromMap(map['media'][0]) : null,
        children: fromList(map['children'] ?? const []),
        customAttributes:
            CustomAttribute.fromList(map['custom_attribute'] ?? const []),
        createdAt: map['created_at']?.toString() ?? '',
        updatedAt: map['updated_at']?.toString() ?? '',
      );

  static fromList(List list) => list.map((e) => Category.fromMap(e)).toList();
}
