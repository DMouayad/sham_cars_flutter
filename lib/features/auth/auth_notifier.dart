import 'dart:async';

import 'package:flutter/material.dart';

import 'package:sham_cars/features/auth/repositories.dart';
import 'package:sham_cars/features/user/models/user.dart';

class AuthNotifier extends ChangeNotifier {
  AuthNotifier(this._authRepository);
  final IAuthRepository _authRepository;

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

  @override
  void dispose() {
    _passwordResetSessionTimer?.cancel();
    super.dispose();
  }
}
