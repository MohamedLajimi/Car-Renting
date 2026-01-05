part of 'signup_cubit.dart';

enum SignupStatus { initial, loading, success, error }

class SignupState extends Equatable {
  final SignupStatus status;
  final bool visiblePassword;
  final UserRole role;
  final String? avatarUrl;
  final String? licenseUrl;
  final String? errorMessage;
  final UserModel? user;
  final bool? withGoogle;

  const SignupState({
    this.status = SignupStatus.initial,
    this.visiblePassword=false,
    this.role = UserRole.renter,
    this.avatarUrl,
    this.licenseUrl,
    this.errorMessage,
    this.user,
    this.withGoogle,
  });

  SignupState copyWith({
    SignupStatus? status,
    bool? visiblePassword,
    UserRole? role,
    String? avatarUrl,
    String? licenseUrl,
    String? errorMessage,
    UserModel? user,
    bool? withGoogle,
  }) {
    return SignupState(
      status: status ?? this.status,
      visiblePassword: visiblePassword??this.visiblePassword,
      role: role ?? this.role,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      licenseUrl: licenseUrl ?? this.licenseUrl,
      errorMessage: errorMessage ?? this.errorMessage,
      user: user ?? this.user,
      withGoogle: withGoogle ?? this.withGoogle,
    );
  }

  @override
  List<Object?> get props => [
    status,
    visiblePassword,
    role,
    avatarUrl,
    licenseUrl,
    errorMessage,
    user,
    withGoogle,
  ];
}
