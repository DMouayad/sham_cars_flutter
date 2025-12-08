import 'package:sham_cars/api/endpoints.dart';
import 'package:sham_cars/api/rest_client.dart';
import 'package:sham_cars/utils/src/app_error.dart';
import 'package:sham_cars/features/medical_condition/medical_condition.dart';

typedef MedicalConditions = List<MedicalCondition>;

abstract class MedicalConditionRepository {
  Future<MedicalConditions> getAll();
}

class ApiMedicalConditionRepository extends MedicalConditionRepository {
  @override
  Future<MedicalConditions> getAll() {
    return RestClient.instance
        .request(HttpMethod.get, ApiRoutes.conditionsRoute)
        .then(_decodeResponseBody)
        .catchError(_handleError);
  }

  Future<MedicalConditions> _handleError(Object error, StackTrace trace) {
    return switch (error) {
      AppError.notFound => Future.value(MedicalConditions.empty()),
      _ => Future<MedicalConditions>.error(error),
    };
  }

  MedicalConditions _decodeResponseBody(JsonObject json) {
    if (json case {"\$values": List<JsonObject> items}) {
      return items.map(_fromJson).whereType<MedicalCondition>().toList();
    }
    return MedicalConditions.empty();
  }

  MedicalCondition? _fromJson(JsonObject json) {
    if (json case {
      "\$id": String _,
      "id": String id,
      "name": String name,
      "treatedByPhysicians": JsonObject treatedByPhysicians,
    }) {
      return MedicalCondition(
        id: id,
        name: name,
        treatedByPhysicianIds: _getTreatedByPhysicianIds(treatedByPhysicians),
      );
    }

    return null;
  }

  List<String> _getTreatedByPhysicianIds(JsonObject json) {
    final ids = List<String>.empty();
    if (json['\$values'] case List<JsonObject> items) {
      for (var item in items) {
        if (item['physicianId'] case String physicianId
            when (item['conditionId'] is String)) {
          ids.add(physicianId);
        }
      }
    }
    return ids;
  }
}
