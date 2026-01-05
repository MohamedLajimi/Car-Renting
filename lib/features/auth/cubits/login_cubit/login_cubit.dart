import 'package:car_renting/features/auth/models/user_model.dart';
import 'package:car_renting/features/auth/repositories/i_auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final IAuthRepository _authRepository;
  LoginCubit({required IAuthRepository authRepository})
    : _authRepository = authRepository,
      super(const LoginState());

  void updatePasswordVisibility(bool visiblePassword) =>
      emit(state.copyWith(visiblePassword: visiblePassword));

  Future<void> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(status: LoginStatus.loading));

    final result = await _authRepository.loginWithEmailAndPassword(
      email: email,
      password: password,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: LoginStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (user) => emit(state.copyWith(status: LoginStatus.success, user: user)),
    );
  }

  Future<void> loginWithGoogle() async {
    emit(state.copyWith(status: LoginStatus.loading));

    final result = await _authRepository.loginWithGoogle();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: LoginStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (user) => emit(state.copyWith(status: LoginStatus.success, user: user)),
    );
  }

  void reset() {
    emit(state.copyWith(status: LoginStatus.initial, errorMessage: null));
  }
}
