import 'package:sham_cars/features/home/models.dart';
import 'package:sham_cars/features/questions/models.dart';

enum CommunityFilter { all, questions, reviews }

sealed class CommunityItem {
  DateTime get createdAt;

  static CommunityItem question(Question q) => QuestionItem(q);
  static CommunityItem review(HomeReview r) => ReviewItem(r);
}

class QuestionItem extends CommunityItem {
  final Question question;
  QuestionItem(this.question);

  @override
  DateTime get createdAt => question.createdAt;
}

class ReviewItem extends CommunityItem {
  final HomeReview review;
  ReviewItem(this.review);

  @override
  DateTime get createdAt => review.createdAt;
}
