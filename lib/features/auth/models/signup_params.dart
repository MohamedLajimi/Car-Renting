import 'package:car_renting/features/auth/models/user_model.dart';

class SignUpParams {
  final String email;
  final String password;
  final String fullName;
  final String phoneNumber;
  final UserRole role;
  final String? avatarUrl;
  final String? licenceUrl;

  const SignUpParams({
    required this.email,
    required this.password,
    required this.fullName,
    required this.phoneNumber,
    required this.role,
    this.avatarUrl,
    this.licenceUrl,
  });
}