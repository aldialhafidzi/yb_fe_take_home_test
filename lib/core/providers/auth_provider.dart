import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:yb_fe_take_home_test/core/models/user_model.dart';
import 'package:yb_fe_take_home_test/core/services/auth_service.dart';

final authServiceProvider = Provider((ref) => AuthService());

final authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<User?>>(
  (ref) => AuthNotifier(ref.read(authServiceProvider)),
);

class AuthNotifier extends StateNotifier<AsyncValue<User?>> {
  final AuthService _repo;

  AuthNotifier(this._repo) : super(const AsyncLoading()) {
    _load();
  }

  Future<void> _load() async {
    final user = await _repo.loadCurrentUser();
    if (user != null) state = AsyncData(user);
  }

  Future<void> register(String email, String password, String name) async {
    await _repo.register(email, password, name);
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    final user = await _repo.login(email, password);
    state = AsyncData(user);
  }

  Future<void> verifyOtp(String otp) async {
    final user = await _repo.verifyOtp(otp);
    state = AsyncData(user);
  }

  Future<void> forgotPassword(String email) async {
    await _repo.forgotPassword(email);
  }

  Future<void> resetPassword(String email, String password) async {
    await _repo.resetPassword(email, password);
  }

  Future<void> logout() async {
    await _repo.logout();
    state = const AsyncData(null);
  }

  void initState() async {
    final users = await _repo.loadUsers();

    if (users.any((u) => u.email == 'test@mail.com')) {
      return;
    }

    await _repo.register('test@mail.com', 'Aldi Alhafidzi', 'a12345678');
  }
}
