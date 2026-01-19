import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:yb_fe_take_home_test/core/models/auth_model.dart';
import 'package:yb_fe_take_home_test/core/models/user_model.dart';
import 'package:yb_fe_take_home_test/core/services/auth_service.dart';

// final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
//   return AuthNotifier();
// });

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

    await _repo.register('test@mail.com', 'a12345678', 'Aldi Alhafidzi');
  }

  // AuthNotifier() : super(AuthState());

  // User? _registeredUser;
  // User? get user => _registeredUser;

  // Future<bool> register(String name, String email, String password) async {
  //   state = state.copyWith(isLoading: true);
  //   await Future.delayed(Duration(seconds: 1));
  //   _registeredUser = User(
  //     name: name,
  //     email: email,
  //     password: password,
  //     isLoggedIn: false,
  //   );
  //   state = state.copyWith(isLoading: false);

  //   return true;
  // }

  // Future<int> login(String email, String password) async {
  //   state = state.copyWith(isLoading: true);

  //   await Future.delayed(Duration(seconds: 1));

  //   if (_registeredUser == null ||
  //       _registeredUser!.email != email ||
  //       _registeredUser!.password != password) {
  //     state = state.copyWith(
  //       isLoading: false,
  //       error: 'Wrong email or password!',
  //     );
  //     return 999;
  //   }

  //   _registeredUser = _registeredUser!.copyWith(isLoggedIn: true);
  //   state = state.copyWith(isLoading: false, user: _registeredUser);

  //   return _registeredUser!.isVerified ? 100 : 200;
  // }

  // Future<int> forgotPassword(String email) async {
  //   state = state.copyWith(isLoading: true);

  //   await Future.delayed(Duration(seconds: 1));

  //   if (_registeredUser == null || _registeredUser!.email != email) {
  //     state = state.copyWith(isLoading: false, error: 'Wrong email!');
  //     return 999;
  //   }

  //   _registeredUser = _registeredUser!.copyWith(email: email);

  //   state = state.copyWith(isLoading: false, user: _registeredUser);

  //   return 200;
  // }

  // Future<bool> resetPassword(String newPassword) async {
  //   state = state.copyWith(isLoading: true);

  //   await Future.delayed(Duration(seconds: 1));
  //   _registeredUser = _registeredUser!.copyWith(password: newPassword);

  //   state = state.copyWith(isLoading: false, user: _registeredUser);

  //   return true;
  // }

  // Future<bool> verifyOtp(String otp) async {
  //   state = state.copyWith(isLoading: true);
  //   await Future.delayed(Duration(seconds: 1));

  //   if (otp == '1234') {
  //     _registeredUser = _registeredUser!.copyWith(isVerified: true);
  //     state = state.copyWith(isLoading: false, user: _registeredUser);
  //     return true;
  //   }

  //   return false;
  // }

  // void logout() {
  //   _registeredUser = _registeredUser!.copyWith(isLoggedIn: false);
  //   state = AuthState();
  // }

  // void initState() {
  //   if (_registeredUser?.email != 'test@mail.com' && _registeredUser == null) {
  //     _registeredUser = User(
  //       email: 'test@mail.com',
  //       password: 'a12345678',
  //       name: 'Aldi Alhafidzi',
  //       isLoggedIn: false,
  //       isVerified: false,
  //     );
  //   }
  // }
}
