import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sham_cars/features/user/models/user.dart';

class LocalUserRepository {
  LocalUserRepository();

  final _prefs = SharedPreferencesAsync();

  static const _kCurrentUser = 'current_user';

  Future<void> saveCurrentUser(User user) async {
    await _prefs.setString(_kCurrentUser, jsonEncode(user.toJson()));
  }

  Future<User?> loadCurrentUser() async {
    final userJson = await _prefs.getString(_kCurrentUser);
    return userJson != null ? User.fromJsonObj(jsonDecode(userJson)) : null;
  }

  Future<void> clearCurrentUser() async {
    await _prefs.remove(_kCurrentUser);
  }
}
