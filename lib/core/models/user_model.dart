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

  User copyWith({
    bool? isVerified,
    bool? isLoggedIn,
    String? name,
    String? email,
    String? password,
  }) {
    return User(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      isVerified: isVerified ?? this.isVerified,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'password': password,
    'isVerified': isVerified,
    'isLoggedIn': isLoggedIn,
  };

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      password: json['password'],
      email: json['email'],
      isLoggedIn: json['isLoggedIn'],
      isVerified: json['isVerified'],
    );
  }
}
