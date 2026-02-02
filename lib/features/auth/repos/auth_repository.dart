part of '../repositories.dart';

abstract class IAuthRepository {
  IAuthRepository();

  Future<User> signup(SignupRequest req);
  Future<User> verifyAccount(VerifyAccountRequest req);
  Future<User> logIn(LoginRequest req);
  Future<void> logOut();
  Future<void> resendVerificationCode(String email);
}
