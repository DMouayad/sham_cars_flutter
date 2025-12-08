part of '../repositories.dart';

final class AuthRepository extends IAuthRepository {
  AuthRepository();
  ITokensRepository get _tokensRepository => GetIt.I.get();

  @override
  Future<void> logIn(LoginRequest req) async {
    final (user, token) = await RestClient.instance
        .request(HttpMethod.post, ApiRoutes.authRoutes.login, body: {
      'emailOrPhoneNo': req.emailOrPhone,
      'password': req.password,
    }).then(decodeAuthorizedUserResponse);
    _updateState(user);
    _tokensRepository.store(token);
  }

  @override
  Future<void> logOut() async {
    final accessToken = await _tokensRepository.get();
    if (accessToken == null) {
      return _updateState(null);
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
        await _tokensRepository.store(null).then((_) => _updateState(null));
        return Future<JsonObject>.value({});
      } else {
        return Future<JsonObject>.error(err, st);
      }
    }).then((_) {
      return _tokensRepository.store(null).then((_) => _updateState(null));
    });
  }

  @override
  Future<void> confirmSignupWithEmail(ConfirmSignupWithEmailRequest req) async {
    final reqBody = {
      'signupConfirmationMethod': "EMAIL",
      'email': req.email,
      'role': req.role.name,
      'signupCode': req.signupCode,
      'password': req.password,
    };
    final (user, token) = await RestClient.instance
        .request(
          HttpMethod.post,
          ApiRoutes.authRoutes.signup,
          body: reqBody,
        )
        .then(decodeAuthorizedUserResponse);
    return _tokensRepository.store(token).then((_) => _updateState(user));
  }

  @override
  Future<void> confirmIdentity(ConfirmIdentityRequest req) {
    // TODO: implement confirmIdentity
    throw UnimplementedError();
  }

  @override
  Future<void> signupWithEmail(StartSignupWithEmailRequest req) async {
    final reqBody = {
      'receiveVia': "MAIL",
      'email': req.email,
      'role': req.role.name,
    };
    await RestClient.instance.request(
      HttpMethod.post,
      ApiRoutes.authRoutes.requestSignupCode,
      body: reqBody,
    );
  }

  @override
  Future<void> signupWithPhone(StartSignupWithPhoneRequest req) async {
    final reqBody = {
      'receiveVia': "SMS",
      'phoneNumber': req.phoneNumber,
      'role': req.role.name,
    };
    await RestClient.instance.request(
      HttpMethod.post,
      ApiRoutes.authRoutes.requestSignupCode,
      body: reqBody,
    );
  }

  (User user, String accessToken) decodeAuthorizedUserResponse(
    JsonObject json,
  ) {
    if (json case {'token': String token, 'user': JsonObject userJson}) {
      if (User.fromJsonObj(userJson) case User user) {
        return (user, token);
      }
    }
    pLogger.w(
      "Decoding Signup response failed,",
    );
    throw AppError.decodingJsonFailed;
  }

  @override
  Future<void> confirmSignupWithPhone(ConfirmSignupWithPhoneRequest req) async {
    final reqBody = {
      'signupConfirmationMethod': "PHONE",
      'phoneNumber': req.phoneNumber,
      'role': req.role.name,
      'signupCode': req.signupCode,
      'password': req.password,
    };
    final res = await RestClient.instance.request(
      HttpMethod.post,
      ApiRoutes.authRoutes.signup,
      body: reqBody,
    );
    final (user, token) = decodeAuthorizedUserResponse(res);
    // securely store the token
    return _tokensRepository.store(token).then((_) => _updateState(user));
  }
}
