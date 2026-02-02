import 'package:sham_cars/api/cache.dart';
import 'package:sham_cars/api/rest_client.dart';
import 'package:sham_cars/features/home/models.dart';
import 'package:sham_cars/features/questions/models.dart';
import 'package:sham_cars/features/reviews/models.dart';

class CommunityRepository {
  final RestClient _client;
  final ResponseCache _cache;

  CommunityRepository(this._client, this._cache);

  // ============ REVIEWS ============

  Future<List<Review>> getReviews(int carTrimId) async {
    final cacheKey = 'reviews_$carTrimId';

    if (_cache.get<List<Review>>(cacheKey) case final cached?) {
      return cached;
    }

    final data = await _client.requestList(
      HttpMethod.get,
      '/community/reviews',
      query: {'car_trim_id': '$carTrimId'},
    );

    final reviews = data.map(Review.fromJson).toList();
    _cache.set(cacheKey, reviews);
    return reviews;
  }

  Future<List<HomeReview>> getLatestReviews({int limit = 10}) async {
    final data = await _client.requestList(
      HttpMethod.get,
      '/community/reviews',
      query: {'limit': '$limit'},
    );
    return data.map(HomeReview.fromJson).toList();
  }

  Future<void> postReview({
    required int carTrimId,
    required int rating,
    required String comment,
    String? title,
    String? cityCode,
    required String accessToken,
  }) async {
    await _client.request(
      HttpMethod.post,
      '/community/reviews',
      body: {
        'car_trim_id': carTrimId,
        'rating': rating,
        'comment': comment,
        if (title != null) 'title': title,
        if (cityCode != null) 'city_code': cityCode,
      },
      accessToken: accessToken,
    );

    // Invalidate related caches
    _cache.invalidate('reviews_$carTrimId');
    _cache.invalidate('home_data');
  }

  // ============ QUESTIONS ============

  Future<List<Question>> getQuestions({int? carModelId}) async {
    final cacheKey = 'questions_${carModelId ?? 'all'}';

    if (_cache.get<List<Question>>(cacheKey) case final cached?) {
      return cached;
    }

    final query = <String, String>{
      if (carModelId != null) 'car_model_id': '$carModelId',
    };

    final data = await _client.requestList(
      HttpMethod.get,
      '/community/questions',
      query: query,
    );

    final questions = data.map(Question.fromJson).toList();
    _cache.set(cacheKey, questions);
    return questions;
  }

  Future<Question> getQuestion(int id) async {
    final data = await _client.request(
      HttpMethod.get,
      '/community/questions/$id',
    );
    return Question.fromJson(data);
  }

  Future<void> postQuestion({
    required int carModelId,
    required String title,
    required String body,
    required String accessToken,
  }) async {
    await _client.request(
      HttpMethod.post,
      '/community/questions',
      body: {'car_model_id': carModelId, 'title': title, 'body': body},
      accessToken: accessToken,
    );

    // Invalidate caches
    _cache.invalidatePrefix('questions_');
    _cache.invalidate('home_data');
  }

  Future<void> postAnswer({
    required int questionId,
    required String body,
    required String accessToken,
  }) async {
    await _client.request(
      HttpMethod.post,
      '/community/questions/$questionId/answers',
      body: {'body': body},
      accessToken: accessToken,
    );
  }
}
