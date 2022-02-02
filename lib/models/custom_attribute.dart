import 'package:bboard/helpers/helper.dart';

class CustomAttribute {
  final int id;
  final int categoryId;
  final String name;
  final String title;
  final CustomAttributeType type;
  final bool required;
  String? placeholder;
  String? values;

  CustomAttribute({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.title,
    this.placeholder,
    this.values,
    this.type = CustomAttributeType.STRING,
    this.required = false,
  });

  factory CustomAttribute.fromMap(map) => CustomAttribute(
        id: map['id'],
        categoryId: Helper.parseInt(map['category_id'])!,
        name: map['name'],
        title: map['title'],
        placeholder: map['placeholder'],
        values: map['values'],
        required: map['required'] ?? false,
        type: CustomAttributeType.values.firstWhere(
          (element) => element.name == map['type'],
          orElse: () => CustomAttributeType.STRING,
        ),
      );

  static fromList(List list) =>
      list.map((e) => CustomAttribute.fromMap(e)).toList();
}

enum CustomAttributeType {
  INT,
  DOUBLE,
  STRING,
  TEXT,
  BOOLEAN,
  ARRAY,
  SELECT,
  MULTISELECT
}
