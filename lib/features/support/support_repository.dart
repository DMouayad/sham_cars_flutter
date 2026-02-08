import 'package:sham_cars/api/cache.dart';
import 'package:sham_cars/api/rest_client.dart';

import 'models.dart';

class SupportRepository {
  SupportRepository(this._client, this._cache);
  final RestClient _client;
  final ResponseCache _cache;

  static const _cacheKey = 'settings';
  static const _ttl = Duration(hours: 24);

  Future<AppSupport> getSupportInfo({bool forceRefresh = false}) async {
    if (!forceRefresh) {
      final cached = await _cache.get(_cacheKey);
      if (cached is Map<String, dynamic>) {
        return AppSupport.fromJson(cached);
      }
    }

    final res = await _client.request(HttpMethod.get, '/settings');

    _cache.set(_cacheKey, res, ttl: _ttl);
    return AppSupport.fromJson(res);
  }
}
