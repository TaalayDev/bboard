import '../../helpers/helper_functions.dart';
import 'custom_attribute.dart';

class CustomAttributeValues {
  final int id;
  final int attributeId;
  final String? value;
  final CustomAttribute? customAttribute;

  const CustomAttributeValues({
    required this.id,
    required this.attributeId,
    required this.value,
    this.customAttribute,
  });

  factory CustomAttributeValues.fromMap(map) => CustomAttributeValues(
        id: parseInt(map['id'])!,
        attributeId: map['attribute_id'],
        value: map['value'],
        customAttribute: map['custom_attribute'] != null
            ? CustomAttribute.fromMap(map['custom_attribute'])
            : null,
      );

  static fromList(List list) =>
      list.map((e) => CustomAttributeValues.fromMap(e)).toList();
}
