import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yb_fe_take_home_test/core/models/auth_model.dart';
import '../models/user_model.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState());

  User? _registeredUser;
  User? get user => _registeredUser;

  Future<bool> register(String name, String email, String password) async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(Duration(seconds: 1));
    _registeredUser = User(
      name: name,
      email: email,
      password: password,
      isLoggedIn: false,
    );
    state = state.copyWith(isLoading: false);

    return true;
  }

  Future<int> login(String email, String password) async {
    state = state.copyWith(isLoading: true);

    await Future.delayed(Duration(seconds: 1));

    if (_registeredUser == null ||
        _registeredUser!.email != email ||
        _registeredUser!.password != password) {
      state = state.copyWith(
        isLoading: false,
        error: 'Wrong email or password!',
      );
      return 999;
    }

    _registeredUser = _registeredUser!.copyWith(isLoggedIn: true);
    state = state.copyWith(isLoading: false, user: _registeredUser);

    return _registeredUser!.isVerified ? 100 : 200;
  }

  Future<int> forgotPassword(String email) async {
    state = state.copyWith(isLoading: true);

    await Future.delayed(Duration(seconds: 1));

    if (_registeredUser == null || _registeredUser!.email != email) {
      state = state.copyWith(isLoading: false, error: 'Wrong email!');
      return 999;
    }

    _registeredUser = _registeredUser!.copyWith(email: email);

    state = state.copyWith(isLoading: false, user: _registeredUser);

    return 200;
  }

  Future<bool> resetPassword(String newPassword) async {
    state = state.copyWith(isLoading: true);

    await Future.delayed(Duration(seconds: 1));
    _registeredUser = _registeredUser!.copyWith(password: newPassword);

    state = state.copyWith(isLoading: false, user: _registeredUser);

    return true;
  }

  Future<bool> verifyOtp(String otp) async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(Duration(seconds: 1));

    if (otp == '1234') {
      _registeredUser = _registeredUser!.copyWith(isVerified: true);
      state = state.copyWith(isLoading: false, user: _registeredUser);
      return true;
    }

    return false;
  }

  void logout() {
    _registeredUser = _registeredUser!.copyWith(isLoggedIn: false);
    state = AuthState();
  }

  void initState() {
    if (_registeredUser?.email != 'test@mail.com' && _registeredUser == null) {
      _registeredUser = User(
        email: 'test@mail.com',
        password: 'a12345678',
        name: 'Aldi Alhafidzi',
        isLoggedIn: false,
        isVerified: false,
      );
    }
  }
}
