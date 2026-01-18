import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';

class AuthNotifier extends ChangeNotifier {
  User? _user;
  bool isLoggedOTP = false;
  bool get isLoggedIn => _user != null;
  User? get user => _user;

  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    if (email == 'test@mail.com' && password == 'a12345678') {
      _user = User(email: email, name: 'Aldi Alhafidzi');
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> loginOTP(String otp) async {
    await Future.delayed(const Duration(seconds: 1));
    if (otp == '1234') {
      isLoggedOTP = true;
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
    isLoggedOTP = false;
    notifyListeners();
  }
}

final authProvider = ChangeNotifierProvider<AuthNotifier>((ref) {
  return AuthNotifier();
});
