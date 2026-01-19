class User {
  final String name;
  final String email;
  final String password;
  final bool isVerified;
  final bool isLoggedIn;

  User({
    required this.name,
    required this.email,
    required this.password,
    required this.isLoggedIn,
    this.isVerified = false,
  });

  @override
  String toString() {
    return 'User(name: $name, email: $email, password: $password, isLoggedIn: $isLoggedIn, isVerified: $isVerified)';
  }

  User copyWith({bool? isVerified, bool? isLoggedIn}) {
    return User(
      name: name,
      email: email,
      password: password,
      isVerified: isVerified ?? this.isVerified,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    );
  }
}
