part of 'app_status_bloc.dart';

sealed class AppStatusState extends Equatable {
  const AppStatusState();

  @override
  List<Object?> get props => [];
}

final class AppStatusInitial extends AppStatusState {}

class AppStatusOnboardingRequired extends AppStatusState {}

class AppStatusUnauthenticated extends AppStatusState {}

class AppStatusAuthenticated extends AppStatusState {
  final UserModel user;
  const AppStatusAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

class AppStatusError extends AppStatusState {
  final String message;
  const AppStatusError(this.message);

  @override
  List<Object?> get props => [message];
}
