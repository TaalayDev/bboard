import 'dart:convert';

import 'comment.dart';
import 'product.dart';

enum NotificationType { statusChanged, comment, commentReply, none }

class NotificationModel {
  final int id;
  final dynamic data;
  final String title;
  final String body;
  final String createdAt;

  NotificationType get type {
    if (data != null) {
      switch (data['type']) {
        case 'status_changed':
          return NotificationType.statusChanged;
        case 'comment':
          return NotificationType.comment;
        case 'comment_reply':
          return NotificationType.commentReply;
        default:
      }
    }

    return NotificationType.none;
  }

  String? get image {
    if (type == NotificationType.statusChanged ||
        type == NotificationType.comment) {
      final product = Product.fromMap(data['product']);
      if (product.media.isNotEmpty) {
        return product.media.first.originalUrl;
      } else {
        return null;
      }
    } else if (type == NotificationType.commentReply) {
      final comment = Comment.fromMap(data['comment']);
      if (comment.product != null && comment.product!.media.isNotEmpty) {
        return comment.product!.media.first.originalUrl ?? '';
      }
    }

    return null;
  }

  NotificationModel({
    required this.id,
    required this.data,
    required this.title,
    required this.body,
    required this.createdAt,
  });

  NotificationModel copyWith({
    int? id,
    dynamic data,
    String? title,
    String? body,
    String? createdAt,
    String? updatedAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      data: data ?? this.data,
      title: title ?? this.title,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'data': data,
      'title': title,
      'body': body,
      'createdAt': createdAt,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id']?.toInt() ?? 0,
      data: map['data'] != null ? jsonDecode(map['data']) : null,
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      createdAt: map['created_at'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationModel.fromJson(String source) =>
      NotificationModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'NotificationModel(id: $id, data: $data, title: $title, body: $body, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NotificationModel &&
        other.id == id &&
        other.data == data &&
        other.title == title &&
        other.body == body &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        data.hashCode ^
        title.hashCode ^
        body.hashCode ^
        createdAt.hashCode;
  }
}
