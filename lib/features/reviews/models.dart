import 'package:sham_cars/features/community/models.dart';

DateTime parseApiDate(String s) {
  final normalized = s.contains('T') ? s : s.replaceFirst(' ', 'T');
  return DateTime.parse(normalized);
}

class Review implements CommunityItem {
  @override
  final DateTime createdAt;

  final int id;
  final String userName;
  final int rating;

  final String comment;
  String get body => comment;

  final int? trimId;
  final String? trimName;
  final String? modelName;

  // Optional extras (if backend later adds more)
  final String? title;
  final String? cityCode;
  final String? makeName;
  final String? trimImageUrl;
  final String? trimRange;

  const Review({
    required this.id,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.createdAt,
    this.trimId,
    this.trimName,
    this.modelName,
    this.title,
    this.cityCode,
    this.makeName,
    this.trimImageUrl,
    this.trimRange,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    // Support both formats:
    // - New: car_trim_id, car_trim_name, car_model_name, comment
    // - Old: nested vehicle + body/comment
    final vehicle = json['vehicle'];

    final trimId = json['car_trim_id'] ?? vehicle?['id'];

    final trimName = json['car_trim_name'] ?? vehicle?['name'];

    final modelName = json['car_model_name'] ?? vehicle?['model_name'];

    return Review(
      id: json['id'],
      userName: json['user_name'] ?? 'مستخدم',
      rating: (json['rating'] ?? 0) as int,
      title: json['title'],
      cityCode: json['city_code'],

      // Prefer new "comment", fallback to other keys
      comment: (json['comment'] ?? json['body'] ?? '') as String,

      createdAt: parseApiDate(json['created_at']),

      trimId: trimId,
      trimName: trimName,
      modelName: modelName,

      // optional extras if vehicle object exists
      makeName: vehicle?['make_name'],
      trimImageUrl: vehicle?['image_url'],
      trimRange: vehicle?['range']?['display'],
    );
  }

  String? get trimDisplayName {
    final m = (modelName ?? '').trim();
    final t = (trimName ?? '').trim();
    if (m.isEmpty && t.isEmpty) return null;
    if (m.isEmpty) return t;
    if (t.isEmpty) return m;
    return '$m $t';
  }
}
