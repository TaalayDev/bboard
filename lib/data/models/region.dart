import 'city.dart';

class Region {
  final int id;
  final String name;
  List<City>? cities;

  Region({
    required this.id,
    required this.name,
    this.cities,
  });

  factory Region.fromMap(map) => Region(
        id: map['id'],
        name: map['name'],
        cities: map['cities'] != null ? City.fromList(map['cities']) : null,
      );

  static fromList(List list) => list.map((e) => Region.fromMap(e)).toList();
}
