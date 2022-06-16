import 'dart:convert';

class ComplaintType {
  final int id;
  final String name;

  ComplaintType({
    required this.id,
    required this.name,
  });

  ComplaintType copyWith({
    int? id,
    String? name,
  }) {
    return ComplaintType(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory ComplaintType.fromMap(Map<String, dynamic> map) {
    return ComplaintType(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ComplaintType.fromJson(String source) =>
      ComplaintType.fromMap(json.decode(source));

  @override
  String toString() => 'ComplaintType(id: $id, name: $name)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ComplaintType && other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
