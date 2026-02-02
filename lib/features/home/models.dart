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
  final VehicleSummary? vehicle; // nullable for trim-specific reviews

  const HomeReview({
    required this.id,
    required this.userName,
    required this.rating,
    required this.title,
    required this.body,
    this.cityCode,
    required this.createdAt,
    this.vehicle,
  });

  factory HomeReview.fromJson(Map<String, dynamic> json) => HomeReview(
    id: json['id'],
    userName: json['user_name'] ?? 'مستخدم',
    rating: json['rating'],
    title: json['title'] ?? '',
    body: json['body'] ?? json['comment'] ?? '',
    cityCode: json['city_code'],
    createdAt: DateTime.parse(json['created_at']),
    vehicle: json['vehicle'] != null
        ? VehicleSummary.fromJson(json['vehicle'])
        : null,
  );
}

class HomeData {
  final List<CarModel> discoverModels;
  final List<Question> latestQuestions;
  final List<HomeReview> latestReviews;
  final List<BodyType> bodyTypes;
  final List<CarMake> makes;

  const HomeData({
    required this.discoverModels,
    required this.latestQuestions,
    required this.latestReviews,
    required this.bodyTypes,
    required this.makes,
  });

  // factory HomeData.fromJson(Map<String, dynamic> json) => HomeData(
  //   discoverModels:
  //       (json['discover_models'] as List?)
  //           ?.map((e) => CarModel.fromJson(e))
  //           .toList() ??
  //       [],
  //   latestQuestions:
  //       (json['latest_questions'] as List?)
  //           ?.map((e) => Question.fromJson(e))
  //           .toList() ??
  //       [],
  //   latestReviews:
  //       (json['latest_reviews'] as List?)
  //           ?.map((e) => HomeReview.fromJson(e))
  //           .toList() ??
  //       [],
  // );

  List<CarModel> get enrichedModels {
    final bodyTypeMap = {for (final bt in bodyTypes) bt.id: bt};
    final makeMap = {for (final m in makes) m.id: m};

    return discoverModels.map((model) {
      return model.enrich(
        bodyType: bodyTypeMap[model.bodyTypeId],
        make: makeMap[model.makeId],
      );
    }).toList();
  }
}
