import 'package:sham_cars/features/community/models.dart';

class Review implements CommunityItem {
  @override
  final DateTime createdAt;
  final int id;
  final String userName;
  final int rating;
  final String? title;
  final String body;
  final String? cityCode;
  final int? trimId;
  final String? trimName;
  final String? modelName;
  final String? makeName;
  final String? trimImageUrl;
  final String? trimRange;

  const Review({
    required this.id,
    required this.userName,
    required this.rating,
    this.title,
    required this.body,
    this.cityCode,
    required this.createdAt,
    this.trimId,
    this.trimName,
    this.modelName,
    this.makeName,
    this.trimImageUrl,
    this.trimRange,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    final vehicle = json['vehicle'];
    return Review(
      id: json['id'],
      userName: json['user_name'] ?? 'مستخدم',
      rating: json['rating'],
      title: json['title'],
      body: json['body'] ?? json['comment'] ?? '',
      cityCode: json['city_code'],
      createdAt: DateTime.parse(json['created_at']),
      trimId: vehicle?['id'],
      trimName: vehicle?['name'],
      modelName: vehicle?['model_name'],
      makeName: vehicle?['make_name'],
      trimImageUrl: vehicle?['image_url'],
      trimRange: vehicle?['range']?['display'],
    );
  }

  String? get trimFullName {
    if (makeName == null || modelName == null || trimName == null) {
      return null;
    }
    return '$makeName $modelName $trimName'.trim();
  }

  String? get trimDisplayName {
    if (modelName == null || trimName == null) {
      return null;
    }
    return '$modelName $trimName'.trim();
  }
}
