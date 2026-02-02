import 'package:sham_cars/api/endpoints.dart';
import 'package:sham_cars/api/rest_client.dart';
import 'package:sham_cars/features/user/models/user.dart';

import 'models/role.dart';

class ApiUserRepository {
  final RestClient _client;

  ApiUserRepository(this._client);
  Future<User?> getUser(String token) async {
    final data = await _client.request(
      HttpMethod.get,
      ApiRoutes.userRoutes.currentUser,
      accessToken: token,
    );
    if (data case {
      'id': int id,
      'name': String name,
      'email': String email,
      'phone': String phone,
      'photo': _,
      "is_followed": _,
      "following_count": _,
    }) {
      return User(
        id: id.toString(),
        role: Role.user,
        activated: true,
        email: email,
        phoneNumber: phone,
        fullName: name,
        emailVerifiedAt: null,
        phoneNumberVerifiedAt: null,
        createdAt: DateTime.now(),
        identityConfirmedAt: null,
      );
    }
    return null;
  }
}
