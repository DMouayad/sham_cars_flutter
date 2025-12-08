import 'package:sham_cars/api/endpoints.dart';
import 'package:sham_cars/api/rest_client.dart';
import 'package:sham_cars/features/user/models.dart';

class ApiPhoneVerificationRepository {
  static const _code = '123456';
  Future<void> verify(String phoneNumber, Role role) {
    return RestClient.instance
        .request(
          HttpMethod.post,
          ApiRoutes.userRoutes.verifyPhone,
          body: {"code": _code, "phoneNumber": phoneNumber},
        )
        .then((_) {});
  }
}
