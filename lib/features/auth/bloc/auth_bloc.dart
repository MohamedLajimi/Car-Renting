import 'package:car_renting/features/auth/repositories/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  AuthBloc({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(AuthInitial()) {
    on<AuthCheckOnboardingStatus>(_checkOnboardingStatus);
    on<AuthSetOnboardingComplete>(_setOnboardingComplete);
  }

  void _checkOnboardingStatus(
    AuthCheckOnboardingStatus event,
    Emitter<AuthState> emit,
  ) {
    final onboardingRequired = _authRepository.isFirstTime();
    final state = onboardingRequired
        ? AuthOnboardingRequired()
        : AuthCheckUserStateRequired();
    emit(state);
  }

  Future<void> _setOnboardingComplete(
    AuthSetOnboardingComplete event,
    Emitter<AuthState> emit,
  ) async {
    await _authRepository.makeOnboardingComplete();
  }
}
