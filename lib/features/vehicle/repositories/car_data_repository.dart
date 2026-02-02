import 'package:sham_cars/api/rest_client.dart';
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

  Future<CarTrim> getTrim(int id) async {
    final data = await _client.request(HttpMethod.get, '/car-data/trims/$id');
    return CarTrim.fromJson(data);
  }
}
