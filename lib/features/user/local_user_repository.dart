import 'dart:convert';

import 'package:sham_cars/features/user/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalUserRepository {
  LocalUserRepository();
  final _prefs = SharedPreferencesAsync();
  Future<void> saveUser(User user) async {
    await _prefs.setString('${user.fullName}_user', jsonEncode(user.toJson()));
  }

  Future<User?> getUser(String userName) async {
    final userJson = await _prefs.getString('${userName}_user');
    return userJson != null ? User.fromJsonObj(jsonDecode(userJson)) : null;
  }
}
