import 'package:sham_cars/api/paginated_items.dart';
import 'package:sham_cars/api/endpoints.dart';
import 'package:sham_cars/api/rest_client.dart';

import 'models.dart';

typedef MedicalSpecialties = PaginatedItems<MedicalSpecialty>;
typedef MedicalProcedures = PaginatedItems<MedicalProcedure>;
typedef MedicalDepartments = PaginatedItems<MedicalDepartment>;
typedef MedicalConditions = PaginatedItems<MedicalCondition>;

abstract class IMedicalEntitiesRepository {
  Future<MedicalSpecialties> getSpecialties();
  Future<MedicalProcedures> getProcedures();
  Future<MedicalDepartments> getDepartments();
  Future<MedicalConditions> getConditions();
}

class ApiMedicalEntitiesRepository extends IMedicalEntitiesRepository {
  @override
  Future<MedicalSpecialties> getSpecialties() {
    return RestClient.instance
        .request(HttpMethod.get, ApiRoutes.specialtiesRoute)
        .then((json) {
          return MedicalSpecialties.fromJson(
            json,
            (item) => MedicalEntity.fromJson<MedicalSpecialty>(item),
          );
        });
  }

  @override
  Future<MedicalConditions> getConditions() {
    return RestClient.instance
        .request(HttpMethod.get, ApiRoutes.conditionsRoute)
        .then((json) {
          final MedicalConditions conditions = MedicalConditions.fromJson(
            json,
            MedicalEntity.fromJson,
          );
          return conditions;
        });
  }

  @override
  Future<MedicalDepartments> getDepartments() {
    return RestClient.instance
        .request(HttpMethod.get, ApiRoutes.departmentsRoute)
        .then((json) {
          final MedicalDepartments departments = MedicalDepartments.fromJson(
            json,
            MedicalEntity.fromJson,
          );
          return departments;
        });
  }

  @override
  Future<MedicalProcedures> getProcedures() {
    return RestClient.instance
        .request(HttpMethod.get, ApiRoutes.proceduresRoute)
        .then((json) {
          final MedicalProcedures procedures = MedicalProcedures.fromJson(
            json,
            MedicalEntity.fromJson,
          );
          return procedures;
        });
  }
}
