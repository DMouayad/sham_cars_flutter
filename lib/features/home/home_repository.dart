import 'package:sham_cars/api/cache.dart';
import 'package:sham_cars/api/rest_client.dart';
import 'package:sham_cars/features/questions/models.dart';
import 'package:sham_cars/features/vehicle/models.dart';

import 'models.dart';

class HomeRepository {
  final RestClient _client;
  final ResponseCache _cache;

  static const _cacheKeyHome = 'home_data';

  HomeRepository(this._client, this._cache);

  Future<HomeData> getHomeData({bool forceRefresh = false}) async {
    // Check cache first
    if (!forceRefresh) {
      if (_cache.get<HomeData>(_cacheKeyHome) case final cached?) {
        return cached;
      }
    }

    return RestClient.runCached(() async {
      final results = await Future.wait([
        _client.requestList(HttpMethod.get, '/car-data/models'),
        _client.requestList(HttpMethod.get, '/car-data/body-types'),
        _client.requestList(HttpMethod.get, '/car-data/makes'),
        _client.requestList(HttpMethod.get, '/community/questions'),
        _fetchReviews(),
      ]);

      final data = HomeData(
        discoverModels: (results[0] as List)
            .map((e) => CarModel.fromJson(e))
            .toList(),
        bodyTypes: (results[1] as List)
            .map((e) => BodyType.fromJson(e))
            .toList(),
        makes: (results[2] as List).map((e) => CarMake.fromJson(e)).toList(),
        latestQuestions: (results[3] as List)
            .map((e) => Question.fromJson(e))
            .toList(),
        latestReviews: (results[4] as List)
            .map((e) => HomeReview.fromJson(e))
            .toList(),
      );

      // Cache for 5 minutes
      _cache.set(_cacheKeyHome, data, ttl: const Duration(minutes: 5));

      return data;
    });
  }

  Future<List<Map<String, dynamic>>> _fetchReviews() async {
    try {
      // Try fetching latest reviews (if backend supports it)
      return await _client.requestList(
        HttpMethod.get,
        '/community/reviews',
        query: {'limit': '10'},
      );
    } catch (_) {
      // If not supported, return empty list
      return [];
    }
  }

  void invalidateCache() {
    _cache.invalidate(_cacheKeyHome);
  }
}
