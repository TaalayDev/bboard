import 'package:hive/hive.dart';

part 'media.g.dart';

@HiveType(typeId: 2)
class Media {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? fileName;
  @HiveField(2)
  String? mimeType;
  @HiveField(3)
  Map<String, bool>? generatedConversions;
  @HiveField(4)
  String? originalUrl;

  Media({
    this.id,
    this.fileName,
    this.mimeType,
    this.generatedConversions,
    this.originalUrl,
  });

  Media.fromMap(map) {
    id = map['id'];
    fileName = map['file_name'];
    mimeType = map['mime_type'];
    generatedConversions = Map<String, bool>.from(map['generated_conversions']);
    originalUrl = map['original_url'];
  }

  static fromList(List list) => list.map((e) => Media.fromMap(e)).toList();
}
