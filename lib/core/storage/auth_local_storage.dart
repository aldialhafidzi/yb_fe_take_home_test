import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yb_fe_take_home_test/core/models/user_model.dart';

class AuthLocalStorage {
  static const _usersKey = 'users';
  static const _currentUserKey = 'current_user';

  Future<List<User>> getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_usersKey);

    if (jsonString == null) return [];

    final List decoded = jsonDecode(jsonString);
    return decoded.map((e) => User.fromJson(e)).toList();
  }

  Future<void> saveUsers(List<User> users) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
      _usersKey,
      jsonEncode(users.map((e) => e.toJson()).toList()),
    );
  }

  Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_currentUserKey);

    final users = await getUsers();

    if (jsonString == null) return null;

    try {
      final decoded = jsonDecode(jsonString);
      final User user = User.fromJson(decoded);
      final findUser = users.firstWhere((u) => u.email == user.email);

      return findUser;
    } catch (e) {
      print('[getCurrentUser]: ${e.toString()}');
      return null;
    }
  }

  Future<void> setCurrentUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_currentUserKey, jsonEncode(user));
  }

  Future<void> clearCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_currentUserKey);
  }
}
