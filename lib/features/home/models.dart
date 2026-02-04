import 'package:sham_cars/features/questions/models.dart';
import 'package:sham_cars/features/reviews/models.dart';
import 'package:sham_cars/features/vehicle/models.dart';

class HomeData {
  final List<CarTrimSummary> featuredTrims;
  final List<Question> latestQuestions;
  final List<Review> latestReviews;
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
