part of '../repositories.dart';

abstract class IAuthRepository {
  IAuthRepository();

  Future<void> signup(SignupRequest req);
  Future<void> verifyAccount(VerifyAccountRequest req);
  Future<User> logIn(LoginRequest req);
  Future<void> logOut();
}
