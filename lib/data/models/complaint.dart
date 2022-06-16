import 'dart:convert';

class Complaint {
  final int id;
  final String text;
  final int advertisementId;
  final int userId;
  final int complaintTypeId;

  Complaint({
    required this.id,
    required this.text,
    required this.advertisementId,
    required this.userId,
    required this.complaintTypeId,
  });

  Complaint copyWith({
    int? id,
    String? text,
    int? advertisementId,
    int? userId,
    int? complaintTypeId,
  }) {
    return Complaint(
      id: id ?? this.id,
      text: text ?? this.text,
      advertisementId: advertisementId ?? this.advertisementId,
      userId: userId ?? this.userId,
      complaintTypeId: complaintTypeId ?? this.complaintTypeId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      // 'id': id,
      'text': text,
      'advertisement_id': advertisementId,
      'user_id': userId,
      'complaint_type_id': complaintTypeId,
    };
  }

  factory Complaint.fromMap(Map<String, dynamic> map) {
    return Complaint(
      id: map['id']?.toInt() ?? 0,
      text: map['text'] ?? '',
      advertisementId: map['advertisement_id']?.toInt() ?? 0,
      userId: map['userId']?.toInt() ?? 0,
      complaintTypeId: map['complaint_type_id']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Complaint.fromJson(String source) =>
      Complaint.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Complaint(id: $id, text: $text, advertisementId: $advertisementId, userId: $userId, complaintTypeId: $complaintTypeId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Complaint &&
        other.id == id &&
        other.text == text &&
        other.advertisementId == advertisementId &&
        other.userId == userId &&
        other.complaintTypeId == complaintTypeId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        text.hashCode ^
        advertisementId.hashCode ^
        userId.hashCode ^
        complaintTypeId.hashCode;
  }
}
