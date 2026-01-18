import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';

class AuthNotifier extends ChangeNotifier {
  User? _user;
  bool get isLoggedIn => _user != null;
  User? get user => _user;

  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    if (email == 'test@mail.com' && password == '123456') {
      _user = User(email: email, name: 'Aldi');
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> register(String name, String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}

final authProvider = ChangeNotifierProvider<AuthNotifier>((ref) {
  return AuthNotifier();
});
