import 'package:flutter/widgets.dart';

import '../../helpers/helper_functions.dart';
import '../constants.dart';
import 'city.dart';
import 'comment.dart';
import 'custom_attribute_values.dart';
import 'region.dart';
import 'category.dart';
import 'currency.dart';
import 'user.dart';
import 'media.dart';

class Product {
  static fromList(List list) => list.map((e) => Product.fromMap(e)).toList();

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.userId,
    required this.categoryId,
    this.user,
    this.category,
    this.categoryParentsTree,
    this.phones = const [],
    this.views = 0,
    this.canComment = 'all',
    this.isFavorite = false,
    this.isVip = false,
    this.isTop = false,
    this.isUrgent = false,
    this.hasCustomAttributeValues = false,
    this.customAttributeValues,
    this.media = const [],
    this.currencySymbol,
    this.currency,
    this.color,
    this.video,
    this.currencyId,
    this.regiondId,
    this.region,
    this.cityId,
    this.city,
    this.dictrict,
    this.updatedAt,
    this.createdAt,
    this.status = 'moderation',
    this.comments = const [],
  });

  final int id;
  final String title;
  final int price;
  final String description;
  String? video;
  final List<String> phones;
  late int views;
  final String canComment;
  final int userId;
  User? user;
  final int categoryId;
  Category? category;
  List<Category>? categoryParentsTree;
  int? currencyId;
  Currency? currency;
  int? regiondId;
  Region? region;
  int? cityId;
  City? city;
  String? dictrict;
  late bool isFavorite;
  Color? color;
  String? currencySymbol;
  final bool isVip;
  final bool isTop;
  final bool isUrgent;
  final bool hasCustomAttributeValues;
  List<CustomAttributeValues>? customAttributeValues;
  final List<Media> media;
  String? updatedAt;
  String? createdAt;
  final String status;
  final List<Comment> comments;

  String get getPrice => numberWithSpaces(price) + ' $currencySymbol';
  String get shareLink => Constants.baseUrl + '/products/$id';

  factory Product.fromMap(map) => Product(
        id: map['id'],
        title: map['title'],
        description: map['description'],
        price: map['price'],
        userId: map['user_id'],
        user: map['user'] != null ? User.fromMap(map['user']) : null,
        categoryId: map['category_id'],
        category:
            map['category'] != null ? Category.fromMap(map['category']) : null,
        phones: replaceAll(map['phones'].toString(), ['[', ']'], '').split(','),
        views: map['views'] ?? 0,
        canComment: map['can_comment'],
        isFavorite: map['is_favorite'] ?? false,
        isVip: map['is_vip'] ?? false,
        isTop: map['is_top'] ?? false,
        isUrgent: map['is_urgent'] ?? false,
        hasCustomAttributeValues: map['has_custom_attribute_values'] ?? false,
        customAttributeValues: map['custom_attribute_values'] != null
            ? CustomAttributeValues.fromList(map['custom_attribute_values'])
            : null,
        media: Media.fromList(map['media'] ?? const []),
        currencySymbol: map['currency_symbol'],
        currency: Currency.fromMap(map['currency']),
        color: map['features'] != null && map['features'] is Map
            ? colorFromHex(map['features']['color'] ?? '')
            : null,
        video: map['video'],
        currencyId: map['currency_id'],
        regiondId: map['region_id'],
        region: map['region'] != null ? Region.fromMap(map['region']) : null,
        cityId: map['city_id'],
        city: map['city'] != null ? City.fromMap(map['city']) : null,
        dictrict: map['district'],
        updatedAt: map['updated_at'],
        createdAt: map['created_at'],
        categoryParentsTree: map['category_tree'] != null
            ? Category.fromList(map['category_tree'])
            : null,
        status: map['status']?.toString() ?? 'moderation',
        comments:
            map['comments'] != null ? Comment.fromList(map['comments']) : [],
      );

  Product copyWith({
    String? title,
    String? description,
    int? price,
    int? userId,
    int? categoryId,
    bool? isFavorite,
    User? user,
    Category? category,
    List<Category>? categoryParentsTree,
    List<String>? phones,
    int? views,
    String? canComment,
    bool? isVip = false,
    bool? isTop = false,
    bool? isUrgent = false,
    bool? hasCustomAttributeValues,
    List<CustomAttributeValues>? customAttributeValues,
    List<Media>? media,
    String? currencySymbol,
    Currency? currency,
    Color? color,
    String? video,
    int? currencyId,
    int? regiondId,
    Region? region,
    int? cityId,
    City? city,
    String? dictrict,
    String? updatedAt,
    String? createdAt,
    String? status,
    List<Comment>? comments,
  }) =>
      Product(
        id: id,
        title: title ?? this.title,
        description: description ?? this.description,
        price: price ?? this.price,
        userId: userId ?? this.userId,
        categoryId: categoryId ?? this.categoryId,
        isFavorite: isFavorite ?? this.isFavorite,
        user: user ?? this.user,
        category: category ?? this.category,
        categoryParentsTree: categoryParentsTree ?? this.categoryParentsTree,
        phones: phones ?? this.phones,
        video: video ?? this.video,
        views: views ?? this.views,
        canComment: canComment ?? this.canComment,
        isTop: isTop ?? this.isTop,
        isUrgent: isUrgent ?? this.isUrgent,
        isVip: isVip ?? this.isVip,
        hasCustomAttributeValues:
            hasCustomAttributeValues ?? this.hasCustomAttributeValues,
        media: media ?? this.media,
        currencySymbol: currencySymbol ?? this.currencySymbol,
        currency: currency ?? this.currency,
        currencyId: currencyId ?? this.currencyId,
        color: color ?? this.color,
        regiondId: regiondId ?? this.regiondId,
        region: region ?? this.region,
        cityId: cityId ?? this.cityId,
        city: city ?? this.city,
        dictrict: dictrict ?? this.dictrict,
        updatedAt: updatedAt ?? this.updatedAt,
        createdAt: createdAt ?? this.createdAt,
        status: status ?? this.status,
        comments: comments ?? this.comments,
      );
}
