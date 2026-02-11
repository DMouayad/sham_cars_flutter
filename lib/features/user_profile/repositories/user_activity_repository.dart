import 'package:get_it/get_it.dart';
import 'package:sham_cars/api/rest_client.dart';
import 'package:sham_cars/features/auth/auth_notifier.dart';
import 'package:sham_cars/features/questions/models.dart';
import 'package:sham_cars/features/reviews/models.dart';

class UserActivityRepository {
  final RestClient _client;
  const UserActivityRepository(this._client);

  Future<List<Review>> getMyReviews({
    required String accessToken,
    int limit = 10,
    int skip = 0,
  }) async {
    final data = await _client.requestList(
      HttpMethod.get,
      '/user/reviews',
      query: {'limit': '$limit', 'skip': '$skip'},
      accessToken: accessToken,
    );
    return data.map(Review.fromJson).toList();
  }

  Future<List<Question>> getMyQuestions({
    required String accessToken,
    int limit = 10,
    int skip = 0,
  }) async {
    final data = await _client.requestList(
      HttpMethod.get,
      '/user/questions',
      query: {'limit': '$limit', 'skip': '$skip'},
      accessToken: accessToken,
    );
    final currentUser = GetIt.I.get<AuthNotifier>().currentUser;
    return data
        .map(Question.fromJson)
        .map((q) => q.copyWith(userName: currentUser?.fullName))
        .toList();
  }

  Future<List<Question>> getMyAnsweredQuestions({
    required String accessToken,
    int limit = 10,
    int skip = 0,
  }) async {
    final data = await _client.requestList(
      HttpMethod.get,
      '/user/answered-questions',
      query: {'limit': '$limit', 'skip': '$skip'},
      accessToken: accessToken,
    );
    return data.map(Question.fromJson).toList();
  }
}
