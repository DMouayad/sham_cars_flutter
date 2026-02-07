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
    final (_, token) = await _client
        .request(
          HttpMethod.post,
          ApiRoutes.authRoutes.login,
          body: {'email': req.emailOrPhone, 'password': req.password},
        )
        .then(_decodeLoginResponse);

    await _tokensRepository.store(token);

    final user = await _apiUserRepository.getUser(token);
    if (user == null) throw AppError.undefined;

    await _localUserRepository.saveCurrentUser(user);
    return user;
  }

  @override
  Future<void> logOut() async {
    final token = await _tokensRepository.get();
    if (token == null) return;

    try {
      await _client.request(
        HttpMethod.post,
        ApiRoutes.authRoutes.logout,
        accessToken: token,
      );
    } finally {
      await _tokensRepository.store(null);
      await _localUserRepository.clearCurrentUser();
    }
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
    await _localUserRepository.saveCurrentUser(user);
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
    final user = await _apiUserRepository.getUser(token);
    if (user != null) {
      await _localUserRepository.saveCurrentUser(user);
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

  @override
  Future<void> forgotPassword(String email) async {
    await _client.request(
      HttpMethod.post,
      ApiRoutes.authRoutes.forgotPassword,
      body: {'email': email},
    );
  }

  @override
  Future<void> resetPassword(
    String token,
    String password,
    String passwordConfirmation,
  ) async {
    await _client.request(
      HttpMethod.post,
      ApiRoutes.authRoutes.resetPassword,
      body: {
        'token': token,
        'password': password,
        'password_c': passwordConfirmation,
      },
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
