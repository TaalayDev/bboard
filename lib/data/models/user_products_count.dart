import 'dart:convert';

class UserProductsCount {
  final int active;
  final int inactive;
  final int moderation;
  final int disabled;

  UserProductsCount({
    required this.active,
    required this.inactive,
    required this.moderation,
    required this.disabled,
  });

  UserProductsCount copyWith({
    int? active,
    int? inactive,
    int? moderation,
    int? disabled,
  }) {
    return UserProductsCount(
      active: active ?? this.active,
      inactive: inactive ?? this.inactive,
      moderation: moderation ?? this.moderation,
      disabled: disabled ?? this.disabled,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'active': active,
      'inactive': inactive,
      'moderation': moderation,
      'disabled': disabled,
    };
  }

  factory UserProductsCount.fromMap(Map<String, dynamic> map) {
    return UserProductsCount(
      active: map['active_count']?.toInt() ?? 0,
      inactive: map['inactive_count']?.toInt() ?? 0,
      moderation: map['moderation_count']?.toInt() ?? 0,
      disabled: map['disabled_count']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserProductsCount.fromJson(String source) =>
      UserProductsCount.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserProductsCount(active: $active, inactive: $inactive, moderation: $moderation, disabled: $disabled)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserProductsCount &&
        other.active == active &&
        other.inactive == inactive &&
        other.moderation == moderation &&
        other.disabled == disabled;
  }

  @override
  int get hashCode {
    return active.hashCode ^
        inactive.hashCode ^
        moderation.hashCode ^
        disabled.hashCode;
  }
}
