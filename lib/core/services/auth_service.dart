import 'package:yb_fe_take_home_test/core/models/user_model.dart';
import 'package:yb_fe_take_home_test/core/storage/auth_local_storage.dart';

class AuthService {
  final AuthLocalStorage _storage = AuthLocalStorage();

  Future<User?> loadCurrentUser() async {
    return _storage.getCurrentUser();
  }

  Future<List<User>> loadUsers() async {
    return await _storage.getUsers();
  }

  Future<void> register(String email, String name, String password) async {
    await Future.delayed(Duration(seconds: 1));

    final users = await _storage.getUsers();

    if (users.any((u) => u.email == email)) {
      throw Exception('User already exists');
    }

    users.add(
      User(
        email: email,
        name: name,
        password: password,
        isLoggedIn: false,
        isVerified: false,
      ),
    );

    await _storage.saveUsers(users);
  }

  Future<User> login(String email, String password) async {
    await Future.delayed(Duration(seconds: 1));

    final users = await _storage.getUsers();

    var user = users.firstWhere(
      (u) => u.email == email && u.password == password,
      orElse: () => throw Exception('Invalid credentials'),
    );

    user = user.copyWith(isLoggedIn: true);

    await _storage.setCurrentUser(user);
    return user;
  }

  Future<User> forgotPassword(String email) async {
    await Future.delayed(Duration(seconds: 1));

    final users = await _storage.getUsers();

    final user = users.firstWhere(
      (u) => u.email == email,
      orElse: () => throw Exception('Invalid email'),
    );

    return user;
  }

  Future<void> resetPassword(String email, String password) async {
    await Future.delayed(Duration(seconds: 1));

    final users = await _storage.getUsers();

    users.firstWhere(
      (u) => u.email == email,
      orElse: () => throw Exception('Invalid email'),
    );

    print('email $email');
    print('password $password');

    final updated = users.map((u) {
      if (u.email == email) {
        return u.copyWith(isVerified: true, password: password);
      }
      return u;
    }).toList();

    await _storage.saveUsers(updated);
  }

  Future<User> verifyOtp(String otp) async {
    await Future.delayed(Duration(seconds: 1));

    final users = await _storage.getUsers();
    var current = await _storage.getCurrentUser();

    if (current == null) throw Exception('User not found');
    if (otp != '1234') throw Exception('Invalid OTP');

    final updated = users.map((u) {
      if (u.email == current!.email) {
        return u.copyWith(isVerified: true, isLoggedIn: true);
      }
      return u;
    }).toList();

    current = current.copyWith(isVerified: true, isLoggedIn: true);
    await _storage.saveUsers(updated);
    await _storage.setCurrentUser(current);

    return current;
  }

  Future<void> logout() async {
    await _storage.clearCurrentUser();
  }
}
