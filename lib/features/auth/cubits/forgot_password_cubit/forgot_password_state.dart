part of 'forgot_password_cubit.dart';

enum ForgotPasswordStatus { initial, loading, success, error }

class ForgotPasswordState extends Equatable {
  final ForgotPasswordStatus status;
  final String? errorMessage;
  final int resendCountdown;
  final bool isResending;

  const ForgotPasswordState({
    this.status = ForgotPasswordStatus.initial,
    this.errorMessage,
    this.resendCountdown = 0,
    this.isResending = false,
  });

  ForgotPasswordState copyWith({
    ForgotPasswordStatus? status,
    String? errorMessage,
    int? resendCountdown,
    bool? isResending,
  }) {
    return ForgotPasswordState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      resendCountdown: resendCountdown ?? this.resendCountdown,
      isResending: isResending ?? this.isResending,
    );
  }

  @override
  List<Object?> get props => [
    status,
    errorMessage,
    resendCountdown,
    isResending,
  ];
}
