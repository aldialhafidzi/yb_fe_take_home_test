import 'package:shared_preferences/shared_preferences.dart';

class AuthStorage {
  static const _loggedInKey = 'is_logged_in';
  static const _verifiedKey = 'is_verified';

  final SharedPreferences prefs;

  AuthStorage(this.prefs);

  bool get isLoggedIn => prefs.getBool(_loggedInKey) ?? false;
  bool get isVerified => prefs.getBool(_verifiedKey) ?? false;

  Future<void> saveLogin(bool value) async {
    await prefs.setBool(_loggedInKey, value);
  }

  Future<void> saveVerified(bool value) async {
    await prefs.setBool(_verifiedKey, value);
  }

  Future<void> clear() async {
    await prefs.clear();
  }
}
