import 'package:sham_cars/api/rest_client.dart';
import 'package:sham_cars/features/home/models.dart';
import 'package:sham_cars/features/vehicle/models.dart';

class CarDataRepository {
  final RestClient _client;

  const CarDataRepository(this._client);

  Future<List<BodyType>> getBodyTypes() async {
    final data = await _client.requestList(
      HttpMethod.get,
      '/car-data/body-types',
    );
    return data.map(BodyType.fromJson).toList();
  }

  Future<List<CarMake>> getMakes() async {
    final data = await _client.requestList(HttpMethod.get, '/car-data/makes');
    return data.map(CarMake.fromJson).toList();
  }

  Future<List<CarModel>> getModels({int? makeId, int? bodyTypeId}) async {
    final query = <String, String>{
      if (makeId != null) 'make_id': '$makeId',
      if (bodyTypeId != null) 'body_type_id': '$bodyTypeId',
    };
    final data = await _client.requestList(
      HttpMethod.get,
      '/car-data/models',
      query: query,
    );
    return data.map(CarModel.fromJson).toList();
  }

  /// Get list of trims with optional filters
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

  Future<List<CarTrimSummary>> getTrendingCars({
    int take = 10,
    int skip = 0,
  }) async {
    final data = await _client.requestList(
      HttpMethod.get,
      '/car-data/trending-cars',
      query: {'take': '$take', 'skip': '$skip'},
    );
    return data.map(CarTrimSummary.fromJson).toList();
  }

  Future<List<HotTopic>> getHotTopics({int take = 10, int skip = 0}) async {
    final data = await _client.requestList(
      HttpMethod.get,
      '/car-data/hot-topics',
      query: {'take': '$take', 'skip': '$skip'},
    );
    return data.map(HotTopic.fromJson).toList();
  }

  /// Search trims
  Future<List<CarTrimSummary>> searchTrims(
    String query, {
    int limit = 20,
  }) async {
    return getTrims(TrimFilters(search: query, take: limit));
  }

  /// Get single trim detail
  Future<CarTrim> getTrim(int id) async {
    final data = await _client.request(HttpMethod.get, '/car-data/trims/$id');
    return CarTrim.fromJson(data);
  }

  Future<List<CarTrimSummary>> getSimilarTrims(
    int trimId, {
    int take = 5,
    int skip = 0,
  }) async {
    final data = await _client.requestList(
      HttpMethod.get,
      '/car-data/trims/$trimId/similar',
      query: {'take': '$take', 'skip': '$skip'},
    );
    return data.map(CarTrimSummary.fromJson).toList();
  }

  Future<List<CarTrimSummary>> getAlsoLikedTrims(
    int trimId, {
    int take = 5,
    int skip = 0,
  }) async {
    final data = await _client.requestList(
      HttpMethod.get,
      '/car-data/trims/$trimId/also-liked',
      query: {'take': '$take', 'skip': '$skip'},
    );
    return data.map(CarTrimSummary.fromJson).toList();
  }
}
