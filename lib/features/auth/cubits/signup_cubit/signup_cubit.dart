import 'package:car_renting/features/auth/models/signup_params.dart';
import 'package:car_renting/features/auth/models/user_model.dart';
import 'package:car_renting/features/auth/repositories/i_auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final IAuthRepository _authRepository;
  SignupCubit({required IAuthRepository authRepository})
    : _authRepository = authRepository,
      super(const SignupState());

  void updatePasswordVisibility(bool visiblePassword) =>
      emit(state.copyWith(visiblePassword: visiblePassword));
  void updateRole(UserRole role) => emit(state.copyWith(role: role));
  void updateAvatar(String? url) => emit(state.copyWith(avatarUrl: url));
  void updateLicense(String? url) => emit(state.copyWith(licenseUrl: url));

  Future<void> signupWithEmailAndPassword(SignUpParams params) async {
    emit(state.copyWith(status: SignupStatus.loading));

    final result = await _authRepository.signupWithEmailAndPassword(
      params: params,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: SignupStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (user) => emit(
        state.copyWith(
          status: SignupStatus.success,
          user: user,
          withGoogle: false,
        ),
      ),
    );
  }

  Future<void> signupWithGoogle() async {
    emit(state.copyWith(status: SignupStatus.loading));

    final result = await _authRepository.signupWithGoogle();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: SignupStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (user) => emit(
        state.copyWith(
          status: SignupStatus.success,
          user: user,
          withGoogle: true,
        ),
      ),
    );
  }

  void reset() {
    emit(
      state.copyWith(
        status: SignupStatus.initial,
        errorMessage: null,
        withGoogle: null,
      ),
    );
  }
}
