import '../../helpers/helper_functions.dart';

class District {
  final int id;
  final String name;
  final int cityId;

  District({
    required this.id,
    required this.name,
    required this.cityId,
  });

  factory District.fromMap(map) => District(
        id: map['id'],
        name: map['name'],
        cityId: parseInt(map['city_id']) ?? 0,
      );

  static fromList(List list) => list.map((e) => District.fromMap(e)).toList();
}
