import 'dart:async';

import 'package:flutter/material.dart';

import 'package:sham_cars/features/auth/repositories.dart';
import 'package:sham_cars/features/user/api_user_repository.dart';
import 'package:sham_cars/features/user/local_user_repository.dart';
import 'package:sham_cars/features/user/models/user.dart';
import 'package:sham_cars/utils/src/app_error.dart';

class AuthNotifier extends ChangeNotifier {
  AuthNotifier(
    this._authRepository,
    this._tokensRepository,
    this._localUserRepository,
    this._apiUserRepository,
  );
  final IAuthRepository _authRepository;
  final ITokensRepository _tokensRepository;
  final LocalUserRepository _localUserRepository;
  final ApiUserRepository _apiUserRepository;

  User? currentUser;
  bool get isLoggedIn => currentUser != null;

  bool shouldResetPassword = false;
  Timer? _passwordResetSessionTimer;

  void startPasswordResetSession() {
    shouldResetPassword = true;
    _passwordResetSessionTimer?.cancel();
    _passwordResetSessionTimer = Timer(
      const Duration(minutes: 10),
      _authRepository.logOut,
    );
    notifyListeners();
  }

  void endPasswordResetSession() {
    shouldResetPassword = false;
    _passwordResetSessionTimer?.cancel();
    notifyListeners();
  }

  void updateCurrentUser(User? user) {
    currentUser = user;
    notifyListeners();
  }

  Future<void> restoreSession() async {
    final token = await _tokensRepository.get();
    if (token == null) {
      setLoggedOut();
      return;
    }

    final cached = await _localUserRepository.loadCurrentUser();
    if (cached != null) {
      updateCurrentUser(cached); // immediate UI
    }

    try {
      final fresh = await _apiUserRepository.getUser(token);
      if (fresh == null) throw AppError.unauthenticated;

      await _localUserRepository.saveCurrentUser(fresh);
      updateCurrentUser(fresh);
    } catch (_) {
      await _tokensRepository.store(null);
      await _localUserRepository.clearCurrentUser();
      setLoggedOut();
    }
  }

  void setLoggedOut() {
    updateCurrentUser(null);
  }

  @override
  void dispose() {
    _passwordResetSessionTimer?.cancel();
    super.dispose();
  }
}
