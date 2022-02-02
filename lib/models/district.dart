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
        cityId: map['city_id'],
      );

  static fromList(List list) => list.map((e) => District.fromMap(e)).toList();
}
