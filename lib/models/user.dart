import 'package:hive/hive.dart';

import 'media.dart';

part 'user.g.dart';

@HiveType(typeId: 1)
class User {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? name;
  @HiveField(3)
  String? phone;
  @HiveField(4)
  Media? media;
  @HiveField(5)
  double? balance;
  @HiveField(6)
  String? deviceToken;
  @HiveField(7)
  String? apiToken;

  String? get avatar => media?.originalUrl;

  User({
    this.id,
    this.name,
    this.phone,
    this.media,
    this.balance,
    this.deviceToken,
    this.apiToken,
  });

  User.fromMap(map) {
    id = map['id'];
    name = map['name'];
    phone = map['phone'];
    media = map['has_media'] ? Media.fromMap(['media'][0]) : null;
    deviceToken = map['device_token'];
    apiToken = map['api_token'];
  }
}
