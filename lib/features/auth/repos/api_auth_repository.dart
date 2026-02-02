part of '../repositories.dart';

final class AuthRepository extends IAuthRepository {
  AuthRepository(
    this._client,
    this._tokensRepository,
    this._localUserRepository,
    this._apiUserRepository,
  );
  final LocalUserRepository _localUserRepository;
  final ITokensRepository _tokensRepository;
  final ApiUserRepository _apiUserRepository;
  final RestClient _client;

  @override
  Future<User> logIn(LoginRequest req) async {
    final (username, token) = await _client
        .request(
          HttpMethod.post,
          ApiRoutes.authRoutes.login,
          body: {'email': req.emailOrPhone, 'password': req.password},
        )
        .then(_decodeLoginResponse);
    await _tokensRepository.store(token);

    User? user = await _localUserRepository.findByEmail(req.emailOrPhone);
    if (user == null) {
      user = await _apiUserRepository.getUser(token);
      if (user != null) {
        await _localUserRepository.saveUser(user);
      }
    }
    if (user == null) {
      throw AppError.undefined;
    }
    return user;
  }

  @override
  Future<void> logOut() async {
    final accessToken = await _tokensRepository.get();
    if (accessToken == null) {
      return;
    }
    return _client
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
  Future<User> signup(SignupRequest req) async {
    final reqBody = {
      'name': req.name,
      'email': req.email,
      'phone': req.phone,
      'password': req.password,
      'c_password': req.password,
    };

    await _client.request(
      HttpMethod.post,
      ApiRoutes.authRoutes.signup,
      body: reqBody,
    );
    final user = User(
      role: Role.user,
      activated: true,
      email: req.email,
      phoneNumber: req.phone,
      fullName: req.name,
      emailVerifiedAt: null,
      phoneNumberVerifiedAt: null,
      createdAt: DateTime.now(),
      identityConfirmedAt: null,
    );
    await _localUserRepository.saveUser(user);
    return user;
  }

  @override
  Future<User> verifyAccount(VerifyAccountRequest req) async {
    final reqBody = {'email': req.email, 'email_otp': req.code};
    final data = await _client.request(
      HttpMethod.post,
      ApiRoutes.authRoutes.verifyAccount,
      body: reqBody,
    );
    final token = data['token'];
    if (token is! String) {
      throw AppError.signupFailed;
    }
    await _tokensRepository.store(token);
    User? user = await _localUserRepository.findByEmail(req.email);
    if (user == null) {
      user = await _apiUserRepository.getUser(token);
      if (user != null) {
        await _localUserRepository.saveUser(user);
      }
    }

    return user!;
  }

  @override
  Future<void> resendVerificationCode(String email) async {
    final reqBody = {'email': email};
    await _client.request(
      HttpMethod.post,
      ApiRoutes.authRoutes.requestVerificationCode,
      body: reqBody,
    );
  }

  (String username, String token) _decodeLoginResponse(JsonObject value) {
    if (value case {'token': String token, 'name': String username}) {
      return (username, token);
    }
    sLogger.e('Invalid login response: $value');
    throw AppError.serverError;
  }
}
