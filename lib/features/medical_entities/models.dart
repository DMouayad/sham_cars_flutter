import 'package:sham_cars/api/rest_client.dart';
import 'package:sham_cars/utils/src/app_error.dart';

sealed class MedicalEntity {
  final int id;
  final String name;

  const MedicalEntity({required this.id, required this.name});
  JsonObject toJson() => JsonObject.from({"id": id, "name": name});

  static T fromJson<T>(dynamic json) {
    if (json case {"id": int id, "name": String name}) {
      if (T == MedicalSpecialty) {
        return MedicalSpecialty(id: id, name: name) as T;
      }
      if (T == MedicalProcedure) {
        return MedicalProcedure(id: id, name: name) as T;
      }
      if (T == MedicalDepartment) {
        return MedicalDepartment(id: id, name: name) as T;
      }
      if (T == MedicalCondition) {
        return MedicalCondition(id: id, name: name) as T;
      }
    }
    throw AppError.decodingJsonFailed;
  }
}

class MedicalSpecialty extends MedicalEntity {
  const MedicalSpecialty({required super.id, required super.name});
}

class MedicalProcedure extends MedicalEntity {
  const MedicalProcedure({required super.id, required super.name});
}

class MedicalDepartment extends MedicalEntity {
  const MedicalDepartment({required super.id, required super.name});
}

class MedicalCondition extends MedicalEntity {
  const MedicalCondition({required super.id, required super.name});
}
