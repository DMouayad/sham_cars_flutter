import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'models.dart';

abstract class IPasswordResetTokenRepository {
  Future<void> store(PasswordResetSession session);
  Future<PasswordResetSession?> get();
  Future<void> clear();
}

class PasswordResetTokenRepository extends IPasswordResetTokenRepository {
  late final FlutterSecureStorage _storage;
  static const _tokenKey = 'password_reset_token';
  static const _tokenExpiaryKey = 'password_reset_expires_at';

  PasswordResetTokenRepository() {
    _storage = const FlutterSecureStorage();
  }

  @override
  Future<void> clear() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _tokenExpiaryKey);
  }

  @override
  Future<PasswordResetSession?> get() async {
    final token = await _storage.read(key: _tokenKey);
    final expiresAt = await _storage.read(key: _tokenExpiaryKey);
    if (token == null) {
      clear();
      return null;
    }
    return PasswordResetSession(
      token,
      expiresAt != null ? DateTime.tryParse(expiresAt) : null,
    );
  }

  @override
  Future<void> store(PasswordResetSession session) async {
    await _storage.write(key: _tokenKey, value: session.token);
    await _storage.write(
      key: _tokenExpiaryKey,
      value: session.expiresAt?.toIso8601String(),
    );
  }
}
