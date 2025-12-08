part of '../repositories.dart';

abstract class IAuthRepository {
  IAuthRepository();

  final _controller = StreamController<AuthState>.broadcast();
  Stream<AuthState> get state => _controller.stream;

  void _updateState(User? user) {
    final newState = user != null
        ? AuthState.authenticated(user)
        : AuthState.unauthenticated();
    _controller.add(newState);
  }

  Future<void> confirmIdentity(ConfirmIdentityRequest req);

  Future<void> signupWithEmail(StartSignupWithEmailRequest req);
  Future<void> signupWithPhone(StartSignupWithPhoneRequest req);
  Future<void> confirmSignupWithEmail(ConfirmSignupWithEmailRequest req);
  Future<void> confirmSignupWithPhone(ConfirmSignupWithPhoneRequest req);

  Future<void> logIn(LoginRequest req);

  Future<void> logOut();

  void dispose() => _controller.close();
}
