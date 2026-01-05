import 'dart:async';

import 'package:car_renting/features/auth/repositories/i_auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final IAuthRepository _authRepository;
  Timer? _timer;
  ForgotPasswordCubit({required IAuthRepository authRepository})
    : _authRepository = authRepository,
      super(const ForgotPasswordState());

  Future<void> sendResetLink(String email) async {
    if (email.isEmpty) return;

    if (state.status == ForgotPasswordStatus.success) {
      emit(state.copyWith(isResending: true));
    } else {
      emit(state.copyWith(status: ForgotPasswordStatus.loading));
    }

    final result = await _authRepository.forgotPassword(email: email);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ForgotPasswordStatus.error,
          errorMessage: failure.message,
          isResending: false,
        ),
      ),
      (_) {
        _startResendTimer();
      },
    );
  }

  void _startResendTimer() {
    _timer?.cancel();
    emit(
      state.copyWith(
        status: ForgotPasswordStatus.success,
        isResending: false,
        resendCountdown: 60,
      ),
    );
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.resendCountdown > 0) {
        emit(state.copyWith(resendCountdown: state.resendCountdown - 1));
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
