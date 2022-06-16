import 'package:hive/hive.dart';

import 'category.dart';
import 'region.dart';

part 'filter.g.dart';

@HiveType(typeId: 3)
class Filter {
  @HiveField(0)
  final int? categoryId;
  @HiveField(1)
  final int? regionId;
  @HiveField(2)
  final String? sortBy;
  @HiveField(3)
  final bool hasPhoto;
  @HiveField(4)
  final bool hasVideo;
  @HiveField(5)
  final String? text;

  final Category? category;
  final Region? region;

  Filter({
    this.categoryId,
    this.regionId,
    this.sortBy,
    this.hasPhoto = false,
    this.hasVideo = false,
    this.text,
    this.category,
    this.region,
  });

  Filter copyWith({
    int? categoryId,
    int? regionId,
    String? sortBy,
    bool? hasPhoto,
    bool? hasVideo,
    String? text,
    Category? category,
    Region? region,
  }) =>
      Filter(
        categoryId: categoryId ?? this.categoryId,
        regionId: regionId ?? this.regionId,
        sortBy: sortBy ?? this.sortBy,
        hasPhoto: hasPhoto ?? this.hasPhoto,
        hasVideo: hasVideo ?? this.hasVideo,
        text: text ?? this.text,
        category: category ?? this.category,
        region: region ?? region,
      );

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};

    String search = '';
    String searchFields = '';
    if (categoryId != null) {
      search += 'category_id: $categoryId;';
      searchFields += 'category_id:=;';
    }
    if (regionId != null) {
      search += 'region_id:$regionId;';
      searchFields += 'region_id:=;';
    }
    if (text != null && text!.isNotEmpty) {
      search += '$text;';
      // searchFields += 'name:like;description:like;';
    }

    map['search'] = search.isNotEmpty ? search : null;
    map['searchFields'] = searchFields.isNotEmpty ? searchFields : null;

    if (sortBy != null && sortBy!.isNotEmpty) {
      switch (sortBy) {
        case 'newest':
          map['orderBy'] = 'created_at';
          map['sortedBy'] = 'desc';
          break;
        case 'low_price':
          map['orderBy'] = 'price';
          break;
        case 'high_price':
          map['orderBy'] = 'price';
          map['sortedBy'] = 'desc';
          break;
        case 'views':
          map['orderBy'] = 'views';
          map['sortedBy'] = 'desc';
          break;
        default:
      }
    }

    map['has_video'] = hasVideo;
    map['has_photo'] = hasPhoto;

    return map;
  }
}
