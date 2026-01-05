part of 'login_cubit.dart';

enum LoginStatus { initial, loading, success, error }

class LoginState extends Equatable {
  final LoginStatus status;
  final bool visiblePassword;
  final String? errorMessage;
  final UserModel? user;

  const LoginState({
    this.status = LoginStatus.initial,
    this.visiblePassword=false,
    this.errorMessage,
    this.user,
  });

  LoginState copyWith({
    LoginStatus? status,
    bool? visiblePassword,
    String? errorMessage,
    UserModel? user,
  }) {
    return LoginState(
      status: status ?? this.status,
      visiblePassword: visiblePassword??this.visiblePassword,
      errorMessage: errorMessage ?? this.errorMessage,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [status,visiblePassword, errorMessage, user];
}
