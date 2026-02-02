import 'package:sham_cars/api/endpoints.dart';
import 'package:sham_cars/api/rest_client.dart';
import 'package:sham_cars/features/user/models.dart';

class ApiPhoneVerificationRepository {
  final RestClient _client;
  static const _code = '123456';

  ApiPhoneVerificationRepository(this._client);

  Future<void> verify(String phoneNumber, Role role) {
    return _client
        .request(
          HttpMethod.post,
          ApiRoutes.authRoutes.verifyAccount,
          body: {"code": _code, "phoneNumber": phoneNumber},
        )
        .then((_) {});
  }
}
