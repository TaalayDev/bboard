import 'dart:convert';

class NotificationModel {
  final int id;
  final dynamic data;
  final String type;
  final String readAt;
  final String createdAt;
  final String updatedAt;

  NotificationModel({
    required this.id,
    required this.data,
    required this.type,
    required this.readAt,
    required this.createdAt,
    required this.updatedAt,
  });

  NotificationModel copyWith({
    int? id,
    dynamic? data,
    String? type,
    String? readAt,
    String? createdAt,
    String? updatedAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      data: data ?? this.data,
      type: type ?? this.type,
      readAt: readAt ?? this.readAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'data': data,
      'type': type,
      'readAt': readAt,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id']?.toInt() ?? 0,
      data: map['data'],
      type: map['type'] ?? '',
      readAt: map['read_at'] ?? '',
      createdAt: map['created_at'] ?? '',
      updatedAt: map['updated_at'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationModel.fromJson(String source) =>
      NotificationModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'NotificationModel(id: $id, data: $data, type: $type, readAt: $readAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NotificationModel &&
        other.id == id &&
        other.data == data &&
        other.type == type &&
        other.readAt == readAt &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        data.hashCode ^
        type.hashCode ^
        readAt.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
