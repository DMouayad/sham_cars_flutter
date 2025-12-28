part of '../repositories.dart';

final class AuthRepository extends IAuthRepository {
  AuthRepository(this._tokensRepository, this._localUserRepository);
  final LocalUserRepository _localUserRepository;
  final ITokensRepository _tokensRepository;

  @override
  Future<User> logIn(LoginRequest req) async {
    final (username, token) = await RestClient.instance
        .request(
          HttpMethod.post,
          ApiRoutes.authRoutes.login,
          body: {'email': req.emailOrPhone, 'password': req.password},
        )
        .then(_decodeLoginResponse);
    final user = await _localUserRepository.getUser(username);
    if (user == null) {
      throw AppError.unauthenticated;
    }
    await _tokensRepository.store(token);
    return user;
  }

  @override
  Future<void> logOut() async {
    final accessToken = await _tokensRepository.get();
    if (accessToken == null) {
      return;
    }
    return RestClient.instance
        .request(
          HttpMethod.post,
          ApiRoutes.authRoutes.logout,
          accessToken: accessToken,
        )
        .catchError((err, st) async {
          if (err case ApiError apiError
              when apiError.appErr == AppError.invalidPat) {
            await _tokensRepository.store(null);
            return Future<JsonObject>.value({});
          } else {
            return Future<JsonObject>.error(err, st);
          }
        })
        .then((_) {});
  }

  @override
  Future<void> signup(SignupRequest req) async {
    final reqBody = {
      'name': req.name,
      'email': req.email,
      'phone': req.phone,
      'password': req.password,
      'c_password': req.password,
    };

    await RestClient.instance.request(
      HttpMethod.post,
      ApiRoutes.authRoutes.signup,
      body: reqBody,
    );
  }

  @override
  Future<void> verifyAccount(VerifyAccountRequest req) async {
    final reqBody = {'email': req.email, 'email_otp': req.code};
    return RestClient.instance
        .request(
          HttpMethod.post,
          ApiRoutes.authRoutes.verifyAccount,
          body: reqBody,
        )
        .then((res) {});
    // .then(decodeAuthorizedUserResponse);
    // securely store the token
    // return _tokensRepository.store(token).then((_) => _updateState(user));
  }

  (String username, String token) _decodeLoginResponse(JsonObject value) {
    if (value['data'] case {'token': String token, 'name': String username}) {
      return (username, token);
    }
    sLogger.e('Invalid login response: $value');
    throw AppError.serverError;
  }
}
