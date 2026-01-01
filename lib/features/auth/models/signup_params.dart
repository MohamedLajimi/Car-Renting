import 'package:car_renting/features/auth/models/user_model.dart';

class SignUpParams {
  final String email;
  final String password;
  final String fullName;
  final String phoneNumber;
  final UserRole role;

  SignUpParams({
    required this.email,
    required this.password,
    required this.fullName,
    required this.phoneNumber,
    required this.role,
  });
}