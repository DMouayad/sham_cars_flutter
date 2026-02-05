import 'package:sham_cars/api/cache.dart';
import 'package:sham_cars/api/rest_client.dart';
import 'package:sham_cars/features/questions/models.dart';
import 'package:sham_cars/features/reviews/models.dart';

class CommunityRepository {
  final RestClient _client;
  final ResponseCache _cache;

  CommunityRepository(this._client, this._cache);

  // ============ REVIEWS ============

  Future<List<Review>> getReviews({
    int? trimId,
    int take = 15,
    int skip = 0,
  }) async {
    final cacheKey = 'reviews_${trimId ?? "null"}_${take}_$skip';

    if (_cache.get<List<Review>>(cacheKey) case final cached?) return cached;

    final data = await _client.requestList(
      HttpMethod.get,
      '/community/reviews',
      query: {
        if (trimId != null) 'car_trim_id': '$trimId',
        'take': '$take',
        'skip': '$skip',
      },
    );

    final reviews = data.map(Review.fromJson).toList();
    _cache.set(cacheKey, reviews);
    return reviews;
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
        // if (title != null) 'title': title,
        // if (cityCode != null) 'city_code': cityCode,
      },
      accessToken: accessToken,
    );

    // Invalidate related caches
    _cache.invalidate('reviews_$carTrimId');
    _cache.invalidate('home_data');
  }

  // ============ QUESTIONS ============

  Future<List<Question>> getQuestions({
    int? trimId,
    int? modelId,
    int take = 15,
    int skip = 0,
  }) async {
    final cacheKey =
        'questions_${trimId ?? "null"}_${modelId ?? "null"}_${take}_$skip';

    if (_cache.get<List<Question>>(cacheKey) case final cached?) return cached;

    final query = <String, String>{
      if (trimId != null) 'car_trim_id': '$trimId',
      if (modelId != null) 'car_model_id': '$modelId',
      'take': '$take',
      'skip': '$skip',
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
    int? carModelId,
    required int carTrimId,
    required String title,
    required String body,
    required String accessToken,
  }) async {
    await _client.request(
      HttpMethod.post,
      '/community/questions',
      body: {
        if (carModelId != null) 'car_model_id': carModelId,
        'car_trim_id': carTrimId,
        'title': title,
        'body': body,
      },
      accessToken: accessToken,
    );

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

  Future<List<Question>> getLatestQuestions({int take = 3}) {
    return getQuestions(take: take, skip: 0);
  }

  Future<List<Review>> getLatestReviews({int take = 3}) {
    return getReviews(take: take, skip: 0);
  }
}
