import 'package:bboard/helpers/helper.dart';

import 'district.dart';

class City {
  final int id;
  final String name;
  final int regionId;
  List<District>? districts;

  City({
    required this.id,
    required this.name,
    required this.regionId,
    this.districts,
  });

  factory City.fromMap(map) => City(
        id: map['id'],
        name: map['name'],
        regionId: Helper.parseInt(map['region_id'])!,
        districts: map['districts'] != null
            ? District.fromList(map['districts'])
            : null,
      );

  static fromList(List list) => list.map((e) => City.fromMap(e)).toList();
}
