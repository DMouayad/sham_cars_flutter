import 'package:sham_cars/api/cache.dart';
import 'package:sham_cars/api/rest_client.dart';
import 'package:sham_cars/features/home/models.dart';
import 'package:sham_cars/features/vehicle/models.dart';

class CarDataRepository {
  CarDataRepository(this._client, {ResponseCache? cache}) : _cache = cache;

  final RestClient _client;
  final ResponseCache? _cache;

  // TTLs
  static const _ttlReference = Duration(days: 7);
  static const _ttlModels = Duration(hours: 24);
  static const _ttlTrending = Duration(minutes: 15);
  static const _ttlHotTopics = Duration(minutes: 15);
  static const _ttlTrimDetail = Duration(hours: 24);
  static const _ttlRecommendations = Duration(hours: 6);

  String _key(
    String method,
    String path, [
    Map<String, String> query = const {},
  ]) {
    final uri = Uri(path: path, queryParameters: query.isEmpty ? null : query);
    return '$method:${uri.toString()}';
  }

  // ----------------------------
  // Reference data (cacheable)
  // ----------------------------

  Future<List<BodyType>> getBodyTypes({bool forceRefresh = false}) async {
    const path = '/car-data/body-types';
    final key = _key('GET', path);

    if (!forceRefresh) {
      final cached = _cache?.get<List<BodyType>>(key);
      if (cached != null) return cached;
    }

    final data = await _client.requestList(HttpMethod.get, path);
    final parsed = data.map(BodyType.fromJson).toList();

    _cache?.set(key, parsed, ttl: _ttlReference);
    return parsed;
  }

  Future<List<CarMake>> getMakes({bool forceRefresh = false}) async {
    const path = '/car-data/makes';
    final key = _key('GET', path);

    if (!forceRefresh) {
      final cached = _cache?.get<List<CarMake>>(key);
      if (cached != null) return cached;
    }

    final data = await _client.requestList(HttpMethod.get, path);
    final parsed = data.map(CarMake.fromJson).toList();

    _cache?.set(key, parsed, ttl: _ttlReference);
    return parsed;
  }

  Future<List<CarModel>> getModels({
    int? makeId,
    int? bodyTypeId,
    bool forceRefresh = false,
  }) async {
    const path = '/car-data/models';
    final query = <String, String>{
      if (makeId != null) 'make_id': '$makeId',
      if (bodyTypeId != null) 'body_type_id': '$bodyTypeId',
    };
    final key = _key('GET', path, query);

    if (!forceRefresh) {
      final cached = _cache?.get<List<CarModel>>(key);
      if (cached != null) return cached;
    }

    final data = await _client.requestList(HttpMethod.get, path, query: query);
    final parsed = data.map(CarModel.fromJson).toList();

    _cache?.set(key, parsed, ttl: _ttlModels);
    return parsed;
  }

  // ----------------------------
  // Trims listing (usually NOT cached)
  // ----------------------------

  /// Get list of trims with optional filters.
  /// NOTE: Not cached by default due to large query combinations (search/filters/pagination).
  Future<List<CarTrimSummary>> getTrims([TrimFilters? filters]) async {
    final data = await _client.requestList(
      HttpMethod.get,
      '/car-data/trims',
      query: filters?.toQueryParams() ?? {},
    );
    return data.map(CarTrimSummary.fromJson).toList();
  }

  Future<List<CarTrimSummary>> getTrimsPage({
    String? search,
    int take = 15,
    int skip = 0,
  }) {
    return getTrims(TrimFilters(search: search, take: take, skip: skip));
  }

  /// Search trims
  Future<List<CarTrimSummary>> searchTrims(
    String query, {
    int limit = 20,
  }) async {
    return getTrims(TrimFilters(search: query, take: limit));
  }

  // ----------------------------
  // Home rankings (cacheable short TTL)
  // ----------------------------

  Future<List<CarTrimSummary>> getTrendingCars({
    int take = 10,
    int skip = 0,
    bool forceRefresh = false,
  }) async {
    const path = '/car-data/trending-cars';
    final query = {'take': '$take', 'skip': '$skip'};
    final key = _key('GET', path, query);

    if (!forceRefresh) {
      final cached = _cache?.get<List<CarTrimSummary>>(key);
      if (cached != null) return cached;
    }

    final data = await _client.requestList(HttpMethod.get, path, query: query);
    final parsed = data.map(CarTrimSummary.fromJson).toList();

    _cache?.set(key, parsed, ttl: _ttlTrending);
    return parsed;
  }

  Future<List<HotTopic>> getHotTopics({
    int take = 10,
    int skip = 0,
    bool forceRefresh = false,
  }) async {
    const path = '/car-data/hot-topics';
    final query = {'take': '$take', 'skip': '$skip'};
    final key = _key('GET', path, query);

    if (!forceRefresh) {
      final cached = _cache?.get<List<HotTopic>>(key);
      if (cached != null) return cached;
    }

    final data = await _client.requestList(HttpMethod.get, path, query: query);
    final parsed = data.map(HotTopic.fromJson).toList();

    _cache?.set(key, parsed, ttl: _ttlHotTopics);
    return parsed;
  }

  // ----------------------------
  // Trim detail + recommendations (cacheable)
  // ----------------------------

  Future<CarTrim> getTrim(int id, {bool forceRefresh = false}) async {
    final path = '/car-data/trims/$id';
    final key = _key('GET', path);

    if (!forceRefresh) {
      final cached = _cache?.get<CarTrim>(key);
      if (cached != null) return cached;
    }

    final data = await _client.request(HttpMethod.get, path);
    final parsed = CarTrim.fromJson(data);

    _cache?.set(key, parsed, ttl: _ttlTrimDetail);
    return parsed;
  }

  Future<List<CarTrimSummary>> getSimilarTrims(
    int trimId, {
    int take = 5,
    int skip = 0,
    bool forceRefresh = false,
  }) async {
    final path = '/car-data/trims/$trimId/similar';
    final query = {'take': '$take', 'skip': '$skip'};
    final key = _key('GET', path, query);

    if (!forceRefresh) {
      final cached = _cache?.get<List<CarTrimSummary>>(key);
      if (cached != null) return cached;
    }

    final data = await _client.requestList(HttpMethod.get, path, query: query);
    final parsed = data.map(CarTrimSummary.fromJson).toList();

    _cache?.set(key, parsed, ttl: _ttlRecommendations);
    return parsed;
  }

  Future<List<CarTrimSummary>> getAlsoLikedTrims(
    int trimId, {
    int take = 5,
    int skip = 0,
    bool forceRefresh = false,
  }) async {
    final path = '/car-data/trims/$trimId/also-liked';
    final query = {'take': '$take', 'skip': '$skip'};
    final key = _key('GET', path, query);

    if (!forceRefresh) {
      final cached = _cache?.get<List<CarTrimSummary>>(key);
      if (cached != null) return cached;
    }

    final data = await _client.requestList(HttpMethod.get, path, query: query);
    final parsed = data.map(CarTrimSummary.fromJson).toList();

    _cache?.set(key, parsed, ttl: _ttlRecommendations);
    return parsed;
  }
}
