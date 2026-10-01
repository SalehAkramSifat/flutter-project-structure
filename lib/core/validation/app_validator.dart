class AppValidator {
  AppValidator._();

  /// Validates standard email addresses (handles modern TLDs like .online, .tech, and trims whitespace)
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required.';
    }

    final trimmed = value.trim();
    final emailRegExp = RegExp(r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,}$');

    if (!emailRegExp.hasMatch(trimmed)) {
      return 'Please enter a valid email address.';
    }

    return null;
  }

  /// Standard password validator (ideal for login screens where strict rules should not block existing users)
  static String? validatePassword(String? value, {int minLength = 6}) {
    if (value == null || value.isEmpty) {
      return 'Password is required.';
    }

    if (value.length < minLength) {
      return 'Password must be at least $minLength characters long.';
    }

    return null;
  }

  /// Strong password validator (ideal for registration and change password screens)
  /// Enforces: min length, uppercase, lowercase, number, and special character
  static String? validateStrongPassword(String? value, {int minLength = 8}) {
    if (value == null || value.isEmpty) {
      return 'Password is required.';
    }

    if (value.length < minLength) {
      return 'Password must be at least $minLength characters long.';
    }

    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter.';
    }

    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter.';
    }

    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number.';
    }

    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character.';
    }

    return null;
  }

  /// Validates confirm password against the original password
  static String? validateConfirmPassword(
    String? value,
    String? originalPassword,
  ) {
    if (value == null || value.isEmpty) {
      return 'Confirm password is required.';
    }

    if (value != originalPassword) {
      return 'Passwords do not match.';
    }

    return null;
  }

  /// Validates required text fields (e.g. Title, Address, Description)
  static String? validateRequired(String? value, [String fieldName = 'Field']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required.';
    }
    return null;
  }

  /// Validates human names (letters, spaces, hyphens, min 2 chars)
  static String? validateName(String? value, [String fieldName = 'Name']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required.';
    }

    final trimmed = value.trim();
    if (trimmed.length < 2) {
      return '$fieldName must be at least 2 characters long.';
    }

    return null;
  }

  /// Flexible phone number validator (supports local format like `01712345678` or international `+8801712345678`)
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required.';
    }

    final trimmed = value.trim();
    final phoneRegExp = RegExp(r'^\+?[0-9]{8,15}$');

    if (!phoneRegExp.hasMatch(trimmed)) {
      return 'Please enter a valid phone number.';
    }

    return null;
  }

  /// Strict international phone number validator (must start with + and 8-15 digits)
  static String? validateInternationalPhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required.';
    }

    final trimmed = value.trim();
    final phoneRegExp = RegExp(r'^\+\d{8,15}$');

    if (!phoneRegExp.hasMatch(trimmed)) {
      return 'Invalid international phone format (e.g. +8801700000000).';
    }

    return null;
  }

  /// Validates minimum string length
  static String? validateMinLength(
    String? value,
    int minLength, [
    String fieldName = 'Field',
  ]) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required.';
    }

    if (value.trim().length < minLength) {
      return '$fieldName must be at least $minLength characters long.';
    }

    return null;
  }

  /// Validates numeric inputs (e.g. amount, quantity, age)
  static String? validateNumber(String? value, [String fieldName = 'Field']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required.';
    }

    if (num.tryParse(value.trim()) == null) {
      return 'Please enter a valid numeric value for $fieldName.';
    }

    return null;
  }

  /// Validates website or resource URLs (http/https)
  static String? validateUrl(String? value, [String fieldName = 'URL']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required.';
    }

    final trimmed = value.trim();
    final urlRegExp = RegExp(
      r'^(https?:\/\/)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );

    if (!urlRegExp.hasMatch(trimmed)) {
      return 'Please enter a valid URL.';
    }

    return null;
  }
}