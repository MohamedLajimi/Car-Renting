part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

final class AuthCheckOnboardingStatus extends AuthEvent {}

final class AuthSetOnboardingComplete extends AuthEvent {}

final class AuthCheckUserStatus extends AuthEvent{}
