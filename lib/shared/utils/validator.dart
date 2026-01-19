// lib/utils/validator.dart
class Validator {
  static String? required(String? value, {String fieldName = 'Field'}) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? email(String? value, {String fieldName = 'Email'}) {
    if (value == null || value.isEmpty) return '$fieldName is required';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return 'Invalid $fieldName';
    return null;
  }

  static String? minLength(
    String? value,
    int length, {
    String fieldName = 'Field',
  }) {
    if (value == null || value.isEmpty) return '$fieldName is required';
    if (value.length < length) {
      return '$fieldName must be at least $length characters';
    }
    return null;
  }

  static String? password(String? value, {String fieldName = 'Password'}) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }

    if (value.length < 8) {
      return '$fieldName must be at least 8 characters';
    }

    final hasLetter = RegExp(r'[A-Za-z]').hasMatch(value);
    final hasNumber = RegExp(r'\d').hasMatch(value);
    final hasSymbol = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value);

    if (!hasLetter || !hasNumber || !hasSymbol) {
      return '$fieldName must contain letters, numbers and symbols';
    }

    return null;
  }

  static String? confirmPassword(
    String? value,
    String? password, {
    String fieldName = 'Password',
  }) {
    if (value == null || value.isEmpty) return '$fieldName is required';
    if (value != password) return '$fieldName must be match with password';
    // Bisa tambah regex untuk kombinasi huruf/angka/simbol
    return null;
  }
}
