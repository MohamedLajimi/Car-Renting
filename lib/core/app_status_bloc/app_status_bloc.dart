import 'package:car_renting/features/auth/models/user_model.dart';
import 'package:car_renting/features/auth/repositories/i_auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_status_event.dart';
part 'app_status_state.dart';

class AppStatusBloc extends Bloc<AppStatusEvent, AppStatusState> {
  final IAuthRepository _authRepository;
  AppStatusBloc({required IAuthRepository authRepository})
    : _authRepository = authRepository,
      super(AppStatusInitial()) {
    on<AppStarted>(_onAppStarted);
    on<AppUserChanged>(_onUserChanged);
    on<AppLogoutRequested>(_onLogoutRequested);
    on<OnboardingCompleted>(_onOnboardingCompleted);
  }

  Future<void> _onAppStarted(
    AppStarted event,
    Emitter<AppStatusState> emit,
  ) async {
    if (_authRepository.isFirstTime()) {
      return emit(AppStatusOnboardingRequired());
    }

    final result = await _authRepository.getCurrentUserData();

    result.fold(
      (failure) => emit(AppStatusUnauthenticated()),
      (user) => emit(AppStatusAuthenticated(user)),
    );
  }

  void _onUserChanged(AppUserChanged event, Emitter<AppStatusState> emit) {
    emit(AppStatusAuthenticated(event.user));
  }

  Future<void> _onOnboardingCompleted(
    OnboardingCompleted event,
    Emitter<AppStatusState> emit,
  ) async {
    await _authRepository.makeOnboardingComplete();
    emit(AppStatusUnauthenticated());
  }

  Future<void> _onLogoutRequested(
    AppLogoutRequested event,
    Emitter<AppStatusState> emit,
  ) async {
    await _authRepository.logout();
    emit(AppStatusUnauthenticated());
  }
}
