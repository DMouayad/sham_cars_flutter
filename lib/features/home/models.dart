import 'package:sham_cars/features/questions/models.dart';
import 'package:sham_cars/features/vehicle/models.dart';

/// Review with embedded vehicle info (for home/lists)
class HomeReview {
  final int id;
  final String userName;
  final int rating;
  final String title;
  final String body;
  final String? cityCode;
  final DateTime createdAt;
  final CarTrimSummary? trimSummary; // Changed from VehicleSummary

  const HomeReview({
    required this.id,
    required this.userName,
    required this.rating,
    required this.title,
    required this.body,
    this.cityCode,
    required this.createdAt,
    this.trimSummary,
  });

  factory HomeReview.fromJson(Map<String, dynamic> json) => HomeReview(
    id: json['id'],
    userName: json['user_name'] ?? 'مستخدم',
    rating: json['rating'],
    title: json['title'] ?? '',
    body: json['body'] ?? json['comment'] ?? '',
    cityCode: json['city_code'],
    createdAt: DateTime.parse(json['created_at']),
    trimSummary: json['vehicle'] != null
        ? CarTrimSummary.fromJson(json['vehicle'])
        : null,
  );
}

class HomeData {
  final List<CarTrimSummary> featuredTrims;
  final List<Question> latestQuestions;
  final List<HomeReview> latestReviews;
  final List<BodyType> bodyTypes;
  final List<CarMake> makes;

  const HomeData({
    required this.featuredTrims,
    required this.latestQuestions,
    required this.latestReviews,
    required this.bodyTypes,
    required this.makes,
  });
}
