part of 'app_status_bloc.dart';

sealed class AppStatusEvent extends Equatable {
  const AppStatusEvent();

  @override
  List<Object?> get props => [];
}

class AppStarted extends AppStatusEvent {}

class OnboardingCompleted extends AppStatusEvent {}

class AppLogoutRequested extends AppStatusEvent {}

class AppUserChanged extends AppStatusEvent {
  final UserModel user;
  const AppUserChanged(this.user);
  @override
  List<Object?> get props => [user];
}
