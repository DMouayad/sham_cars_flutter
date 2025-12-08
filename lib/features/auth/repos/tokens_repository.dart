part of '../repositories.dart';

abstract class ITokensRepository {
  final _tokenKey = 'PAT';
  Future<String?> get();
  Future<void> store(String? token);
}

final class TokensRepository extends ITokensRepository {
  late final FlutterSecureStorage _storage;
  TokensRepository() {
    _storage = const FlutterSecureStorage();
  }

  @override
  Future<String?> get() async {
    return await _storage.read(key: _tokenKey);
  }

  @override
  Future<void> store(String? token) async {
    return await _storage.write(key: _tokenKey, value: token);
  }
}
