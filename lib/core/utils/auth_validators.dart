class AuthValidators {
  static String? email(String? value, String errorText) {
    if (value == null || value.isEmpty) return errorText;
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return errorText;
    }
    return null;
  }

  static String? password(String? value, String errorText) {
    if (value == null || value.isEmpty) return errorText;
    if (value.length < 8) return errorText;

    if (!value.contains(RegExp(r'[A-Z]'))) {
      return errorText;
    }

    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<> ]'))) {
      return errorText;
    }

    return null;
  }
}