import 'package:sham_cars/features/questions/models.dart';
import 'package:sham_cars/features/reviews/models.dart';
import 'package:sham_cars/features/vehicle/models.dart';

class HomeData {
  final List<CarTrimSummary> trendingTrims;
  final List<HotTopic> hotTopics;
  final List<Question> latestQuestions;
  final List<Review> latestReviews;

  const HomeData({
    this.trendingTrims = const [],
    this.hotTopics = const [],
    this.latestQuestions = const [],
    this.latestReviews = const [],
  });
}

class HotTopic {
  final int id;
  final String name;
  final String makeName;
  final int questionsCount;
  final int answersCount;
  final bool isHot;

  const HotTopic({
    required this.id,
    required this.name,
    required this.makeName,
    required this.questionsCount,
    required this.answersCount,
    required this.isHot,
  });

  factory HotTopic.fromJson(Map<String, dynamic> json) => HotTopic(
    id: json['id'],
    name: json['name'] ?? '',
    makeName: json['make_name'] ?? '',
    questionsCount: json['questions_count'] ?? 0,
    answersCount: json['answers_count'] ?? 0,
    isHot: json['is_hot'] ?? false,
  );
}
