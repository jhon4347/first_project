class Validators {
  // Regular expressions should be constants for easier maintenance and readability
  static final RegExp _emailRegExp =
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  static final RegExp _passwordRegExp =
      RegExp(r'^(?=.*[A-Z])(?=.*\d)[A-Za-z\d@$!%*?&]{8,}$');
  static final RegExp _phoneRegExp = RegExp(r'^[0-9]{10}$');
  static final RegExp _usernameRegExp = RegExp(r'^[a-zA-Z0-9_]+$');

  // Validate email format
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email cannot be empty';
    }
    if (!_emailRegExp.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null; // Valid email
  }

  // Validate password (at least 8 characters, 1 uppercase, 1 number)
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    }
    if (!_passwordRegExp.hasMatch(value)) {
      return 'Password must be at least 8 characters long, contain an uppercase letter, and a number';
    }
    return null; // Valid password
  }

  // Validate phone number (basic validation for 10 digits)
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number cannot be empty';
    }
    if (!_phoneRegExp.hasMatch(value)) {
      return 'Enter a valid phone number with 10 digits';
    }
    return null; // Valid phone number
  }

  // Validate username (only allows alphanumeric and underscores)
  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username cannot be empty';
    }
    if (!_usernameRegExp.hasMatch(value)) {
      return 'Username can only contain letters, numbers, and underscores';
    }
    return null; // Valid username
  }

  // Validate if a string is not empty
  static String? validateNotEmpty(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName cannot be empty';
    }
    return null; // Field is not empty
  }

  // Validate if the password and confirmation password match
  static String? validatePasswordMatch(String? value, String? confirmPassword) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    }
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Confirm password cannot be empty';
    }
    if (value != confirmPassword) {
      return 'Passwords do not match';
    }
    return null; // Passwords match
  }
}
